# Misdeal — Core Concept

## Pitch
A dark-fantasy roguelike played across a cursed tabletop. An evil wizard deals encounters from a deck, manipulates the run, and forces the player into dangerous wagers.

Combat is not direct-action combat. It is a compact tactical autobattler: inspect the enemy, arrange a small party, choose equipment or limited interventions, then watch a fast battle resolve.

## Design pillars

### 1. The table is the adventure
Cards represent encounters, locations, enemies, merchants, curses, rewards and choices.

### 2. Preparation wins fights
The interesting combat decision happens before and around the autobattle: who is actually in the party, placement, build choices, equipment, targeting rules and scarce interventions.

The player begins each run as one chosen protagonist class: Knight, Ranger or Mage. The other two archetypes are not granted automatically; they are people from the protagonist's previous life whose fates can be encountered, changed, recruited or permanently lost during the run.

### 3. Risk is self-authored
Dangerous cards can offer stronger rewards. The player should sometimes choose to make their own future run harder.

### 4. The evil wizard is the face of the game
He is host, antagonist and commentator. He presents rules, mocks mistakes, changes the table and gives the run personality.

## Prototype combat
- Small battlefield.
- Player party can be solo, duo or trio depending on the replayed life.
- A solo hero receives +50% HP and +35% damage; a duo receives +20% HP and +15% damage. A full trio receives no compensation.
- Enemy encounters and bosses remain fixed benchmarks rather than scaling dynamically to party size.
- Units automatically acquire targets, move into range and attack.
- Clear health bars and readable targeting.
- Short fights.
- Victory and defeat states.

## First vertical slice
Intro -> choose protagonist -> cursed table -> cards can recruit/lose companions -> combat -> reward -> return to table.

The hard-roguelike party rule is part of the slice: a run may reach the final boss solo, as a duo or as a full trio.
