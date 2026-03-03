-- the goldmaze · rooms.lua
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

  -- ❧ HIDDEN ROOM ❧
  -- only accessible via secret: luck == 10 on floor 9
  -- see main.p8 check_gold_door()
  [999] = {
    desc = "a gold door. it was always here. you just had enough luck to see it.",
    forks = {
      { type="charm",   label="enter",   desc="the maze lets you.",   outcome_text="अमर." },
      { type="charm",   label="turn back", desc="you could. you won't.", outcome_text="the door closes. the gold stays." },
      { type="charm",   label="leave a mark", desc="for the next one.",  outcome_text="your name stays. the maze moves on." },
    }
  },

}
