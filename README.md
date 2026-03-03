# 🌿 the goldmaze

> *the gold moves. the luck doesn't stay. neither do you.*

a cursed dungeon built in public. fae roguelite. every room is different. every run ends.

**built for:** [AI Generated St. Paddy's Roguelite Jam](https://itch.io/jam/ai-generated-st-paddys-roguelite-) · deadline April 7, 2026  
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

**MIST** — a LangGraph-based perceive→reason→act AI system — is the dungeon's narrative engine.

every room description, NPC voice, and event outcome is generated per-run via MIST hosted on Railway.  
no two runs read the same.  
art assets are AI-assisted.  
this game could not exist without AI. that's the point.

---

## tech

| layer | tool |
|-------|------|
| frontend | Next.js (App Router) |
| animations | Framer Motion |
| state/db | Supabase |
| deployment | Vercel → itch.io iframe |
| ai engine | MIST on Railway |

---

## build in public

this repo is public from commit one.  
check [`/devlog`](./devlog) for weekly progress drops.  
fork it. remix it. build something cursed.

if you make something from this — tag it. i want to see it.

---

## remix this

this game is designed to be forked.  
clone it, change the dungeon theme, swap the stats, reroute the lore.  
MIST prompt templates are in `/src/mist/` — start there.

```bash
git clone https://github.com/Mellowambience/the-goldmaze.git
cd the-goldmaze
npm install
npm run dev
```

---

## project structure

```
the-goldmaze/
├── src/
│   ├── app/          # Next.js app router
│   ├── components/   # UI: room cards, stat bars, relic display
│   ├── lib/          # Supabase client, run state logic
│   └── mist/         # MIST prompt templates (the remix layer)
├── devlog/           # weekly build-in-public drops
├── public/           # static assets
└── supabase/         # schema migrations
```

---

*the maze opens. lucky you.*
