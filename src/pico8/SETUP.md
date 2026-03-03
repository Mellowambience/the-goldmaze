# PICO-8 + Pico-CAD Setup
## the goldmaze dev environment

---

## PICO-8

**Download:** https://www.lexaloffle.com/pico-8.php (free)

### Carts folder location

```
# macOS
~/Library/Application Support/pico-8/carts/the-goldmaze/

# Windows
%APPDATA%/pico-8/carts/the-goldmaze/

# Linux
~/.lexaloffle/pico-8/carts/the-goldmaze/
```

Copy `src/pico8/` contents into that folder.

### Add `#include` directives

In `main.p8`, find the lines:
```lua
rooms = {}
boss_rooms = {}
```
Replace them with:
```lua
#include rooms.lua
#include boss_rooms.lua
```
This inlines the room data at cart load time.

### Running it

```
load the-goldmaze/main
run
```

### PICO-8 resource limits

| Resource | Limit | Current usage |
|----------|-------|---------------|
| Code tokens | 8,192 | ~1,400 |
| Sprites | 256 | 0 (pending art) |
| `cartdata()` slots | 64 | 2 (slot 0: relic ID, slot 1: gold) |
| SFX | 64 | 0 (pending) |
| Music patterns | 64 | 0 (pending) |

### Exporting to HTML (itch.io)

```
export the-goldmaze.html
```
Outputs `the-goldmaze.html` + `the-goldmaze.js`.
Upload both to itch.io → **Embed kind: HTML**.

---

## Pico-CAD

**Download:** https://johanpeitz.itch.io/picocad (free on itch.io)

### What we're using it for

| Asset | Description |
|-------|-------------|
| Boss portraits (3×) | Low-poly boss form → PNG → PICO-8 sprite |
| Relic thumbnails (8×) | Small 3D icon per relic |
| Cover art | Dungeon entrance render for itch.io page |

### Workflow: Pico-CAD → PICO-8

1. Model in Pico-CAD (max 256 faces)
2. **File → Export PNG**
3. Resize to target sprite size (16×16 or 32×32)
4. Import into PICO-8 sprite editor via Ctrl+V or manual redraw

**Palette:** Pico-CAD uses the PICO-8 16-color palette by default. Colors transfer 1:1.

### Goldmaze color palette guide

| Color # | PICO-8 name | Use in goldmaze |
|---------|-------------|------------------|
| 0 | black | void background |
| 9 | orange | gold / luck |
| 10 | yellow | gold accents |
| 11 | light green | mischief |
| 12 | light blue | charm |
| 1 | dark blue | UI bar background |
| 8 | red | danger / low luck |
| 7 | white | primary text |
| 6 | grey | secondary text |

### Sprite layout plan

```
row 0 (sprites 0-15):   player · 4 walk frames (8×8)
row 1 (sprites 16-31):  fae enemies · 3 types · 2 frames
row 2 (sprites 32-47):  dungeon tiles (floor, wall, gold, void)
row 3 (sprites 48-63):  UI elements (stat icons, border tiles)
rows 4-7 (64-127):      boss portraits (16×16 each, 3 bosses)
rows 8-11 (128-191):    relic thumbnails (8×8 each, 8 relics)
rows 12-15 (192-255):   reserved for Pico-CAD renders
```

---

## Remix guide

1. Clone the repo
2. Edit `src/pico8/rooms.lua` — just strings, no Lua needed
3. Edit the `relics` table in `main.p8` — names + passive effects
4. Run MIST prompts from `src/mist/room-gen-template.md` for new room pools
5. Change palette: swap color constants in `draw_stat_bar()` and `draw_title()`
6. Export your cart, put it on itch.io

fork. build something cursed.
