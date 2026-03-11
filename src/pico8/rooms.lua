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

}