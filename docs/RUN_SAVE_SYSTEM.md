# Run save system — schema1

## New Game means a clean collection — user correction

Main-menu «Новая игра» now starts both run and Memory Glass at0/24, after an explicit confirmation. The dialog separately offers «Новый забег — сохранить витраж»; RunEnd's existing new-run action still preserves collection. This supersedes earlier text saying main New Game always preserves glass. Continue/load never reset collection. Merely opening/canceling the dialog leaves both files untouched. No automatic migration/reset is run on launch/update.

Before clearing, the memory source is retained as a unique `memory_glass.json.before_new_game_<token>` and `.bak`; previous run remains `.previous`. Failed reset restores the run slot and does not clear the in-memory collection. Real Godot confirmation→Intro→Knight→Table→viewer verifies0/24 without resolving a card; the empty profile is also re-read from disk. First resolved card can legitimately open a new fragment. All QA uses injected paths; the player's current profile is not touched by agent testing.


Single automatic run slot: `user://current_run.json`, validated previous generation `.bak`, explicit New Game archive `.previous`. Permanent stained glass stays in `memory_glass.json`. No art replacements or gameplay changes.

## State audit

All67 authored RunState variables are explicitly listed below; GUT compares the list to Godot script properties so a future field cannot silently be omitted.66 pre-existing fields plus `pending_wager_artifact_id`, replacing the formerly scene-local random relic reroll. No Node, Texture, Callable or Resource is serialized. Typed primitive Godot variants preserve Array[String]/Array[int], dictionaries and numeric types inside a versioned JSON envelope with SHA256. Decoder disallows objects; validation completes before any state mutation.

extends RefCounted
const FIELDS := [
  "pending_wager_artifact_id",
  "gold",
  "deals_survived",
  "cards_resolved",
  "party_hp_bonus",
  "party_damage_bonus",
  "last_battle_won",
  "selected_encounter_path",
  "combat_formation_by_card",
  "whispering_well_resolved",
  "wizard_debt_active",
  "boss_defeated",
  "run_failed",
  "run_end_reason",
  "battle_target_preview_enabled",
  "last_deal_used",
  "last_deal_pending",
  "last_deal_offer_artifact_id",
  "last_deal_payment_text",
  "last_deal_hp_penalty",
  "remaining_card_ids",
  "current_offer_ids",
  "rejected_card_ids",
  "resolved_card_ids",
  "fate_choice_history",
  "active_rejected_card_id",
  "fate_spread_last_milestone_shown",
  "active_card_id",
  "artifact_ids",
  "protagonist_role",
  "party_roles",
  "hero_fates",
  "hero_fate_notes",
  "rescue_scar_roles",
  "event_outcomes",
  "castle_memory_facts",
  "castle_memory_pending_facts",
  "hero_upgrade_ids",
  "extra_hero_upgrade_ids",
  "claimed_upgrade_tiers",
  "current_major_upgrade_offer_ids",
  "current_bonus_upgrade_offer_ids",
  "forced_combat_slots",
  "wizard_meddling_slots",
  "wizard_meddling_consumed_slots",
  "wizard_meddling_pending",
  "wizard_meddling_offer_index",
  "wizard_meddling_original_id",
  "wizard_meddling_replacement_id",
  "wizard_wager_slots",
  "wizard_wager_consumed_slots",
  "wizard_wager_pending",
  "wizard_wagers_accepted",
  "wizard_wagers_declined",
  "sacrifice_order_ready",
  "defiance_order_ready",
  "defiance_refusal_count",
  "fate_hold_used",
  "held_card_id",
  "held_card_return_at",
  "wizard_mark_slots",
  "wizard_mark_consumed_slots",
  "wizard_mark_card_id",
  "wizard_mark_danger_active",
  "wizard_memory_counts",
  "wizard_memory_pending_event",
  "wizard_memory_pending_detail"
]

## Checkpoints and transactions

Confirming protagonist saves an initial Table point. Settled Table and enabled Reward states auto-save on changes; pending offers, slots, wizard flags and reward stage are retained. Table saves immediately before choosing a combat/event. Event `_finish` and final reward completion save after the whole transaction; run end records a terminal snapshot. Intermediate attacks, animation commits and moving units are never saved. An interrupted battle resumes at the pre-choice Table checkpoint. Events saved on their result resume at Table; no event resolver or reward action is replayed by loading. Awaiting rewards resume their phase; the wager relic is stable across reloads.

Pause: ESC is handled after existing modal owners; game tree pauses. Save / Save & Exit are disabled outside safe states. Load restores the validated checkpoint; Main Menu explicitly warns about unsaved changes. Main New Game confirms before replacing any slot; cancellation leaves state/bytes untouched. Corrupt originals are never overwritten implicitly. New Game explicitly archives them before starting over. Missing save disables Continue; corrupt/incompatible data shows a Russian error. Failed writes keep the last valid slot and expose the error; terminal status is not assumed persisted after failure.

Writes: temp + flush/error check + readback validation; backup only of valid previous slot; atomic rename. Header/version, primitive types, all required fields, typed arrays, protagonist/party/card/artifact/upgrade/encounter IDs and history references are validated. Unknown schema rejects wholly. No partial application.

## Permanent memory and rollback

Separate persistent memory profile now retains a random run token and monotonic processed-action/earned ledger. Run snapshot stores only this token, never the collection. Loading selects the profile's latest ledger for that run; earned counts and unlocked IDs never roll back. New run generates a new token while preserving all fragments. This closes checkpoint farming of alternative fragments at the same resolution.

## QA and local check

Local Godot4.7.2 full238-test suite passed before final additional regression cases; focused tests cover all fields, three heroes, trio/relics/upgrades/hold/wizard debt and facts, damaged files/backups/terminal status, rewind protection, stable reward phase, cancellation. Final CI counts are in the PR checks. Native `scripts/dev/run_save_capture.gd` renders original main with/without Continue and pause at1280×720; two actual Moon Seal/Echo Crypt resolutions, then Save & Exit, followed by a separate Godot process pressing Continue and verifies identical offers/resources/trio/Jack. All fixtures use injected paths; developer profiles are untouched. RELEASE includes existing Intro/ClassSelect, battle/reward/table, Jack, A1V2 and visual/animation routes. Known Windows certificate/user-log permission and route shutdown ObjectDB diagnostics remain documented rather than hidden.

F5 → New Game → confirm protagonist → play → ESC → Save & Exit → restart → Continue. Check same offers, gold/party and held card; inspect M after new run. Mid-battle closing returns to the last safe point. Win/defeat disables Continue only after terminal write succeeds. Before updating a separate checkout use `git status -sb`, then `git pull --ff-only` on clean main; preserve local Godot changes.

Delivery: [PR94](https://github.com/zampolit73/Misdeal/pull/94); [current-head RELEASE checks](https://github.com/zampolit73/Misdeal/pull/94/checks). Final checks are authoritative for merge.
