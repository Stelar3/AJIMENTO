-- ═══════════════════════════════════════════════════════════
-- Ajimento — Schéma de base de données (Supabase / PostgreSQL)
-- Construit à partir de : SCOVL_analyse_multiprismes_BDD.md
-- ═══════════════════════════════════════════════════════════
--
-- Comment utiliser ce fichier : une fois ton projet Supabase créé,
-- va dans "SQL Editor" (menu de gauche), colle tout ce fichier,
-- et clique "Run". Ça crée toutes les tables d'un coup.

-- ---------------------------------------------------------
-- Types personnalisés (listes de valeurs autorisées)
-- ---------------------------------------------------------

create type completion_level as enum ('bronze', 'silver', 'gold');
create type data_source as enum ('editorial', 'community', 'import');
create type sauce_status as enum ('published', 'pending', 'rejected');
create type brand_type as enum ('artisanal', 'industrial', 'international');
create type pepper_family as enum ('capsicum_annuum', 'capsicum_chinense', 'capsicum_frutescens', 'capsicum_baccatum', 'capsicum_pubescens', 'autre');
create type barcode_type as enum ('EAN13', 'UPC-A', 'QR');
create type collection_status as enum ('tasted', 'wishlist', 'collection');

-- ---------------------------------------------------------
-- BRANDS — les marques de sauces
-- ---------------------------------------------------------

create table brands (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country_of_origin char(2), -- code pays ISO, ex: "MX", "FR"
  founding_year int,
  description text,
  website text,
  social_handles jsonb, -- ex: {"instagram": "@elyucateco"}
  type brand_type not null default 'artisanal',
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------
-- PEPPER_TYPES — les variétés de piments (référentiel commun)
-- ---------------------------------------------------------

create table pepper_types (
  id uuid primary key default gen_random_uuid(),
  name_fr text not null,
  name_en text not null,
  name_es text not null,
  shu_min int,
  shu_max int,
  origin_region text,
  family pepper_family not null default 'autre'
);

-- ---------------------------------------------------------
-- FLAVOR_TAGS — liste FERMÉE d'environ 20 tags aromatiques
-- (l'analyse insiste : jamais de texte libre ici, pour permettre
-- le filtrage propre dans l'app)
-- ---------------------------------------------------------

create table flavor_tags (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null, -- ex: "fume", "fruite"
  label_fr text not null,
  label_en text not null,
  label_es text not null
);

-- Les ~20 tags de départ, à ajuster si besoin
insert into flavor_tags (slug, label_fr, label_en, label_es) values
  ('fume', 'Fumé', 'Smoky', 'Ahumado'),
  ('fruite', 'Fruité', 'Fruity', 'Afrutado'),
  ('acidule', 'Acidulé', 'Tangy', 'Ácido'),
  ('terreux', 'Terreux', 'Earthy', 'Terroso'),
  ('floral', 'Floral', 'Floral', 'Floral'),
  ('sucre', 'Sucré', 'Sweet', 'Dulce'),
  ('fermente', 'Fermenté', 'Fermented', 'Fermentado'),
  ('herbace', 'Herbacé', 'Herbal', 'Herbáceo'),
  ('umami', 'Umami', 'Umami', 'Umami'),
  ('aille', 'Aillé', 'Garlicky', 'Ajoso'),
  ('citronne', 'Citronné', 'Citrusy', 'Cítrico'),
  ('vinaigre', 'Vinaigré', 'Vinegary', 'Avinagrado'),
  ('epice', 'Épicé (aromates)', 'Spiced', 'Especiado'),
  ('tropical', 'Tropical', 'Tropical', 'Tropical'),
  ('noix', 'Noisette', 'Nutty', 'A nuez'),
  ('caramel', 'Caramélisé', 'Caramelized', 'Acaramelado'),
  ('mineral', 'Minéral', 'Mineral', 'Mineral'),
  ('boise', 'Boisé', 'Woody', 'Amaderado'),
  ('poivre', 'Poivré', 'Peppery', 'Pimentado'),
  ('salin', 'Salin', 'Briny', 'Salino');

-- ---------------------------------------------------------
-- SAUCES — la table centrale
-- ---------------------------------------------------------

create table sauces (
  id uuid primary key default gen_random_uuid(),

  -- Identité
  name_full text not null,
  name_short text not null check (char_length(name_short) <= 25),
  brand_id uuid references brands(id),
  origin_country char(2),
  origin_region text,

  -- Piquant : TROIS valeurs distinctes (jamais une seule "vérité")
  shu_certified int,   -- mesure en laboratoire, la plus fiable
  shu_estimated int,   -- calculée depuis les piments déclarés
  shu_community int,   -- consensus des utilisateurs
  heat_level_display smallint check (heat_level_display between 1 and 10),
  -- ↑ C'est CETTE valeur (1 à 10) que l'app affiche toujours.
  --   Elle est calculée une fois côté base, jamais recalculée dans l'app.

  -- Ingrédients
  ingredients_raw text, -- texte libre tel que lu sur l'étiquette
  net_weight_g int,
  nutrition_per_100g jsonb,

  -- Éditorial
  story jsonb, -- ex: {"fr": "...", "en": "...", "es": "..."} — multilingue dès le départ
  editorial_angle text, -- USAGE INTERNE UNIQUEMENT, jamais affiché dans l'app

  -- Notation 4 critères (moyennes affichées) — ajouté en plus de l'analyse
  -- d'origine car déjà validé dans la spec UX (écran Fiche produit) :
  -- Heat / Flavor / Balance / Finish + une note globale.
  -- Ce sont des MOYENNES recalculées à partir de user_collection ci-dessous.
  heat_avg numeric(2,1) check (heat_avg between 0 and 5),
  flavor_avg numeric(2,1) check (flavor_avg between 0 and 5),
  balance_avg numeric(2,1) check (balance_avg between 0 and 5),
  finish_avg numeric(2,1) check (finish_avg between 0 and 5),
  score_avg numeric(2,1) check (score_avg between 0 and 5),

  -- Images
  image_bottle_url text,   -- fond neutre, ratio 2:3
  image_context_url text,  -- en situation, ratio libre

  -- Qualité et statut
  completion_level completion_level not null default 'bronze',
  source data_source not null default 'editorial',
  status sauce_status not null default 'pending',
  contributor_id uuid, -- qui a soumis (si communautaire)
  validated_by uuid,   -- qui a validé (modération)

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Recherche tolérante aux fautes de frappe (ex: "tabasco" sans majuscule,
-- ou une faute dans "Really Buokas") — l'analyse le demande explicitement.
create extension if not exists pg_trgm;
create index sauces_name_trgm_idx on sauces using gin (name_full gin_trgm_ops);

-- Pagination "cursor-based" plutôt que par page — l'analyse insiste sur
-- ce point pour la performance à grande échelle.
create index sauces_created_at_idx on sauces (created_at desc, id);

-- ---------------------------------------------------------
-- Relations plusieurs-à-plusieurs
-- ---------------------------------------------------------

create table sauce_pepper_types (
  sauce_id uuid references sauces(id) on delete cascade,
  pepper_type_id uuid references pepper_types(id) on delete cascade,
  primary key (sauce_id, pepper_type_id)
);

create table sauce_flavor_tags (
  sauce_id uuid references sauces(id) on delete cascade,
  flavor_tag_id uuid references flavor_tags(id) on delete cascade,
  primary key (sauce_id, flavor_tag_id)
);

-- ---------------------------------------------------------
-- BARCODES — une sauce peut avoir plusieurs codes-barres
-- ---------------------------------------------------------

create table barcodes (
  id uuid primary key default gen_random_uuid(),
  sauce_id uuid references sauces(id) on delete cascade,
  code text not null,
  type barcode_type not null default 'EAN13'
);
create index barcodes_code_idx on barcodes (code);

-- ---------------------------------------------------------
-- USER_COLLECTION — la "Cave" personnelle de chaque utilisateur
-- ---------------------------------------------------------

create table user_collection (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  sauce_id uuid not null references sauces(id) on delete cascade,
  status collection_status not null default 'wishlist',
  rating smallint check (rating between 1 and 5), -- note globale
  heat_rating smallint check (heat_rating between 1 and 5),
  flavor_rating smallint check (flavor_rating between 1 and 5),
  balance_rating smallint check (balance_rating between 1 and 5),
  finish_rating smallint check (finish_rating between 1 and 5),
  notes text,
  added_at timestamptz not null default now(),
  unique (user_id, sauce_id) -- un utilisateur ne peut pas dupliquer la même sauce
);

-- ---------------------------------------------------------
-- Sécurité (RLS — Row Level Security)
-- ---------------------------------------------------------
-- Supabase exige d'activer explicitement la sécurité par ligne.
-- Sans ça, par défaut, personne ne peut rien lire (ou tout le monde
-- peut tout voir, selon la config) — il faut le définir explicitement.

-- Les sauces publiées sont visibles par tout le monde
alter table sauces enable row level security;
create policy "Sauces publiées visibles par tous"
  on sauces for select
  using (status = 'published');

-- Chacun ne voit et ne modifie que SA PROPRE collection
alter table user_collection enable row level security;
create policy "Chacun voit sa propre collection"
  on user_collection for select
  using (auth.uid() = user_id);
create policy "Chacun modifie sa propre collection"
  on user_collection for insert
  with check (auth.uid() = user_id);
create policy "Chacun met à jour sa propre collection"
  on user_collection for update
  using (auth.uid() = user_id);
create policy "Chacun supprime sa propre collection"
  on user_collection for delete
  using (auth.uid() = user_id);

-- Marques, piments et tags aromatiques : lecture libre pour tous
alter table brands enable row level security;
create policy "Marques visibles par tous" on brands for select using (true);

alter table pepper_types enable row level security;
create policy "Piments visibles par tous" on pepper_types for select using (true);

alter table flavor_tags enable row level security;
create policy "Tags visibles par tous" on flavor_tags for select using (true);

-- Tables de liaison (piments et tags associés à chaque sauce) et codes-barres :
-- lecture publique aussi, pour que l'app puisse tout afficher.
alter table sauce_pepper_types enable row level security;
create policy "Liens piments visibles par tous" on sauce_pepper_types for select using (true);

alter table sauce_flavor_tags enable row level security;
create policy "Liens tags visibles par tous" on sauce_flavor_tags for select using (true);

alter table barcodes enable row level security;
create policy "Codes-barres visibles par tous" on barcodes for select using (true);
