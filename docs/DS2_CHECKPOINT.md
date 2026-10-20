# DS2 Pre-DS3 Restoration Point

Saved on **2026-10-20**, before D288 migration.

- **Frozen branch:** [checkpoint/ds2-pre-ds3-2026-10-20](https://github.com/zampolit73/Misdeal/tree/checkpoint/ds2-pre-ds3-2026-10-20)
- **Commit:** [4cbd206cc3739355a9d375a0752a6a840e35caa2](https://github.com/zampolit73/Misdeal/commit/4cbd206cc3739355a9d375a0752a6a840e35caa2)
- **Tree:** `955d34147260d725264a104a6f8b3a1fe60fd725`
- **Confirmed:** GitHub checkpoint ref resolved to exactly the original `main` HEAD commit at the instant of branching.
- **Contains:** every tracked code, Godot scene, DS2 design kit, D287 dossier ornament, arenas, gameplay definitions and project documentation. **No** local ignored/untracked files, Godot user cache or current run state.
- **Unmodified checkpoint branch:** do not merge new DS3 commits into it.
- **Restore plan:** Use non-destructive DS3 commit reverts on `main`; preview the checkpoint in a separate temporary local branch if needed. Never unilaterally force-reset shared `main`.
- **DS3 plan:** `docs/DS3_FOUNDATION.md`. Initial D288 runtime commit `5de3237ebf0d23e2e7d6d9a2b0a2fc3886301a07`.

To inspect from a clean Git tree:

```powershell
git fetch origin
git switch -c inspect-before-ds3 origin/checkpoint/ds2-pre-ds3-2026-10-20
# Review in Godot
git switch main
git pull --ff-only
```

**Important:** Commit or stash local changes before switching. The checkpoint is a full version-control rollback target, *not* a backed-up local savegame.
