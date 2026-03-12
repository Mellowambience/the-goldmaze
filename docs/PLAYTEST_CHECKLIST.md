# The Goldmaze — Playtest Checklist
## Use for first full playtest session (PICO-8 cart)

---

## Pre-flight
- [ ] Load cart in PICO-8
- [ ] Title screen renders + hidden sequence triggers (~8 sec wait)
- [ ] Gold door easter egg visible on title

---

## Core loop (floors 1-9)

### Floor 1
- [ ] Enter first room — text renders, exits visible
- [ ] Navigate 3+ rooms, no crashes
- [ ] Trap/enemy: stat deduction fires
- [ ] Fork: branching choice presented
- [ ] Floor boss trigger: boss loads

### Boss 1
- [ ] Boss intro text fires
- [ ] Win path AND lose path both tested
- [ ] Win → relic select (3 offered)
- [ ] Select relic → passive applied
- [ ] `cartdata()` saves relic

### Floors 2-3 (relic stacking)
- [ ] Relic 1 passive visible by floor 2
- [ ] Two relics on floor 3 — stat math correct

### Floor 6 boss
- [ ] Boss 2 loads
- [ ] Death → death screen (not crash)
- [ ] Death screen shows run stats + restart

### Floor 9 boss
- [ ] Boss 3 loads
- [ ] Win → `अमर` win screen fires
- [ ] Sonic DNA easter egg plays

---

## Edge cases
- [ ] Die on floor 1 room 1 (no relic) — graceful
- [ ] Die with 3 relics — all shown on death screen
- [ ] All 8 relics: each passive matches description
- [ ] Same fork, different run — different rooms load
- [ ] Close + reopen cart — save state persists

---

## Watch for
- Text overflow (128px wide)
- Boss fight hang (infinite loop)
- Relic passive double-dip
- All 3 floor types appear across floors 1-9

## After playtest
- List dead rooms (replacement candidates)
- List Lua errors / crashes
- **Target:** full 9-floor run without crash = HTML export ready
