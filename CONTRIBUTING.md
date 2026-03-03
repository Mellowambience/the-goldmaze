# contributing to the goldmaze

this is a build-in-public project. forks are encouraged.

## remix rules

- fork it freely — that's the point
- if you build something from this, open a PR or drop a link in Issues
- credit the original if you publish (a link back is enough)
- tip jar stays: [ko-fi.com/1Aether1Rose1](https://ko-fi.com/1Aether1Rose1)

## what's remixable

- `src/pico8/rooms.lua` — all room data, just strings. no Lua knowledge needed
- `src/pico8/boss_rooms.lua` — 3 boss encounters
- `src/mist/room-gen-template.md` — MIST prompts, completely open
- the relics table in `main.p8` — swap names + passive effects
- the PICO-8 color palette — change the vibe entirely with 3 constant swaps

## what's not remixable

- the MIST engine itself (sovereign, private)
- the AetherRose brand assets

## how to run

```bash
git clone https://github.com/Mellowambience/the-goldmaze.git
# copy src/pico8/ into your PICO-8 carts folder
# in PICO-8 console:
load the-goldmaze/main
run
```

See [`src/pico8/SETUP.md`](./src/pico8/SETUP.md) for full setup guide.

---

*the maze was made to be remixed. go.*
