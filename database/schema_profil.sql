-- ═══════════════════════════════════════════════════════════
-- Ajimento — Schéma complémentaire : préférences du Profil
-- ═══════════════════════════════════════════════════════════
-- À exécuter APRÈS schema.sql (et après les seeds si tu veux, l'ordre
-- ne compte pas ici), dans le même SQL Editor Supabase.
--
-- La table user_collection existait déjà dans schema.sql (Cave +
-- notation). Il manquait un endroit où stocker le "profil de goût"
-- affiché sur l'écran Profil : tolérance au piquant, saveurs
-- préférées, nom affiché. C'est l'objet de cette table.

create table user_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  heat_tolerance smallint check (heat_tolerance between 1 and 10),
  favorite_flavor_tags text[] not null default '{}', -- slugs de flavor_tags, ex: {"fume","fruite"}
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table user_preferences enable row level security;

create policy "Chacun voit ses propres préférences"
  on user_preferences for select
  using (auth.uid() = user_id);

create policy "Chacun crée ses propres préférences"
  on user_preferences for insert
  with check (auth.uid() = user_id);

create policy "Chacun met à jour ses propres préférences"
  on user_preferences for update
  using (auth.uid() = user_id);
