# A1P3 — Act I full-loop player playtest (Godot 4.7.x)

## What is verified automatically vs. what needs a person

GitHub A1P2 proved 36 **state-fast-forward** 12+XIII routes, including the mandatory fight windows and Fate Hold exception. A1P3 adds native GUT scene-handoff tests using **real** Table, ActChoice, Battle, Reward and RunEnd scenes. These tests **inject combat outcomes** at the original Battle result handler and fast-forward non-tested card choices. They cannot claim a successful 13-fight playthrough, actual event-button pacing, balance, animation fidelity, leg contact, GPU-frame quality, or player enjoyment.

Do not modify original card weights, encounter stats, approved DS3 art, 12+XIII structure or recruitment rules based only on scripted QA. First collect an actual F5 run.

## Local setup

1. From the project directory run `git status` and then `git pull` if the working tree permits. Do **not** blindly run `git stash pop`, `git clean -fd` or discard local Godot changes.
2. Open the project in **Godot 4.7.x** (CI uses official 4.7.2) and launch the **normal game with F5**, not only F6 smoke scenes.
3. Optional diagnostic: Godot's GUT dock → **Run All**. Its test count increases when A1P3 ships. All-green GUT is not a substitute for the F5 run.

## Main required run: Knight, normal game, 12 + XIII

Start a **new** run and choose **Knight** as protagonist. Record the selected class and whether you intentionally remain solo or later recruit companions. Do not force a party size by debugging; the available companion fates are part of the game.

| Checkpoint | What to do | Expected live behavior |
| --- | --- | --- |
| Opening | Select Knight, enter the cursed Table | Exactly two real I-tier offers, clickable card details, readable Wizard line and visible fate progress |
| Before first fight | Choose an event, use a genuine visible option (including leave where appropriate) | Outcome visibly changes gold/party/fate when promised; Continue returns to Table, next deal appears |
| Each four-card tier (I–IV, V–VIII, IX–XII) | Note chosen card, refused card and whether it was combat/event; complete all actual fights and events | One mandatory combat window per tier; each successful battle opens Reward, claiming reward returns to Table; selected card not replayed |
| First winning fight in each tier | Claim offered **major hero upgrade**, then finish battle loot where applicable | One tier upgrade selection, then the appropriate actual loot; no double claim, party stats updated |
| Wizard disruptions | When offered, read/deal with Mark, Wager and Meddling; use Fate Hold once if offered | Revealed choices remain consistent; Hold returns after two deals except if noncombat would overlap required battle, when it returns immediately afterward |
| Position XII → XIII | Complete the twelfth selected card; view Fate Spread and the next deal | Exactly the sealed **Bone Warden XIII**, not two ordinary cards or a new tier |
| Boss fight | Review prep HUD, target priorities and optional side objective, choose a tactic, press Fight | Genuine enemy movement/attacks; boss phase transition at 50% health; no placeholder units or illegible UI |
| Victory → ending | Win XIII, claim the actual reward, continue | RunEnd shows **ЗАБЕГ ЗАВЕРШЁН**, 12/12 preboss cards and the real party/loot summary; New Run starts fresh class selection |

If a card/screen cannot be advanced, record the **exact card title, the last visible button, the Godot Output/Debugger error and a screenshot**. Do not silently skip it.

## Additional targeted branches (when feasible)

- **Defeat / Last Deal:** in a separate genuine run, let a fight be lost, observe the **one-time** Last Deal. Test either refusal → actual defeat RunEnd, or acceptance → paid artifact / max HP penalty and repeat battle. On a second defeat no free restart or second Last Deal.
- **Duo / trio:** in subsequent runs start with Ranger or Mage and recruit companions only when their real events appear; capture the fate consequence, scar/stat preview, party-size-scaled battle, and final companion summary. It is fine if a randomized deal does not allow trio: record that instead of forcing it.
- **Event consistency:** if Chained Prisoner or Whispering Well appears, verify recruit vs abandon/gold outcomes actually match the UI, and that the same companion is never recruited twice.

## Minimal evidence to return

One compact report is enough: (1) chosen class and final party size; (2) whether 12 + XIII was reached, and if not, the stuck card/position; (3) approximate number of real fights, any repetitive consecutive event/combat streak; (4) whether Battle → Reward → Table, and boss → RunEnd, worked; (5) difficulty verdict (too easy / fair / too hard), plus the **three most annoying moments**. Screenshots of **one combat preparation**, **XIII battle/phase**, **RunEnd**, and any error are especially valuable.

## Acceptance gate for A1P3

Technical A1P3 is green only when the actual GitHub Godot import/GUT/smoke CI reports PASS on the PR. **Experiential A1P3 remains pending** until real F5 feedback verifies event and reward readability, combat outcomes, meaningful choices and the boss. This distinction is required even when all automated tests pass.
