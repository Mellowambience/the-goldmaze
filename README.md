# 🌿 the goldmaze

> *the gold moves. the luck doesn't stay. neither do you.*

a cursed dungeon built in public. fae roguelite. every room is different. every run ends.

**built in:** [PICO-8](https://www.lexaloffle.com/pico-8.php) (Lua, 128×128, 16-color)  
**art pipeline:** [Pico-CAD](https://johanpeitz.itch.io/picocad) → PNG sprites  
**narrative engine:** [MIST](https://github.com/Mellowambience/clawd) — pre-generated room pool, baked into cart  
**jam:** [AI Generated St. Paddy's Roguelite](https://itch.io/jam/ai-generated-st-paddys-roguelite-) · deadline April 7, 2026  
**play it:** coming soon on [itch.io](https://itch.io)  
**tip jar:** [ko-fi.com/1Aether1Rose1](https://ko-fi.com/1Aether1Rose1) ☕  
**built by:** [@Mellowambience](https://github.com/Mellowambience) · built in public, no gatekeeping

---

## what is this

you're a fae trickster inside a cursed dungeon that generates itself as you move through it.

every room is a fork. combat, puzzle, charm event — you choose.  
your stats shift with every choice: **Luck · Mischief · Charm · Gold**  
every 3 floors there's a boss.  
when luck hits zero, you die. one relic carries forward.  
the maze remembers. you don't.

---

## the ai layer (jam disclosure)

**MIST** — a LangGraph-based perceive→reason→act AI system — pre-generated every room in this dungeon offline. all room descriptions, fork options, boss flavour text, and outcome lines were authored by MIST and curated by Mars. the cart picks from the pool randomly each run. no two runs read the same.

art assets modeled in Pico-CAD, refined in the PICO-8 sprite editor.

---

## tech

| layer | tool |
|-------|------|
| game runtime | PICO-8 (Lua, 128×128) |
| 3D/low-poly art | Pico-CAD → PNG sprites |
| narrative content | MIST offline → Lua tables baked into cart |
| persistence | PICO-8 `cartdata()` — relic carry-forward |
| distribution | PICO-8 HTML export → itch.io browser embed |
| platform layer | Next.js (build-in-public site, separate) |

---

## project structure

```
the-goldmaze/
├── src/
│   ├── pico8/
│   │   ├── main.p8           # the cart (game loop, relics, ui)
│   │   ├── rooms.lua         # mist-authored room pool
│   │   ├── boss_rooms.lua    # mist-authored boss pool
│   │   └── SETUP.md          # pico-8 + pico-cad dev setup
│   └── mist/
│       └── room-gen-template.md  # mist prompts (the remix layer)
├── devlog/               # weekly build-in-public drops
├── archive/
│   └── nextjs-scaffold/  # original next.js scaffold (archived)
└── public/               # cover art, screenshots
```

---

## run it yourself

1. [Get PICO-8](https://www.lexaloffle.com/pico-8.php) (free)
2. Clone this repo into your PICO-8 carts folder
3. `load the-goldmaze/src/pico8/main` in the PICO-8 console
4. `run`

See [`src/pico8/SETUP.md`](./src/pico8/SETUP.md) for the full setup guide.

---

## remix this

this game is designed to be forked.

- edit `rooms.lua` — it's just strings, no Lua knowledge needed
- swap the relics table in `main.p8` — change names + effects
- run the MIST prompt in `src/mist/room-gen-template.md` to generate your own room pool
- change the palette: swap color constants in `main.p8` for a different vibe
- export your own cart and put it on itch.io

fork the repo. build something cursed. tag it.

---

## build in public

this repo is public from commit one.  
check [`devlog/`](./devlog) for weekly progress drops.  
watching this? leave a star. fork it. tip if the vibe hits.

---

*the maze opens. lucky you.*
