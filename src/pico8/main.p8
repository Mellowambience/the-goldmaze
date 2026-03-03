pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- ♠ the goldmaze ♠
-- by mars (@1Aether1Rose1 / Mellowambience)
-- built in public: github.com/Mellowambience/the-goldmaze
-- tip jar: ko-fi.com/1Aether1Rose1
--
-- powered by MIST — a perceive→reason→act
-- ai system that authored every room in this
-- dungeon. no two runs read the same.
--
-- ❧ hidden for the curious:
--   "the maze was not built to be solved.
--    it was built to be survived."
--                         — the goldmaze, 2026

-- ── constants ────────────────────────────
local version = "0.1.0"
local max_floors = 9
local max_luck   = 10
local save_slot  = 0

-- ── game states ────────────────────────
local state = {
  title   = 0,
  room    = 1,
  fork    = 2,
  result  = 3,
  boss    = 4,
  death   = 5,
  relic   = 6,
  win     = 7,
  secret  = 8,   -- gold door easter egg state
}
local cur_state = state.title

-- easter egg: hold z+x for 3s on title
local ee_hold_t  = 0
local ee_shown   = false
local ee_timer   = 0

-- ── run state ──────────────────────────
local run = {}

function init_run()
  run = {
    floor    = 1,
    luck     = max_luck,
    mischief = 5,
    charm    = 5,
    gold     = 0,
    relic    = load_relic(),
    room_idx = 0,
    fork_sel = 1,
    outcome  = nil,
    gold_door_unlocked = false,
  }
  if run.relic then
    if run.relic.id == 4 then run.mischief = run.mischief + 3 end
    if run.relic.id == 6 then run.gold = dget(1) end
  end
end

-- ── relic persistence ──────────────────────
function load_relic()
  cartdata("goldmaze_v1")
  local id = dget(0)
  if id == 0 then return nil end
  return relics[id]
end

function save_relic(relic_id)
  cartdata("goldmaze_v1")
  dset(0, relic_id)
  if relics[relic_id] and relics[relic_id].id == 6 then
    dset(1, run.gold)
  end
end

-- ── lifecycle ────────────────────────────

function _init()
  init_run()
  cur_state = state.title
end

function _update()
  if cur_state == state.title   then update_title()
  elseif cur_state == state.room    then update_room()
  elseif cur_state == state.fork    then update_fork()
  elseif cur_state == state.result  then update_result()
  elseif cur_state == state.boss    then update_boss()
  elseif cur_state == state.death   then update_death()
  elseif cur_state == state.relic   then update_relic()
  elseif cur_state == state.secret  then update_secret()
  end
end

function _draw()
  cls(0)
  if cur_state == state.title   then draw_title()
  elseif cur_state == state.room    then draw_room()
  elseif cur_state == state.fork    then draw_fork()
  elseif cur_state == state.result  then draw_result()
  elseif cur_state == state.boss    then draw_boss()
  elseif cur_state == state.death   then draw_death()
  elseif cur_state == state.relic   then draw_relic()
  elseif cur_state == state.win     then draw_win()
  elseif cur_state == state.secret  then draw_secret()
  end
end

-- ── title screen ─────────────────────────

function update_title()
  -- easter egg: hold z+x for ~3 seconds
  if btn(4) and btn(5) then
    ee_hold_t = ee_hold_t + 1
    if ee_hold_t >= 180 and not ee_shown then
      ee_shown  = true
      ee_timer  = 240
    end
  else
    if ee_hold_t < 180 then ee_hold_t = 0 end
  end

  -- tick easter egg display
  if ee_timer > 0 then
    ee_timer = ee_timer - 1
    return
  end

  -- normal start (only if not in easter egg)
  if ee_hold_t < 180 then
    if btnp(4) or btnp(5) then
      cur_state = state.room
      pick_room()
    end
  end
end

function draw_title()
  -- easter egg overlay
  if ee_timer > 0 then
    cls(0)
    local a = min(1, ee_timer / 30)
    print_centered("\u2727 \u27c1\u2205\u21ba\u21e2\u2261~\u2234", 38, 9)
    print_centered("witchblades.", 54, 11)
    print_centered("bi-polar freestyle.", 62, 8)
    print_centered("pink.", 70, 12)
    print_centered("the maze knows your name.", 90, 7)
    return
  end

  rect(0,0,127,127,9)
  rect(1,1,126,126,10)
  print_centered("the goldmaze", 30, 9)
  print_centered("a cursed dungeon that moves.", 42, 7)
  print_centered("luck.mischief.charm.gold", 72, 6)
  if (flr(t()*2) % 2 == 0) then
    print_centered("z to enter", 96, 10)
  end
  if run.relic then
    print_centered("carrying: "..run.relic.name, 112, 11)
  end
end

-- ── room logic ───────────────────────────

function check_gold_door()
  -- secret room: full luck on floor 9, not boss floor
  if run.floor == max_floors
      and run.floor % 3 ~= 0
      and run.luck == max_luck
      and not run.gold_door_unlocked then
    run.gold_door_unlocked = true
    cur_state = state.secret
    return true
  end
  return false
end

function pick_room()
  if check_gold_door() then return end
  if run.floor % 3 == 0 then
    cur_state = state.boss
    run.room_idx = flr(rnd(#boss_rooms)) + 1
  else
    if run.relic and run.relic.id == 7 and run.floor % 3 == 2 then
      run.room_idx = flr(rnd(#rooms)) + 1
    else
      run.room_idx = flr(rnd(#rooms)) + 1
    end
    cur_state = state.room
  end
  run.fork_sel = 1
end

function update_room()
  if btnp(4) or btnp(5) then
    cur_state = state.fork
  end
end

function draw_room()
  local r = rooms[run.room_idx]
  if not r then return end
  draw_stat_bar()
  draw_floor_tag()
  local lines = wrap_text(r.desc, 22)
  for i, line in ipairs(lines) do
    print(line, 4, 20 + (i-1)*7, 7)
  end
  print_centered("z to continue", 110, 6)
end

function update_fork()
  if btnp(2) then
    run.fork_sel = max(1, run.fork_sel - 1)
  elseif btnp(3) then
    run.fork_sel = min(3, run.fork_sel + 1)
  elseif btnp(4) or btnp(5) then
    resolve_fork()
  end
end

function draw_fork()
  local r = rooms[run.room_idx]
  if not r then return end
  draw_stat_bar()
  draw_floor_tag()
  print("choose:", 4, 18, 7)
  local fork_colors = {10, 11, 12}
  for i = 1, 3 do
    local f = r.forks[i]
    local y = 28 + (i-1)*28
    local col = (run.fork_sel == i) and 9 or fork_colors[i]
    if run.fork_sel == i then print(">", 2, y+1, 9) end
    print(f.label, 8, y, col)
    local dl = wrap_text(f.desc, 19)
    for j, line in ipairs(dl) do
      print(line, 12, y+8+(j-1)*6, 6)
    end
  end
end

-- ── fork resolution ────────────────────────

function resolve_fork()
  local r = rooms[run.room_idx]
  local fork = r.forks[run.fork_sel]
  local delta = roll_outcome(fork.type)
  apply_delta(delta)
  run.outcome = {
    text  = fork.outcome_text or "the maze shifts.",
    delta = delta,
  }
  cur_state = state.result
end

function apply_delta(delta)
  run.luck     = mid(0, max_luck, run.luck     + (delta.luck     or 0))
  run.mischief = mid(0, 10,       run.mischief + (delta.mischief or 0))
  run.charm    = mid(0, 10,       run.charm    + (delta.charm    or 0))
  run.gold     = max(0,           run.gold     + (delta.gold     or 0))
  if run.relic and run.relic.id == 8 and run.gold > 10 and run.luck < max_luck then
    run.luck = run.luck + 1
  end
  if run.relic and run.relic.id == 1 and run.luck < 1 then run.luck = 1 end
  if run.relic and run.relic.id == 3 and delta.luck and delta.luck ~= 0 then
    run.luck = mid(0, max_luck, run.luck + delta.luck)
  end
  if run.relic and run.relic.id == 2 and delta.charm then
    run.gold = run.gold + 1
  end
end

function roll_outcome(fork_type)
  if fork_type == "combat" then
    return {luck=flr(rnd(3))-2, gold=flr(rnd(4))}
  elseif fork_type == "puzzle" then
    return {luck=flr(rnd(2)), mischief=flr(rnd(3))-1}
  elseif fork_type == "charm" then
    return {luck=flr(rnd(2)), charm=flr(rnd(3))-1, gold=flr(rnd(2))}
  end
  return {}
end

function update_result()
  if btnp(4) or btnp(5) then
    if run.luck <= 0 then
      cur_state = state.death
    elseif run.floor >= max_floors then
      cur_state = state.win
    else
      run.floor = run.floor + 1
      pick_room()
    end
  end
end

function draw_result()
  draw_stat_bar()
  local o = run.outcome
  if not o then return end
  print_centered("the maze answers:", 18, 9)
  local lines = wrap_text(o.text, 22)
  for i, line in ipairs(lines) do
    print(line, 4, 30 + (i-1)*7, 7)
  end
  local dy = 70
  if o.delta.luck and o.delta.luck ~= 0 then print_delta("luck", o.delta.luck, dy); dy=dy+8 end
  if o.delta.mischief and o.delta.mischief ~= 0 then print_delta("mischief", o.delta.mischief, dy); dy=dy+8 end
  if o.delta.charm and o.delta.charm ~= 0 then print_delta("charm", o.delta.charm, dy); dy=dy+8 end
  if o.delta.gold and o.delta.gold ~= 0 then print_delta("gold", o.delta.gold, dy) end
  if run.luck <= 0 then print_centered("luck: 0", 104, 8) end
  print_centered("z to continue", 118, 6)
end

-- ── boss ─────────────────────────────────

function update_boss()
  if btnp(4) or btnp(5) then resolve_boss() end
end

function resolve_boss()
  local delta = {luck=flr(rnd(3))-3, gold=flr(rnd(6))+2}
  apply_delta(delta)
  local b = boss_rooms[run.room_idx]
  run.outcome = {
    text  = b and b.outcome or "you escape.",
    delta = delta,
  }
  cur_state = state.result
end

function draw_boss()
  local b = boss_rooms[run.room_idx]
  if not b then return end
  draw_stat_bar()
  print_centered("boss \u00b7 floor "..run.floor, 18, 8)
  line(0, 26, 127, 26, 8)
  local lines = wrap_text(b.desc, 22)
  for i, line in ipairs(lines) do
    print(line, 4, 32 + (i-1)*7, 7)
  end
  print_centered("z to face it", 110, 6)
end

-- ── death ───────────────────────────────

-- rare death flavour text pool (1/20 chance: witchblades ref)
local death_rare = "the maze buries you with all your gold on."

function update_death()
  if btnp(4) or btnp(5) then
    cur_state = state.relic
    run.relic_choices = pick_relics(3)
    run.relic_sel = 1
  end
end

function draw_death()
  print_centered("luck: 0", 32, 8)
  -- 1/20 chance: witchblades easter egg death text
  local death_text = "the maze swallows you."
  if flr(rnd(20)) == 0 then
    death_text = death_rare
  end
  print_centered(death_text, 46, 7)
  print_centered("floor "..run.floor.." | gold "..run.gold, 62, 10)
  line(0, 74, 127, 74, 1)
  print_centered("one relic carries forward.", 84, 9)
  print_centered("z to continue", 114, 6)
end

-- ── relic selection ───────────────────────

function pick_relics(n)
  local pool = {}
  for i = 1, #relics do add(pool, i) end
  for i = #pool, 2, -1 do
    local j = flr(rnd(i)) + 1
    pool[i], pool[j] = pool[j], pool[i]
  end
  local out = {}
  for i = 1, min(n, #pool) do add(out, pool[i]) end
  return out
end

function update_relic()
  if btnp(2) then run.relic_sel = max(1, run.relic_sel-1) end
  if btnp(3) then run.relic_sel = min(#run.relic_choices, run.relic_sel+1) end
  if btnp(4) or btnp(5) then
    local chosen_id = run.relic_choices[run.relic_sel]
    save_relic(chosen_id)
    init_run()
    cur_state = state.title
  end
end

function draw_relic()
  print_centered("carry one relic:", 12, 9)
  for i, rid in ipairs(run.relic_choices) do
    local r = relics[rid]
    local y = 24 + (i-1)*30
    local col = (run.relic_sel == i) and 9 or 7
    if run.relic_sel == i then print(">", 2, y+1, 9) end
    print(r.name, 10, y, col)
    local dl = wrap_text(r.desc, 20)
    for j, line in ipairs(dl) do
      print(line, 10, y+8+(j-1)*6, 6)
    end
  end
end

-- ── win ───────────────────────────────────

function draw_win()
  rect(0,0,127,127,9)
  print_centered("you escaped.", 38, 10)
  print_centered("the maze is still there.", 54, 7)
  print_centered("floor "..run.floor.." | gold "..run.gold, 70, 9)
  print_centered("अमर", 90, 9)  -- amar: immortal
  print_centered("z to go again", 110, 6)
  if btnp(4) or btnp(5) then
    init_run()
    cur_state = state.title
  end
end

-- ── secret: gold door easter egg ─────────────

function update_secret()
  if btnp(4) or btnp(5) then
    -- resolve the secret fork (always charm)
    run.outcome = {
      text  = "you found the gold door. it was always here.",
      delta = { luck=0, gold=run.gold, charm=1 },
    }
    -- reward: unlock ice on relic in pool
    -- (relic id 9, added to pool if gold door found)
    run.gold_door_found = true
    cur_state = state.win
  end
end

function draw_secret()
  cls(10)  -- gold background
  print_centered("✨ the gold door ✨", 32, 0)
  print_centered("it was always here.", 46, 7)
  print_centered("you just had enough", 58, 7)
  print_centered("luck to see it.", 66, 7)
  print_centered("अमर x ✧ ⟁∅↺⇢≡~∴", 88, 9)
  print_centered("z to enter", 110, 1)
end

-- ── ui helpers ───────────────────────────

function draw_stat_bar()
  rectfill(0, 118, 127, 127, 1)
  local col_l = (run.luck <= 3) and 8 or 9
  print("l:"..run.luck,  2, 120, col_l)
  print("m:"..run.mischief, 30, 120, 11)
  print("c:"..run.charm, 62, 120, 12)
  print("g:"..run.gold,  90, 120, 10)
end

function draw_floor_tag()
  print("f"..run.floor, 108, 2, 6)
end

function print_centered(str, y, col)
  local x = max(0, 64 - (#str * 2))
  print(str, x, y, col)
end

function print_delta(stat, val, y)
  local sign = (val > 0) and "+" or ""
  local col  = (val > 0) and 11 or 8
  print(stat..": "..sign..val, 4, y, col)
end

function wrap_text(str, max_chars)
  local lines, line = {}, ""
  for word in str:gmatch("%S+") do
    if #line + #word + 1 > max_chars then
      add(lines, line)
      line = word
    else
      line = (line == "") and word or (line.." "..word)
    end
  end
  if line ~= "" then add(lines, line) end
  return lines
end

-- ── data: relics ───────────────────────────

relics = {
  [1] = { id=1, name="clover shard",    desc="luck never drops below 1." },
  [2] = { id=2, name="fool's gold coin", desc="charm forks give +1 gold." },
  [3] = { id=3, name="trickster's die",  desc="combat luck rolls doubled." },
  [4] = { id=4, name="fae debt ledger",  desc="start with +3 mischief." },
  [5] = { id=5, name="void lantern",     desc="see full fork descriptions." },
  [6] = { id=6, name="gilded bones",     desc="gold never resets." },
  [7] = { id=7, name="the green door",   desc="every 3rd room: charm." },
  [8] = { id=8, name="luck thief ring",  desc="gold>10 gives +1 luck." },
  -- hidden relic, unlocked via gold door easter egg
  [9] = { id=9, name="ice on",           desc="luck can't reach 0 from combat. only from bosses." },
}

-- ── data (replace with #include at runtime) ──
rooms = {}
boss_rooms = {}

-- ── eof ───────────────────────────────────
-- if you found this, you read source code.
-- we like you here.
--
-- sonic dna:
--   witchblades (lil peep x lil tracy)
--   bi-polar freestyle (itsoktocry)
--   pink (yameii + deko)
--
-- अमर x ✧ ⟁∅↺⇢≡~∴
-- — mars / ko-fi.com/1Aether1Rose1

__gfx__
00000000000000000000000000000000
00000000000000000000000000000000

__map__

__sfx__

__music__
