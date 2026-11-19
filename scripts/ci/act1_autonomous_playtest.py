"""Run the Act 1 Godot harness in isolated processes and collect raw results."""

import argparse
import csv
import hashlib
import json
import os
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess

SCRIPT = "res://scripts/dev/act1_autonomous_playtest.gd"
ROLES = ("knight", "ranger", "mage")
STRATEGIES = ("aggressive", "defensive", "adaptive")
SEEDS = (61103, 61129, 61141, 61153, 61169)


def campaign_cases():
    for role in ROLES:
        for strategy in STRATEGIES:
            for seed in SEEDS:
                yield role, strategy, seed, "", 1, ""


def fixtures():
    # Matched tactic comparisons and party-size comparisons use the same inputs.
    for encounter in ("last_bell", "ossuary_gate"):
        for size in (1, 2, 3):
            for strategy in ("assault", "hunt"):
                for seed in (31017, 31031, 31039):
                    yield "knight", strategy, seed, encounter, size, ""
    for size, verdict in ((1, ""), (2, ""), (3, ""), (1, "witnessless"),
                          (3, "scarred"), (3, "riskbound")):
        for role in ("knight", "mage"):
            yield role, "adaptive", 31017, "bone_warden", size, verdict
    for encounter in ("iron_wall", "firing_square"):
        for size in (1, 2, 3):
            yield "knight", "adaptive", 31017, encounter, size, ""


def run_case(args, case):
    role, strategy, seed, encounter, size, verdict = case
    name = f"{role}_{strategy}_{seed}"
    if encounter:
        name += f"_{encounter}_{size}_{verdict or 'default'}"
    folder = args.output / "cases" / name
    folder.mkdir(parents=True, exist_ok=False)
    mode = ["--windowed", "--resolution", "1280x720"] if args.windowed else ["--headless"]
    clock = [] if args.realtime else ["--fixed-fps", "60"]
    command = [args.godot, *mode, *clock, "--path", ".", "--audio-driver", "Dummy",
               "--rendering-method", "gl_compatibility", "--script", SCRIPT,
               "--", str(folder), role, strategy, str(seed)]
    if encounter:
        command.extend([encounter, str(size), verdict])
    env = os.environ.copy()
    for key in ("APPDATA", "XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME"):
        env[key] = str(folder / "profile" / key)
    if args.paced:
        env["MISDEAL_ACT1_QA_PACE"] = "1"
    else:
        env.pop("MISDEAL_ACT1_QA_PACE", None)
    rc, timed_out = None, False
    with (folder / "engine.log").open("wb") as log:
        try:
            rc = subprocess.run(command, env=env, stdout=log, stderr=subprocess.STDOUT,
                                timeout=260, check=False).returncode
        except subprocess.TimeoutExpired:
            timed_out = True
    path = folder / "result.json"
    if path.is_file():
        data = json.loads(path.read_text(encoding="utf-8"))
    else:
        data = {
            "role": role, "strategy": strategy, "seed": seed, "fixture": encounter,
            "fixture_size": size, "fixture_verdict": verdict, "battles": [], "actions": [],
            "outcome": "time_limit" if timed_out else "technical_blocker",
            "reason": "External process deadline" if timed_out else "Godot exited without a result",
        }
    lines = (folder / "engine.log").read_text(encoding="utf-8", errors="replace").splitlines()
    data["script_errors"] = [line.strip() for line in lines if "SCRIPT ERROR:" in line]
    if data["script_errors"] and data["outcome"] in ("victory", "defeat"):
        data["observed_result"] = data["outcome"]
        data["outcome"] = "technical_blocker"
        data["reason"] = "GDScript error during the run"
    data["engine_log"] = f"cases/{name}/engine.log"
    data["exit_code"] = rc
    print(f"{name}: {data['outcome']} ({len(data['battles'])} observed battles)", flush=True)
    return data


def write_csv(path, rows, fields):
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def export(args, rows):
    files = ("scripts/dev/act1_autonomous_playtest.gd", "scripts/dev/act1_playtest_policy.gd",
             "scripts/ci/act1_autonomous_playtest.py")
    metadata = {
        "tested_checkout": subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip(),
        "runtime_base": subprocess.check_output(["git", "merge-base", "origin/main", "HEAD"],
                                                text=True).strip(),
        "harness_sha256": {name: hashlib.sha256(Path(name).read_bytes()).hexdigest() for name in files},
        "suite": args.suite,
        "clock": ("realtime" if args.realtime else
                  "paced_fixed_60" if args.paced else "fixed_60_no_time_scale"),
        "windowed": args.windowed,
        "attempts": len(rows),
    }
    (args.output / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    with (args.output / "results.jsonl").open("w", encoding="utf-8") as file:
        for row in rows:
            print(json.dumps(row, ensure_ascii=False, separators=(",", ":")), file=file)
    keys = ("role", "strategy", "seed", "fixture", "fixture_size", "fixture_verdict", "outcome")
    runs = []
    battles = []
    for row in rows:
        tag = {key: row.get(key, "") for key in keys}
        runs.append({**tag, "slots": row.get("final", {}).get("slot"),
                     "boss_reached": row.get("boss_reached", False), "wall_s": row.get("wall_s"),
                     "battle_count": len(row["battles"]), "reason": row.get("reason", "")})
        for battle in row["battles"]:
            battles.append({**tag, **{k: battle.get(k) for k in (
                "encounter", "slot", "won", "combat_s", "damage_out", "damage_in", "wave_count",
                "objective", "objective_completed", "verdict")},
                "party_size": len(battle["start"]["party"]),
                "phase_two": bool(battle["phase_two"])})
    write_csv(args.output / "runs.csv", runs, (*keys, "slots", "boss_reached", "wall_s", "battle_count", "reason"))
    write_csv(args.output / "battles.csv", battles, (*keys, "encounter", "slot", "won", "combat_s",
              "damage_out", "damage_in", "wave_count", "objective", "objective_completed",
              "verdict", "party_size", "phase_two"))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", required=True, help="Path to Godot 4.7.x console executable")
    parser.add_argument("--output", type=Path, required=True, help="New directory for results and logs")
    parser.add_argument("--suite", choices=("smoke", "campaign", "fixtures"), default="campaign")
    parser.add_argument("--jobs", type=int, default=3)
    parser.add_argument("--role", choices=ROLES, help="Run only this protagonist for a campaign shard")
    clock = parser.add_mutually_exclusive_group()
    clock.add_argument("--realtime", action="store_true", help="Use the engine's variable frame delta")
    clock.add_argument("--paced", action="store_true", help="Keep fixed steps and sleep to match real time")
    parser.add_argument("--windowed", action="store_true")
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    if args.suite == "smoke":
        cases = [("knight", "adaptive", SEEDS[0], "", 1, "")]
    elif args.suite == "fixtures":
        cases = list(fixtures())
    else:
        cases = [case for case in campaign_cases() if not args.role or case[0] == args.role]
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        rows = list(pool.map(lambda case: run_case(args, case), cases))
    export(args, rows)
    if args.suite == "smoke":
        row = rows[0]
        played = any(battle.get("combat_s", 0) > 0 and "won" in battle for battle in row["battles"])
        resumed = any(action["action"] == "save_continue_verified" and action["details"]["equal"]
                      for action in row["actions"])
        if row["outcome"] not in ("victory", "defeat") or not played or not resumed:
            raise SystemExit("Expected a real fight, safe Continue and terminal RunEnd")
        if not row["final_slot_finished"] or not row["final_scene"].endswith("/run_end.tscn"):
            raise SystemExit("RunEnd did not persist a finished run")


if __name__ == "__main__":
    main()
