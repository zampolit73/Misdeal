# Gameplay 2.0

## Package A · Gameplay Core

### Wounds and checkpoints

- Every hero starts a run or joins the party at full effective HP. A survivor carries their exact remaining HP to the next fight. A hero downed during a victory returns at 20% of effective maximum HP. Jack retains his existing battle rules.
- Battle and the squad dossier use the same effective stat calculation. Lowering maximum HP clamps current HP. Raising maximum HP grants capacity without healing. Blood payments that already modify maximum HP keep that effect. Wave intermissions keep the living units' current HP.
- The victory checkpoint opens Reward and keeps the battle's wounds and Wizard objective payout. A mid-battle interruption keeps the previous safe checkpoint. A defeat with Last Deal available saves that offer. Accepting saves the paid retry before reloading the fight, with the same entry HP capped by the new maximum. Refusal or a second defeat ends the run.
- Run save schema 2 adds per-hero HP and the pending stop's stock and purchase state. Schema 1 saves initialize heroes at their effective maximum and continue at the existing checkpoint. Older saves do not replay earlier stops. Stained glass remains in its existing profile.

### Stops and economy

| After | Stop | Choices |
| --- | --- | --- |
| IV and XII | Rest | Recover up to 40% max HP per hero, take the next eligible extra upgrade for one selected hero, or trade 20% of the protagonist's max HP in current HP for a compatible unowned relic. The rite requires at least 1 HP left after payment. |
| VIII | Gate merchant | Up to three compatible unowned relics for 50 gold each, one eligible extra upgrade for 45, and one party dressing for 25 that heals up to 35% max HP. Leaving is free. |

Every stop opens once outside the 12-card spread. The merchant stores one inventory and records each purchase in the same checkpoint as its cost and effect. The base catalog has three general relics, one per hero, so some parties have fewer than three available. The Broken Crown remains a Death Wager reward. Gravedigger and Candle Seller still appear through their existing event routes.

The base victory loot is 25 gold, observed on the Grave Bell smoke route. A route with two ordinary victories and no spending has 50 from battles by VIII. Mark, objectives, special rewards and events can change that amount. A relic consumes those two ordinary payouts, one dressing costs one payout, and a larger windfall allows a second purchase. These are starting prices based on payouts, with campaign income across player-selected routes still to be measured.

A production-route Windows Godot 4.7.2 automation from Class Select, seed 31031, reached the three stops with 20, 45 and 75 gold respectively and bought the dressing after VIII. The solo Knight resolved all 12 cards, fought four real battles and finished XIII with 27.88 HP. This is one automated route through the live game.

### QA and remaining balance work

- Before changes, Windows Godot 4.7.2 ran the 22-encounter Combat Planning smoke and 16 focused GUT tests. A controlled seed 31017 check used actual Battle AI, stock formations and no upgrades. At Last Bell the Knight solo won with Assault and lost with Hunt when both prioritized support. Ranger + Knight and the Knight-led trio lost both. At Iron Wall the Knight solo won in wave II, while the duo and trio lost in wave II. All three lost at Ossuary Gate and XIII. The Knight solo reached Phase II at XIII. These controlled samples warrant further matched build and positioning tests before changing the scaling or Hunt.
- The equipped follow-up used seeds 31017 and 31031, three upgrades and one role relic. Solo Knight won XIII in both samples and fought the real second phase. Trio and Ranger-led duo won the Iron Wall second wave with this equipment, while fixed formations and single-order plans still struggled at Last Bell and XIII. At Last Bell the equipped solo Knight also won with Hunt on 31031, retaining 21 HP versus 137 HP on Assault. These were encounter fixtures.
- The Package A Windows smoke uses real AI for Grave Bell and the Warden defeat and presses the production Reward, Table and Last Deal buttons. The VIII shop is an isolated fixture. Focused tests cover save migration, paid retry, recruitment, HP caps, training, the rite and repeat purchase protection. The [PR workflow](../.github/workflows/godot-pr-smoke.yml) runs the graphical route as part of RELEASE.
- F5 → choose a hero → win a fight and inspect HP in the squad dossier. After IV, choose one rest action. At VIII, buy one item and use Continue to confirm the inventory and gold. After XII, take the last rest before opening XIII. Native Windows screenshots are available for the [first rest](qa/gameplay_2_core/first_rest.png) and the [merchant with a full party](qa/gameplay_2_core/gate_merchant.png).

## Package B · Builds & Rewards

Act I has 13 unique relics. Shield, Quiver, Focus and Broken Crown retain their previous effects. Nine additional `ArtifactData` resources use the same drop, trade and save systems.

| Relic | Effect |
| --- | --- |
| Кровавый оселок | +16% strike damage at or below 45% HP. |
| Узел траура | At or below 30% HP, the first incoming strike per wave is reduced by 35%. |
| Перстень жатвы | The first personal kill per hero per wave restores up to 12 HP. |
| Цепь щитоносца | Knight in Defense reduces incoming strike damage to nearby heroes by 12%, within 150. |
| Пепельный гримуар | The Mage's first attack per wave adds 32 to its splash radius. |
| Чёрное оперение | Ranger attacks healers and archers for +17% in Hunt. |
| Колокол второй стражи | Living heroes heal up to 12% max HP at the wave intermission. |
| Меченая монета | A win with a Wizard Mark or a fulfilled Wizard objective pays 12 gold once. |
| Печать шрамов | The protagonist gets +8% damage per rescue scar, capped at +16%. The merchant offers it for 75 gold when the protagonist has a rescue scar. |

The dossiers show four build paths. Wounded heroes can combine offensive timing with a first-hit safeguard or personal kill heal. Knight Defense and the Dead Man's Shield support allied cover. Grimoire and Focus extend splash reach at the cost already shown on Focus. The coin funds purchases through earned bonus objectives and Wizard Marks. Limited triggers reset at the next wave. A squad receives each relic once, and the next battle builds its effects from its owned relics.

Reward, the gate merchant and both event choice scenes show changes from the shared effective stats. The dossier shows current/max HP, wounds, upgrades, conditional relic effects and synergies. Use the dossier scroll area to inspect owned relics beyond the three featured slots. At VIII, the merchant only offers the wave relic while Firing Square remains in the deck.

Godot 4.7.2 checks cover relic loading and save round-trip, actual attack and personal kill handling, stacking two defensive effects, enlarged first-spell radius, the merchant's special price and Combat Planning. The native fixture buys healing and plays the real Grave Bell battle through a marked victory. See [dossier](qa/gameplay_2_builds/blood_build.png), [purchase](qa/gameplay_2_builds/merchant_change.png) and [battle payout](qa/gameplay_2_builds/marked_coin.png). Long-run win-rate effects still need player runs.
