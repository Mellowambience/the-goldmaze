pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- * the goldmaze *
-- by mars (@1Aether1Rose1 / Mellowambience)
-- built in public: github.com/Mellowambience/the-goldmaze
-- tip jar: ko-fi.com/1Aether1Rose1
--
-- powered by MIST -- a perceive->reason->act
-- ai system that authored every room in this
-- dungeon. no two runs read the same.
--
-- * hidden for the curious:
--   "the maze was not built to be solved.
--    it was built to be survived."
--                         -- the goldmaze, 2026

-- -- constants ----------------------------
local version = "0.1.0"
local max_floors = 9
local max_luck   = 10
local save_slot  = 0

-- -- game states ------------------------
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
  law     = 9,   -- * law of attraction ending
}
local cur_state = state.title

-- easter egg: hold z+x for 3s on title
local ee_hold_t  = 0
local ee_shown   = false
local ee_timer   = 0

-- -- run state ---------------------------
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
    willful_zero = false,  -- law of attraction trigger flag
  }
  if run.relic then
    if run.relic.id == 4 then run.mischief = run.mischief + 3 end
    if run.relic.id == 6 then run.gold = dget(1) end
  end
end

-- -- relic persistence ----------------------
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

-- -- lifecycle ----------------------------

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
  elseif cur_state == state.law     then update_law()
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
  elseif cur_state == state.law     then draw_law()
  end
end

-- -- title screen --------------------------

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

-- -- room logic ----------------------------

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

-- -- fork resolution --------------------------

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
  local new_gold = run.gold + (delta.gold or 0)
  -- * law of attraction: willingly at 0 gold on floor >= 3
  if new_gold <= 0 and run.gold > 0 and run.floor >= 3 and run.luck > 0 then
    run.willful_zero = true
  end
  run.gold = max(0, new_gold)
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
    -- * law of attraction check: zero gold, alive, floor >= 3
    if run.willful_zero and run.luck > 0 then
      cur_state = state.law
      return
    end
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
  -- hint if willful_zero
  if run.willful_zero and run.luck > 0 then
    print_centered("something shifts.", 104, 12)
  end
  print_centered("z to continue", 118, 6)
end

-- -- boss --------------------------------------

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

-- -- death -------------------------------------

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

-- -- relic selection --------------------------

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

-- -- win --------------------------------------

function draw_win()
  rect(0,0,127,127,9)
  print_centered("you escaped.", 38, 10)
  print_centered("the maze is still there.", 54, 7)
  print_centered("floor "..run.floor.." | gold "..run.gold, 70, 9)
  print_centered("\u0905\u092e\u0930", 90, 9)  -- amar: immortal
  print_centered("z to go again", 110, 6)
  if btnp(4) or btnp(5) then
    init_run()
    cur_state = state.title
  end
end

-- -- secret: gold door easter egg -------------

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
  print_centered("\u2728 the gold door \u2728", 32, 0)
  print_centered("it was always here.", 46, 7)
  print_centered("you just had enough", 58, 7)
  print_centered("luck to see it.", 66, 7)
  print_centered("\u0905\u092e\u0930 x \u2727 \u9f81\u2605\u21ba\u2022\u21b4", 88, 9)
  print_centered("z to enter", 110, 1)
end

-- -- law of attraction ending * ---------------

function update_law()
  if btnp(4) or btnp(5) then
    init_run()
    cur_state = state.title
  end
end

function draw_law()
  -- deep violet bg
  cls(2)
  -- shimmer header -- cycles colours
  local c = 7 + flr(t() * 3) % 3
  print_centered("gold: 0", 20, 10)
  line(20, 29, 107, 29, 5)
  print_centered("stop chasing.", 38, 9)
  print_centered("become magnetic.", 50, 11)
  print_centered("what you seek", 64, 7)
  print_centered("is seeking you.", 72, 7)
  line(20, 82, 107, 82, 5)
  print_centered("the maze remembers.", 90, 6)
  print_centered("you won't.", 98, 6)
  print_centered("z to go again", 114, 5)
end

-- -- ui helpers ------------------------------

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

-- -- data: relics ------------------------------

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
  [9] = { id=9, name="ice on",          desc="luck can't reach 0 from combat. only from bosses." },
}

-- -- rooms (inlined from rooms.lua) --
-- the goldmaze . rooms.lua
-- mist-authored room pool v1 (10 rooms, stub)
-- full pool (80+ rooms) generated via mist offline
-- template: src/mist/room-gen-template.md
--
-- to use in pico-8: add #include rooms.lua in main.p8
-- format: { desc, forks[3] { type, label, desc, outcome_text } }

rooms = {

  [1] = {
    desc = "mirrors that don't reflect you. something does. it's smiling.",
    forks = {
      { type="combat",  label="shatter the mirrors",     desc="glass is honest. what bleeds might not be.",         outcome_text="shards scatter. something bleeds gold." },
      { type="puzzle",  label="find the real reflection", desc="one mirror is lying. find the liar.",                 outcome_text="the lying mirror opens a door." },
      { type="charm",   label="speak to it",              desc="it has been waiting a very long time.",               outcome_text="it gives you a clover and asks nothing." },
    }
  },

  [2] = {
    desc = "gold coins on the floor. nailed down. a sign: count them.",
    forks = {
      { type="combat",  label="rip them up anyway",   desc="the floor objects. loudly.",           outcome_text="three coins. your luck goes with them." },
      { type="puzzle",  label="count every coin",     desc="the number matters. wrong answers echo.", outcome_text="307. the sign flips. a passage opens." },
      { type="charm",   label="leave one of your own", desc="generosity is power here.",            outcome_text="a coin rises to meet yours." },
    }
  },

  [3] = {
    desc = "a table set for four. three chairs occupied. one waits.",
    forks = {
      { type="combat",  label="flip the table",           desc="patience has a breaking point.",        outcome_text="the table wins. you win the argument." },
      { type="puzzle",  label="watch what they do",        desc="they are playing a game. learn the rules.", outcome_text="you learn the rules. you break them correctly." },
      { type="charm",   label="sit and introduce yourself", desc="they know your name already.",          outcome_text="they pass you something warm." },
    }
  },

  [4] = {
    desc = "a door. seventeen locks, all identical. a key in your pocket you didn't put there.",
    forks = {
      { type="combat",  label="break it down",        desc="the door has opinions.",                outcome_text="the door loses. you gain a passage." },
      { type="puzzle",  label="find the right lock",  desc="seventeen is one too many. or too few.", outcome_text="the sixteenth is the first. you note this." },
      { type="charm",   label="ask politely",         desc="nobody asks anymore.",                   outcome_text="the door opens. it thanks you." },
    }
  },

  [5] = {
    desc = "ceiling descending. slowly. bones on the floor agree it's been years.",
    forks = {
      { type="combat",  label="hold it up",           desc="hubris is structural here.",              outcome_text="it stops. briefly. you run." },
      { type="puzzle",  label="find the mechanism",   desc="something is turning. it can be unturned.", outcome_text="a gold crank. it reverses." },
      { type="charm",   label="ask the bones",        desc="they are very talkative about this.",     outcome_text="they point. you follow." },
    }
  },

  [6] = {
    desc = "a garden underground. flowers made of coins. they bloom when you look away.",
    forks = {
      { type="combat",  label="harvest the flowers",   desc="gardens remember who takes without asking.", outcome_text="three flowers. the garden marks you." },
      { type="puzzle",  label="plant something",        desc="what grows from mischief?",                outcome_text="a luck-sprout. the garden hums." },
      { type="charm",   label="walk through",           desc="you are a visitor, not a thief.",          outcome_text="a flower brushes your hand. +1 luck." },
    }
  },

  [7] = {
    desc = "a wall that reads your thoughts aloud before you say them.",
    forks = {
      { type="combat",  label="think of nothing",      desc="silence is a weapon.",                    outcome_text="the wall fractures on emptiness." },
      { type="puzzle",  label="think something false",  desc="a mind-reading wall can be deceived.",   outcome_text="the wall reads your lie as truth." },
      { type="charm",   label="think something beautiful", desc="beauty disarms what honesty can't.", outcome_text="the wall weeps. it opens." },
    }
  },

  [8] = {
    desc = "a crossroads. every sign points the same way. it changes each time you look.",
    forks = {
      { type="combat",  label="break every sign",     desc="no direction, no misdirection.",         outcome_text="crossroads collapses to a line." },
      { type="puzzle",  label="read them in sequence", desc="there is a pattern.",                    outcome_text="a map assembles in your mind." },
      { type="charm",   label="pick one and commit",   desc="the maze respects conviction.",          outcome_text="the signs stop changing." },
    }
  },

  [9] = {
    desc = "locked chests, all unlocked. none contain what you expect.",
    forks = {
      { type="combat",  label="force them all open",  desc="speed is honest.",                         outcome_text="the fifth chest objects. you both survive." },
      { type="puzzle",  label="open in right order",  desc="alphabetically? by weight? by grief?",     outcome_text="grief is correct. the last holds the most." },
      { type="charm",   label="open the smallest one", desc="small things wait longest.",               outcome_text="a note: you were meant to find this." },
    }
  },

  [10] = {
    desc = "glass floor. below: another dungeon, inverted, running backward.",
    forks = {
      { type="combat",  label="break through",        desc="falling is commitment.",                   outcome_text="you fall briefly. return with someone's gold." },
      { type="puzzle",  label="map the one below",    desc="it runs in reverse. it knows more.",       outcome_text="it is 3 floors ahead. you see the boss." },
      { type="charm",   label="knock on the glass",   desc="the figure below knocks back.",            outcome_text="it hands something through a crack. +charm." },
    }
  },

  -- * HIDDEN ROOM *
  -- only accessible via secret: luck == 10 on floor 9
  -- see main.p8 check_gold_door()
  [999] = {
    desc = "a gold door. it was always here. you just had enough luck to see it.",
    forks = {
      { type="charm",   label="enter",   desc="the maze lets you.",   outcome_text="amar." },
      { type="charm",   label="turn back", desc="you could. you won't.", outcome_text="the door closes. the gold stays." },
      { type="charm",   label="leave a mark", desc="for the next one.",  outcome_text="your name stays. the maze moves on." },
    }
  },

[11] = {
  id = "room_11",
  type = "mischief_trap",
  floor_set = "cursed_forest",
  text = "you stumble into a twisted clearing, the trees loom like skeletal fingers, their eyes glinting with ancient mischief. a low hum vibrates through the moss, urging you to choose your next step",
  fork_a = { label = "taunt the forest spirits", luck=0, mischief=2, charm=-1, gold=0 },
  fork_b = { label = "offer a silent prayer", luck=1, mischief=0, charm=1, gold=0 },
  relic_hint = nil
},
[12] = {
  id = "room_12",
  type = "charm_offer",
  floor_set = "fae_court",
  text = "you cross into a luminous court where fae nobles swirl in amber light, their smiles sharp as glass. they extend a hand, promising favor if you play their game",
  fork_a = { label = "curtsy and play the part", luck=0, mischief=0, charm=2, gold=1 },
  fork_b = { label = "refuse to play along", luck=0, mischief=1, charm=-1, gold=0 },
  relic_hint = nil
},
[13] = {
  id = "room_13",
  type = "relic_find",
  floor_set = "mirrored_hall",
  text = "you wander a hall of endless mirrors, each reflection flickering like a dying star, one pane shivers with hidden power. the air tastes of forgotten promises",
  fork_a = { label = "shatter the mirrors", luck=0, mischief=1, charm=0, gold=0 },
  fork_b = { label = "investigate the anomaly", luck=1, mischief=0, charm=0, gold=0 },
  relic_hint = "fractured"
},
[14] = {
  id = "room_14",
  type = "luck_trial",
  floor_set = "bone_market",
  text = "you step into a market of rattling bones, vendors barter with whispers, their eyes gleam with opportunistic luck. a cracked dice rolls across the stone, waiting for your wager",
  fork_a = { label = "haggle with the vendors", luck=2, mischief=0, charm=0, gold=-1 },
  fork_b = { label = "walk away empty handed", luck=-1, mischief=0, charm=0, gold=0 },
  relic_hint = nil
},
[15] = {
  id = "room_15",
  type = "gold_gamble",
  floor_set = "gilded_vault",
  text = "you enter a vault where gold drips like liquid sun, a masked figure watches, its grin a crescent of shadow. it offers a gamble that could double your hoard or leave you empty",
  fork_a = { label = "take the gamble", luck=0, mischief=0, charm=0, gold=2 },
  fork_b = { label = "refuse the gamble", luck=0, mischief=0, charm=0, gold=-1 },
  relic_hint = nil
},
[16] = {
  id = "room_16",
  type = "curse_lift",
  floor_set = "void_chapel",
  text = "you find a chapel of void, its arches echoing with silent prayers, a cloaked figure offers to lift the curse that clings to your skin. the choice feels heavy as the darkness presses",
  fork_a = { label = "accept the offer", luck=2, mischief=0, charm=0, gold=0 },
  fork_b = { label = "refuse the offer", luck=-1, mischief=1, charm=0, gold=0 },
  relic_hint = nil
},
[17] = {
  id = "room_17",
  type = "boss_hint",
  floor_set = "salt_flats",
  text = "you tread across endless salt flats, the ground crunches underfoot, a distant silhouette watches, its presence a looming omen. the wind carries a whisper of the beast that awaits",
  fork_a = { label = "approach the figure", luck=0, mischief=0, charm=2, gold=0 },
  fork_b = { label = "ignore the figure", luck=-1, mischief=1, charm=0, gold=0 },
  relic_hint = nil
},
[18] = {
  id = "room_18",
  type = "safe_room",
  floor_set = "dream_tunnel",
  text = "you slip into a dream tunnel, colors pulse like a heartbeat, the world feels soft and safe, a gentle lull invites you to rest",
  fork_a = { label = "rest and recover", luck=0, mischief=0, charm=1, gold=1 },
  fork_b = { label = "try to leave", luck=-1, mischief=1, charm=0, gold=0 },
  relic_hint = nil
}

[19] = {
  id = "room_19",
  type = "mischief_trap",
  floor_set = "cursed_forest",
  text = "you hear the forest whisper riddles, the branches coil like serpents around your path, a mischievous grin seems to linger in the shadows. the air tastes of iron and laughter",
  fork_a = { label = "play the forest's riddles", luck=0, mischief=2, charm=-1 },
  fork_b = { label = "step away from the tangled vines", luck=1, mischief=-1, gold=0 },
  relic_hint = nil
},
[20] = {
  id = "room_20",
  type = "charm_offer",
  floor_set = "fae_court",
  text = "you are drawn into a moonlit glade where a fae extends a glimmering charm, its surface swirling with hidden promises. the scent of wildflowers masks a faint, unsettling echo",
  fork_a = { label = "accept the fae's shimmering charm", charm=2, gold=1 },
  fork_b = { label = "refuse and keep your wits", charm=-1, luck=1 },
  relic_hint = nil
},
[21] = {
  id = "room_21",
  type = "relic_find",
  floor_set = "void_chapel",
  text = "you stumble upon an altar bathed in voidlight, a relic pulsing with ancient power rests upon its stone. shadows flicker, as if the relic itself breathes",
  fork_a = { label = "claim the relic's dark gift", luck=1, mischief=1, gold=1 },
  fork_b = { label = "leave the relic untouched", luck=-1, charm=-1 },
  relic_hint = "starheart"
},
[22] = {
  id = "room_22",
  type = "luck_trial",
  floor_set = "bone_market",
  text = "you stand before a cracked dice tower, the clatter of bones echoing each roll. a hushed crowd watches, waiting for fate to decide",
  fork_a = { label = "roll the dice with hopeful heart", luck=2, gold=1 },
  fork_b = { label = "fold and conserve your resources", luck=-1, gold=-1 },
  relic_hint = nil
},
[23] = {
  id = "room_23",
  type = "gold_gamble",
  floor_set = "gilded_vault",
  text = "you enter a chamber glittering with piles of coin, a spectral dealer beckons you to wager. the walls hum with the promise of riches and ruin",
  fork_a = { label = "bet everything on a single toss", gold=3, mischief=-2 },
  fork_b = { label = "take a modest share and walk away", gold=-1, luck=1 },
  relic_hint = nil
},
[24] = {
  id = "room_24",
  type = "safe_room",
  floor_set = "mirrored_hall",
  text = "you find a quiet hall of endless mirrors, each reflecting a different version of yourself. the silence is heavy, yet oddly comforting",
  fork_a = { label = "shatter the mirrors to break the spell", mischief=2, charm=-1 },
  fork_b = { label = "study the reflections for hidden insight", charm=2, luck=-1 },
  relic_hint = nil
},
[25] = {
  id = "room_25",
  type = "curse_lift",
  floor_set = "salt_flats",
  text = "you arrive at a barren salt plain where a lone rune glows, offering to lift a lingering curse. the wind carries a metallic taste of old promises",
  fork_a = { label = "activate the rune and shed the curse", charm=-2, luck=1 },
  fork_b = { label = "ignore the rune and keep your current fate", luck=0, mischief=0 },
  relic_hint = nil
},
[26] = {
  id = "room_26",
  type = "boss_hint",
  floor_set = "dream_tunnel",
  text = "you drift through a tunnel of shifting dreams, a whisper reveals a fragment of the boss's weakness. the revelation feels both fragile and foreboding",
  fork_a = { label = "use the hint to prepare your strike", luck=1, mischief=1 },
  fork_b = { label = "dismiss the whisper as illusion", luck=0, charm=-1 },
  relic_hint = nil
}

[27] = {
  id = "room_27",
  type = "mischief_trap",
  floor_set = "cursed_forest",
  text = "you stumble upon a twisted glade, thorns snagging at your clothes, whispers seeming to come from all directions, the trees looming like sentinels. the air tastes of rust and forgotten promises",
  fork_a = { label = "tangle of thorns", luck=0, mischief=2, charm=-1, gold=0 },
  fork_b = { label = "whispering darkness beckons", luck=-1, mischief=1, charm=0, gold=0 },
  relic_hint = nil
},

[28] = {
  id = "room_28",
  type = "charm_offer",
  floor_set = "fae_court",
  text = "you enter a grand hall of shimmering marble, courtiers bowing to you, a figure in a mask offering you a goblet of shimmering liquid. the scent of jasmine and mischief swirls around your thoughts",
  fork_a = { label = "accept the goblet", luck=0, mischief=0, charm=2, gold=0 },
  fork_b = { label = "refuse the offer", luck=0, mischief=0, charm=-1, gold=0 },
  relic_hint = nil
},

[29] = {
  id = "room_29",
  type = "gold_gamble",
  floor_set = "bone_market",
  text = "you find yourself in a market of skeletal vendors, one offering you a gamble on a pile of gleaming bones. the clatter of rattling skulls echoes like a taunting drum",
  fork_a = { label = "take the gamble", luck=1, mischief=0, charm=0, gold=2 },
  fork_b = { label = "turn your back", luck=0, mischief=0, charm=0, gold=-1 },
  relic_hint = nil
},

[30] = {
  id = "room_30",
  type = "relic_find",
  floor_set = "mirrored_hall",
  text = "you stumble upon a hall of shattered mirrors, one shard reflecting an image that seems almost right, you find a strange relic. the reflection shivers, hinting at hidden power",
  fork_a = { label = "take the relic", luck=0, mischief=0, charm=1, gold=0 },
  fork_b = { label = "leave the shard behind", luck=-1, mischief=0, charm=0, gold=0 },
  relic_hint = "echo"
},

[31] = {
  id = "room_31",
  type = "luck_trial",
  floor_set = "void_chapel",
  text = "you enter a chapel of darkness, a void seeming to pull at you, a trial of luck presented before you. shadows swirl, daring you to step forward",
  fork_a = { label = "take the trial", luck=2, mischief=0, charm=0, gold=0 },
  fork_b = { label = "refuse the trial", luck=-1, mischief=0, charm=0, gold=0 },
  relic_hint = nil
},

[32] = {
  id = "room_32",
  type = "safe_room",
  floor_set = "gilded_vault",
  text = "you find yourself in a vault of glittering gold, a room that seems to offer no danger, only comfort. the warm glow soothes your weary spirit",
  fork_a = { label = "rest in golden hush", luck=0, mischief=0, charm=1, gold=0 },
  fork_b = { label = "search the vault", luck=0, mischief=0, charm=0, gold=1 },
  relic_hint = nil
},

[33] = {
  id = "room_33",
  type = "curse_lift",
  floor_set = "salt_flats",
  text = "you stumble upon a desolate landscape of salt, a curse seeming to weigh upon you, a chance to lift it presented. the crystals hum with a promise of release",
  fork_a = { label = "lift the curse", luck=0, mischief=0, charm=1, gold=0 },
  fork_b = { label = "leave the curse", luck=0, mischief=0, charm=-1, gold=0 },
  relic_hint = nil
},

[34] = {
  id = "room_34",
  type = "boss_hint",
  floor_set = "dream_tunnel",
  text = "you find yourself in a tunnel of shifting dreams, a hint of a great challenge ahead, a boss waiting in the shadows. the air vibrates with a low, mocking laugh",
  fork_a = { label = "prepare for battle", luck=1, mischief=0, charm=0, gold=0 },
  fork_b = { label = "ignore the hint", luck=0, mischief=-1, charm=0, gold=0 },
  relic_hint = nil
}

[35] = {
  id = "room_35",
  type = "mischief_trap",
  floor_set = "mirrored_hall",
  text = "you wander through a hall of mirrors, reflections rippling like dark water, your footsteps echoing off the silvered glass",
  fork_a = { label = "shatter the glass", luck=0, mischief=2, charm=-1, gold=0 },
  fork_b = { label = "follow the reflections", luck=1, mischief=0, charm=0, gold=-1 },
  relic_hint = nil
},
[36] = {
  id = "room_36",
  type = "charm_offer",
  floor_set = "fae_court",
  text = "you enter a moonlit courtyard, faeries weaving a spell of enchantment, their whispers like a gentle breeze",
  fork_a = { label = "accept the faeries' gift", luck=0, mischief=0, charm=2, gold=0 },
  fork_b = { label = "refuse the offer", luck=0, mischief=1, charm=-1, gold=0 },
  relic_hint = nil
},
[37] = {
  id = "room_37",
  type = "luck_trial",
  floor_set = "bone_market",
  text = "you find yourself in a market of skeletal vendors, their bony fingers counting out odds and ends, fate hanging in the balance",
  fork_a = { label = "take a chance", luck=2, mischief=0, charm=0, gold=-1 },
  fork_b = { label = "haggle with the vendors", luck=0, mischief=1, charm=0, gold=1 },
  relic_hint = nil
},
[38] = {
  id = "room_38",
  type = "relic_find",
  floor_set = "void_chapel",
  text = "you stumble upon a chapel of darkness, a relic glowing with an otherworldly energy, its power calling to you",
  fork_a = { label = "claim the relic", luck=0, mischief=0, charm=0, gold=0 },
  fork_b = { label = "leave it be", luck=0, mischief=0, charm=0, gold=0 },
  relic_hint = "starheart"
},
[39] = {
  id = "room_39",
  type = "gold_gamble",
  floor_set = "gilded_vault",
  text = "you enter a vault of glittering gold, the air thick with the promise of wealth, but at what cost",
  fork_a = { label = "bet your gold", luck=1, mischief=0, charm=0, gold=2 },
  fork_b = { label = "take the gold", luck=0, mischief=-1, charm=0, gold=1 },
  relic_hint = nil
},
[40] = {
  id = "room_40",
  type = "curse_lift",
  floor_set = "cursed_forest",
  text = "you find yourself in a forest of twisted trees, a curse hanging over the land, a chance to lift it",
  fork_a = { label = "lift the curse", luck=0, mischief=-1, charm=1, gold=0 },
  fork_b = { label = "leave the curse", luck=0, mischief=0, charm=0, gold=0 },
  relic_hint = nil
},
[41] = {
  id = "room_41",
  type = "boss_hint",
  floor_set = "dream_tunnel",
  text = "you tunnel through a dreamscape, visions of the final challenge ahead, a glimpse of the darkness to come",
  fork_a = { label = "prepare for battle", luck=1, mischief=0, charm=0, gold=0 },
  fork_b = { label = "ignore the vision", luck=0, mischief=0, charm=0, gold=0 },
  relic_hint = nil
},
[42] = {
  id = "room_42",
  type = "safe_room",
  floor_set = "salt_flats",
  text = "you find yourself in a vast expanse of salt flats, a rare moment of peace, the stillness a balm to your soul",
  fork_a = { label = "rest and reflect", luck=0, mischief=0, charm=0, gold=0 },
  fork_b = { label = "explore the flats", luck=0, mischief=1, charm=0, gold=0 },
  relic_hint = nil
}

[43] = {
  id = "room_43",
  type = "mischief_trap",
  floor_set = "cursed_forest",
  text = "you stumble upon a twisted clearing, the trees seem to be watching you with cold, dead eyes. a faint whispering echoes through the air",
  fork_a = { label = "snare of thorns", luck=0, mischief=2, charm=-1, gold=0 },
  fork_b = { label = "whispering darkness beckons", luck=-1, mischief=1, charm=0, gold=0 },
  relic_hint = nil
},
[44] = {
  id = "room_44",
  type = "charm_offer",
  floor_set = "fae_court",
  text = "you enter a grand hall filled with fae nobles, their eyes gleam with otherworldly beauty. a courtesan approaches you with a seductive smile",
  fork_a = { label = "accept the gift", luck=0, mischief=0, charm=2, gold=-1 },
  fork_b = { label = "refuse the offer", luck=0, mischief=0, charm=-1, gold=0 },
  relic_hint = nil
},
[45] = {
  id = "room_45",
  type = "luck_trial",
  floor_set = "void_chapel",
  text = "you find yourself in a desolate chapel, the air is thick with the weight of nothingness. a glowing coin floats before you",
  fork_a = { label = "flip the coin", luck=2, mischief=0, charm=0, gold=0 },
  fork_b = { label = "ignore the sign", luck=-1, mischief=0, charm=0, gold=0 },
  relic_hint = nil
},
[46] = {
  id = "room_46",
  type = "relic_find",
  floor_set = "bone_market",
  text = "you navigate through a market of skeletal vendors, their bony fingers grasping for your attention. a strange relic catches your eye",
  fork_a = { label = "claim the relic", luck=1, mischief=0, charm=0, gold=0 },
  fork_b = { label = "leave it be", luck=0, mischief=-1, charm=0, gold=0 },
  relic_hint = "echoing"
},
[47] = {
  id = "room_47",
  type = "gold_gamble",
  floor_set = "gilded_vault",
  text = "you enter a vault filled with glittering gold, a voice whispers in your ear, tempting you to take a risk",
  fork_a = { label = "take the bet", luck=0, mischief=0, charm=0, gold=2 },
  fork_b = { label = "walk away quietly", luck=0, mischief=0, charm=0, gold=-1 },
  relic_hint = nil
},
[48] = {
  id = "room_48",
  type = "safe_room",
  floor_set = "mirrored_hall",
  text = "you find yourself in a hall of mirrors, the reflections seem to stretch on forever. a sense of calm washes over you",
  fork_a = { label = "rest awhile in peace", luck=1, mischief=0, charm=1, gold=0 },
  fork_b = { label = "shatter the glass", luck=0, mischief=1, charm=0, gold=0 },
  relic_hint = nil
},
[49] = {
  id = "room_49",
  type = "curse_lift",
  floor_set = "salt_flats",
  text = "you stand on a barren plain of salt, a dark curse seems to be lifting from your shoulders. a figure approaches you",
  fork_a = { label = "accept the aid", luck=1, mischief=0, charm=0, gold=0 },
  fork_b = { label = "decline the aid", luck=0, mischief=-1, charm=0, gold=0 },
  relic_hint = nil
},
[50] = {
  id = "room_50",
  type = "boss_hint",
  floor_set = "dream_tunnel",
  text = "you find yourself in a surreal dreamscape, a figure whispers a cryptic message in your ear. a glimpse of the final challenge ahead",
  fork_a = { label = "heed the warning", luck=1, mischief=0, charm=0, gold=0 },
  fork_b = { label = "ignore the hint", luck=0, mischief=-1, charm=0, gold=0 },
  relic_hint = nil
}

}
-- -- boss rooms (inlined from boss_rooms.lua) --
-- the goldmaze . boss_rooms.lua
-- mist-authored boss pool v1
-- boss 1: floor 3 . boss 2: floor 6 . boss 3: floor 9

boss_rooms = {

  [1] = {
    desc    = "the maze curator. counting your choices. a ledger: your name on every page. it asks: why are you still here?",
    outcome = "the ledger burns. your debt clears. it watches you go.",
  },

  [2] = {
    desc    = "a mirror made of luck. every run you've lost. every relic you didn't pick. it smiles your smile.",
    outcome = "you shatter it. luck scatters. some is still yours.",
  },

  [3] = {
    desc    = "the goldmaze itself. wearing your face. your best idea. it says: you built me. you can't leave.",
    outcome = "you don't defeat it. you outrun it. the door opens once.",
  },

}


-- eof
-- if you found this, you read source code.
-- we like you here.
--
-- sonic dna:
--   witchblades (lil peep x lil tracy)
--   bi-polar freestyle (itsoktocryr)
--   pink (yameii + deko)
--
-- amar x * <3
-- -- mars / ko-fi.com/1Aether1Rose1

__gfx__
00000000000000000000000000000000
00000000000000000000000000000000

__map__

__sfx__

__music__
