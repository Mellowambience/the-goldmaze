-- the-goldmaze · supabase schema
-- runs, relics, stats

-- a single run instance
create table runs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  ended_at timestamptz,
  floor_reached int default 1,
  cause_of_death text, -- what ended the run
  relic_carried_forward uuid references relics(id)
);

-- relics that persist across runs
create table relics (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  effect_key text, -- maps to frontend relic logic
  acquired_at timestamptz default now(),
  acquired_in_run uuid references runs(id)
);

-- stat snapshot per floor per run
create table stats (
  id uuid primary key default gen_random_uuid(),
  run_id uuid references runs(id) on delete cascade,
  floor int not null,
  luck int default 10,
  mischief int default 5,
  charm int default 5,
  gold int default 0,
  fork_chosen text, -- 'combat' | 'puzzle' | 'charm'
  recorded_at timestamptz default now()
);

-- indexes
create index on stats(run_id);
create index on relics(acquired_in_run);
