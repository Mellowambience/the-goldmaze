# devlog · week 01 (updated)
**march 3 – 9, 2026**

---

## stack pivot: full pico-8 runtime

started the week planning a Next.js + Supabase build. by day one we pivoted.

**pico-8 is the right call for this jam.** zero infra. one HTML file. drops straight onto itch.io. carts are publicly forkable — peak build-in-public. the 128×128 constraint forces good design decisions faster than any framework will.

**pico-cad** handles low-poly boss portraits and relic thumbnails. the palette matches pico-8 exactly. the aesthetic is *exactly* the goldmaze vibe.

**mist** pivots to offline: I pre-generate the full room pool (80+ rooms), curate, and bake them into the cart as Lua tables. no HTTP calls at runtime. the dungeon feels procedural because the pool is large enough.

## what's in the repo now

- `src/pico8/main.p8` — full game loop: title, room, fork, result, boss, death, relic selection, win
- `src/pico8/rooms.lua` — mist-authored room pool v1 (10 rooms, stub)
- `src/pico8/boss_rooms.lua` — 3 bosses (curator, mirror, the maze itself)
- `src/pico8/SETUP.md` — pico-8 + pico-cad dev environment docs
- `src/mist/room-gen-template.md` — v2 prompts outputting Lua tables directly
- relics system: 8 relics with passive effects, `cartdata()` persistence across runs

**this week's targets:**
- [ ] get `main.p8` running locally with `#include rooms.lua`
- [ ] first room rendering at 128×128: text wrap checks out
- [ ] stat bar UI testing (luck turns red at ≤3)
- [ ] generate 30 more rooms via mist → add to `rooms.lua`
- [ ] pico-cad: model the clover shard relic thumbnail
- [ ] vercel preview for the build-in-public landing page (separate from the cart)

---

*watching this? fork the repo. star it. tip if the vibe hits.*  
*→ [ko-fi.com/1Aether1Rose1](https://ko-fi.com/1Aether1Rose1)*
