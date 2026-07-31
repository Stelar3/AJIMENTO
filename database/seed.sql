-- ═══════════════════════════════════════════════════════════
-- Ajimento — Données de départ (seed)
-- Sauces réelles, vérifiées par recherche (pas inventées),
-- pour remplacer les données de démonstration codées en dur.
-- ═══════════════════════════════════════════════════════════
--
-- À exécuter APRÈS schema.sql, dans le même SQL Editor Supabase.
--
-- Sources : recherche web du 28/07/2026. Les valeurs de piquant
-- marquées "estimées" ne sont pas certifiées en laboratoire —
-- c'est normal et volontaire (voir docs/database.md, la logique
-- des 3 types de valeur Scoville).
--
-- Ce fichier est réexécutable sans risque (ON CONFLICT DO NOTHING
-- partout) grâce aux contraintes d'unicité sur brands.name,
-- pepper_types.name_fr et sauces.name_short.

-- ---------------------------------------------------------
-- Types de piments utilisés par ces sauces
-- ---------------------------------------------------------

insert into pepper_types (name_fr, name_en, name_es, shu_min, shu_max, origin_region, family) values
  ('Habanero', 'Habanero', 'Habanero', 100000, 350000, 'Bassin amazonien / Yucatán', 'capsicum_chinense'),
  ('Piment Scotch Bonnet (Ají Chombo)', 'Scotch Bonnet (Aji Chombo)', 'Ají Chombo', 100000, 225000, 'Caraïbes / Panama', 'capsicum_chinense')
on conflict (name_fr) do nothing;

-- ---------------------------------------------------------
-- Marques
-- ---------------------------------------------------------

insert into brands (name, country_of_origin, founding_year, description, type) values
  ('El Yucateco', 'MX', 1968, 'Fondée par Priamo Gamboa au Yucatán. Une des sauces habanero les plus vendues au monde, aujourd''hui distribuée internationalement.', 'international'),
  ('Really Buokas', 'PA', null, 'Marque panaméenne de la région de Bocas del Toro, ancrée dans l''héritage afro-antillais bocatoreño.', 'artisanal'),
  ('Doraz (Ají Chombo)', 'PA', null, 'Producteur panaméen historique de sauce à l''ají chombo (scotch bonnet), pilier de la cuisine antillaise locale.', 'artisanal'),
  ('Mamita Hot Sauce', 'PA', 2016, 'Créée par Gwendolyn Stephenson à partir d''une recette familiale. Sauce caribéenne habanero et curcuma, positionnement clean label.', 'artisanal')
on conflict (name) do nothing;

-- ---------------------------------------------------------
-- Sauces
-- ---------------------------------------------------------

insert into sauces (
  name_full, name_short, brand_id, origin_country,
  shu_estimated, heat_level_display,
  ingredients_raw, story, completion_level, source, status,
  heat_avg, flavor_avg, balance_avg, finish_avg, score_avg
) values (
  'Salsa Picante de Chile Habanero Rojo',
  'Habanero Rojo',
  (select id from brands where name = 'El Yucateco' order by created_at asc limit 1),
  'MX',
  8500, -- estimation : les sources varient entre 5 790 et 11 600 SHU selon le lot
  4,
  'Habanero rouge, tomate, ail, vinaigre, épices',
  '{"fr": "L''une des sauces les plus vendues au monde. Et pourtant, la plupart de ceux qui l''utilisent tous les jours ne savent pas vraiment ce qu''ils ont dans les mains : un habanero rouge, de l''ail, de la tomate — et une recette mexicaine documentée depuis 1968.", "en": "One of the best-selling hot sauces in the world. Yet most people who use it daily don''t really know what they''re holding: red habanero, garlic, tomato — a Mexican recipe documented since 1968.", "es": "Una de las salsas picantes más vendidas del mundo. Sin embargo, la mayoría de quienes la usan a diario no saben realmente qué tienen en las manos: habanero rojo, ajo, tomate — una receta mexicana documentada desde 1968."}',
  'gold', 'editorial', 'published',
  4.3, 3.8, 4.1, 3.5, 4.2 -- reprend les valeurs déjà utilisées dans le kit de contenu Instagram
), (
  'Really Buokas Sauce Extra Forte',
  'Really Buokas',
  (select id from brands where name = 'Really Buokas' order by created_at asc limit 1),
  'PA',
  null, -- pas de valeur SHU vérifiée trouvée — à compléter via contribution communautaire
  null,
  null,
  '{"fr": "Un nom qui vient de Bocas del Toro, une identité afro-antillaise forte derrière chaque bouteille. Really Buokas fait vivre les saveurs traditionnelles bocatoreñas, entre héritage caribéen et cuisine panaméenne.", "en": "A name straight from Bocas del Toro, a strong Afro-Antillean identity behind every bottle.", "es": "Un nombre que viene de Bocas del Toro, una fuerte identidad afroantillana detrás de cada botella."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null -- pas encore de notes communautaires
), (
  'Salsa Picante de Ají Chombo',
  'Doraz Ají Chombo',
  (select id from brands where name = 'Doraz (Ají Chombo)' order by created_at asc limit 1),
  'PA',
  150000, -- estimation basée sur la plage typique du piment scotch bonnet
  7,
  'Ají chombo (scotch bonnet), moutarde, vinaigre, épices',
  '{"fr": "L''ají chombo est arrivé au Panama avec les communautés antillaises qui s''y sont installées. Ce piment scotch bonnet, cousin proche de l''habanero, est aujourd''hui indissociable de la cuisine panaméenne — dans les ragoûts, les haricots, le riz.", "en": "Aji chombo arrived in Panama with the Antillean communities who settled there. This scotch bonnet pepper, a close cousin of habanero, is now inseparable from Panamanian cuisine.", "es": "El ají chombo llegó a Panamá con las comunidades antillanas que se establecieron allí."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null -- pas encore de notes communautaires
), (
  'Mamita Salsa Picante Estilo Caribeño Habanero y Cúrcuma',
  'Mamita Habanero Cúrcuma',
  (select id from brands where name = 'Mamita Hot Sauce' order by created_at asc limit 1),
  'PA',
  null, -- non trouvé — sauce positionnée sur le goût plus que sur l'extrême piquant
  null,
  'Habanero, curcuma, vinaigre — sans colorants artificiels',
  '{"fr": "Née en 2016 d''une recette de famille sauvée par Gwendolyn Stephenson, Mamita mise sur le curcuma et l''habanero plutôt que sur la surenchère de piquant. Une sauce clean label, pensée pour parfumer plus que pour brûler.", "en": "Born in 2016 from a family recipe rescued by Gwendolyn Stephenson, Mamita bets on turmeric and habanero rather than extreme heat.", "es": "Nacida en 2016 de una receta familiar rescatada por Gwendolyn Stephenson."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null -- pas encore de notes communautaires
)
on conflict (name_short) do nothing;

-- ---------------------------------------------------------
-- Liens piments et sauces
-- ---------------------------------------------------------

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Habanero Rojo' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Doraz Ají Chombo' and p.name_fr like 'Piment Scotch Bonnet%'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Mamita Habanero Cúrcuma' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

-- ---------------------------------------------------------
-- Tags aromatiques
-- ---------------------------------------------------------

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Habanero Rojo' and f.slug in ('fruite', 'fume', 'vinaigre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Doraz Ají Chombo' and f.slug in ('aille', 'vinaigre', 'epice')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Mamita Habanero Cúrcuma' and f.slug in ('fruite', 'sucre', 'tropical')
on conflict (sauce_id, flavor_tag_id) do nothing;
