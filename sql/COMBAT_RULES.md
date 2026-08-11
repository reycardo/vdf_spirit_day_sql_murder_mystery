# Combat Rules (Design Notes)

These are game design rules for damage interpretation, not enforced SQL logic yet.

## Core Rules

- Weapon rarity is flavor only.
- Weapon rarity does not change damage.
- Weapon effect modifiers:
  - burning: +3
  - poisoned: +2
  - electrified: +1
  - rusted: -2

## Formula

calculated_damage = damage_taken + effect_modifier

## Current Goal

Keep combat rules as narrative/system documentation while puzzle schema evolves.
When combat mechanics are finalized, we can decide where to implement them:
- query snippets shown to players
- backend/game logic layer
- SQL views or computed tables (only if desired)
