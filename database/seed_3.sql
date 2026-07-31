-- ═══════════════════════════════════════════════════════════
-- Ajimento — Données de départ (seed), vague 3
-- 8 nouvelles sauces réelles, sourcées à partir des photos de
-- bouteilles que Brice a prises lui-même (collection personnelle
-- Panama / Belize / Costa Rica / USA / Canada / Espagne), et
-- cataloguées dans docs/photos-inventaire-brut.md.
-- ═══════════════════════════════════════════════════════════
--
-- À exécuter APRÈS seed.sql et seed_2.sql, dans le même SQL Editor Supabase.
--
-- Comme pour les vagues précédentes : les ingrédients viennent de ce qui
-- est réellement lisible sur les étiquettes photographiées — jamais
-- inventés. Quand le SHU n'est ni imprimé sur l'étiquette ni documenté
-- de façon fiable ailleurs, on laisse la valeur vide plutôt que de
-- deviner. Deux sauces de cette vague (Melinda's Ghost Pepper et
-- Marie Sharp's Smokin' Marie) utilisent une vraie photo de bouteille
-- prise par Brice comme image_bottle_url (voir images/sauces/).
--
-- Ce fichier est réexécutable sans risque (ON CONFLICT DO NOTHING
-- partout) grâce aux contraintes d'unicité sur brands.name,
-- pepper_types.name_fr et sauces.name_short.

-- ---------------------------------------------------------
-- Nouveaux types de piments (Habanero, Piment Scotch Bonnet,
-- Piment Fantôme déjà en base depuis seed.sql / seed_2.sql)
-- ---------------------------------------------------------

insert into pepper_types (name_fr, name_en, name_es, shu_min, shu_max, origin_region, family) values
  ('Piment Serrano', 'Serrano Pepper', 'Chile Serrano', 10000, 25000, 'Mexique (Puebla, Hidalgo)', 'capsicum_annuum'),
  ('Piment Jalapeño', 'Jalapeño Pepper', 'Chile Jalapeño', 2500, 8000, 'Mexique (Veracruz)', 'capsicum_annuum'),
  ('Piment Carolina Reaper', 'Carolina Reaper', 'Chile Carolina Reaper', 1400000, 2200000, 'USA (Caroline du Sud)', 'capsicum_chinense')
on conflict (name_fr) do nothing;

-- ---------------------------------------------------------
-- Nouvelles marques (Marie Sharp's existe déjà depuis seed_2.sql)
-- ---------------------------------------------------------

insert into brands (name, country_of_origin, founding_year, description, type) values
  ('Melinda''s', 'US', null, 'Marque américaine de sauces piquantes fondée en Louisiane, aujourd''hui basée en Floride. Connue pour sa gamme "Ghost Pepper" à base de bhut jolokia, largement distribuée aux États-Unis et au-delà.', 'international'),
  ('Congo', 'PA', null, 'Marque panaméenne (Proluxsa) de sauces à l''ají habanero, dans un style "casero" — une recette simple, diluée à l''eau et au vinaigre, pensée pour un usage quotidien plutôt que pour l''extrême.', 'industrial'),
  ('La Pimenterie', 'CA', null, 'Sauce artisanale montréalaise qui marie le habanero chocolat à des ingrédients inattendus — dattes, bourbon Jim Beam, cacao — pour une recette plus proche de la liqueur que du condiment classique.', 'artisanal'),
  ('Branford''s Originals', 'US', null, 'Petite marque de Hialeah, en Floride, construite autour du piment serrano plutôt que du habanero omniprésent ailleurs — une sauce fraîche, à la coriandre et au citron vert, pensée pour accompagner sans écraser.', 'artisanal'),
  ('El Tortuguero', 'PA', null, 'Sauce artisanale de Bocas del Toro, sur la côte caribéenne du Panama, à base d''ají chombo — la variante panaméenne du piment Scotch Bonnet.', 'artisanal'),
  ('Hoff & Pepper', 'US', null, 'Marque de Chattanooga, dans le Tennessee, qui construit ses recettes autour d''un mélange de piments plutôt que d''une seule variété — jalapeño, habanero et chipotle réunis dans la même bouteille.', 'artisanal'),
  ('Renae', 'ES', null, 'Petite production artisanale andalouse, l''une des rares marques espagnoles du catalogue Ajimento. Travaille le jalapeño fumé et le Carolina Reaper en petites séries ("small batch").', 'artisanal')
on conflict (name) do nothing;

-- ---------------------------------------------------------
-- Sauces
-- ---------------------------------------------------------

insert into sauces (
  name_full, name_short, brand_id, origin_country,
  shu_estimated, heat_level_display,
  ingredients_raw, story, completion_level, source, status, image_bottle_url,
  heat_avg, flavor_avg, balance_avg, finish_avg, score_avg
) values (
  'Melinda''s Ghost Pepper Hot Sauce',
  'Melinda''s Ghost Pepper',
  (select id from brands where name = 'Melinda''s' order by created_at asc limit 1),
  'US',
  1000000, -- imprimé sur l'étiquette : "like 1 million Scoville units hot"
  9,
  'Purée de habanero, carottes, bhut jolokia, vinaigre, oignon, citron vert, sel, ail, acide citrique, gomme xanthane',
  '{"fr": "Le bhut jolokia, l''un des piments les plus forts au monde, cultivé dans le nord-est de l''Inde — dilué ici dans une base de habanero, carotte et citron vert qui rend la sauce utilisable, pas seulement redoutable. L''étiquette ne fait pas dans la nuance : \"1 million Scoville units hot\".", "en": "Bhut jolokia, one of the hottest peppers on earth, grown in Northeast India — cut here with a habanero, carrot and lime base that makes the sauce usable, not just fearsome. The label doesn''t bother with nuance: \"1 million Scoville units hot\".", "es": "El bhut jolokia, uno de los chiles más fuertes del mundo, cultivado en el noreste de la India."}',
  'gold', 'editorial', 'published', 'images/sauces/melindas-ghost-pepper.jpg',
  null, null, null, null, null
), (
  'Marie Sharp''s Smokin'' Marie — Special Edition',
  'Marie Sharp''s Smokin''',
  (select id from brands where name = 'Marie Sharp''s' order by created_at asc limit 1),
  'BZ',
  null, -- ingrédients illisibles sur la photo, pas de figure SHU fiable trouvée pour cette édition spéciale
  null,
  null,
  '{"fr": "Une édition spéciale de la maison de Stann Creek, qui passe cette fois son habanero rouge au fumoir avant de le mettre en bouteille. Moins documentée que la gamme classique de Marie Sharp''s, mais reconnaissable à sa silhouette et à son étiquette dorée.", "en": "A special edition from the Stann Creek house, this time smoking its red habanero before bottling it. Less documented than Marie Sharp''s classic range, but recognizable by its shape and gold label.", "es": "Una edición especial de la casa de Stann Creek, que esta vez ahúma su habanero rojo antes de embotellarlo."}',
  'silver', 'editorial', 'published', 'images/sauces/marie-sharps-smokin-marie.jpg',
  null, null, null, null, null
), (
  'Congo Picante Original',
  'Congo Picante Original',
  (select id from brands where name = 'Congo' order by created_at asc limit 1),
  'PA',
  null, -- recette diluée à l'eau, pas de figure SHU publique fiable
  null,
  'Eau, vinaigre naturel, ají habaneros, sel, gomme xanthane, sorbate de potassium, benzoate de sodium, colorant FD&C rouge #40',
  '{"fr": "Une sauce du quotidien plus qu''une sauce de collection : diluée à l''eau et au vinaigre, pensée pour accompagner chaque repas panaméen sans jamais le dominer. Le genre de bouteille qu''on retrouve sur toutes les tables, rarement dans les catalogues.", "en": "An everyday sauce more than a collector''s bottle: cut with water and vinegar, made to sit on every Panamanian table without ever taking it over. The kind of bottle you find everywhere, rarely in the catalogs.", "es": "Una salsa del día a día más que de colección: diluida con agua y vinagre."}',
  'silver', 'editorial', 'published', null,
  null, null, null, null, null
), (
  'La Pimenterie Royal Bourbon',
  'Royal Bourbon',
  (select id from brands where name = 'La Pimenterie' order by created_at asc limit 1),
  'CA',
  null, -- mélange complexe, pas de figure SHU publique fiable
  null,
  'Vinaigre de cidre, eau, carottes, dattes, oignons, habanero chocolat, bourbon Jim Beam, pasilla, épices, sel, huile de canola, cacao, gomme xanthane',
  '{"fr": "Le habanero chocolat, plus terreux que le habanero rouge classique, rencontre ici du bourbon Jim Beam, des dattes et du cacao — une sauce montréalaise pensée comme un spiritueux plus que comme un condiment.", "en": "Chocolate habanero, earthier than the classic red habanero, meets Jim Beam bourbon, dates and cacao here — a Montreal sauce built more like a spirit than a condiment.", "es": "El habanero chocolate, más terroso que el habanero rojo clásico, se encuentra aquí con bourbon Jim Beam, dátiles y cacao."}',
  'silver', 'editorial', 'published', null,
  null, null, null, null, null
), (
  'Branford''s Originals Serrano Hot Sauce',
  'Branford''s Serrano',
  (select id from brands where name = 'Branford''s Originals' order by created_at asc limit 1),
  'US',
  15000, -- estimation : plage typique du piment serrano (10 000–25 000 SHU)
  4,
  'Coriandre, oignons verts, eau, jus de citron vert, sucre, sel, serrano, tomates, gomme xanthane',
  '{"fr": "La plupart des sauces américaines misent sur le habanero ou le jalapeño ; celle-ci choisit le serrano, plus vert et plus vif, porté par la coriandre et le citron vert plutôt que noyé dans le vinaigre.", "en": "Most American hot sauces reach for habanero or jalapeño; this one picks serrano instead — greener, sharper — carried by cilantro and lime rather than drowned in vinegar.", "es": "La mayoría de las salsas picantes estadounidenses recurren al habanero o al jalapeño; esta elige el serrano."}',
  'silver', 'editorial', 'published', null,
  null, null, null, null, null
), (
  'El Tortuguero Ají Chombo',
  'El Tortuguero Ají Chombo',
  (select id from brands where name = 'El Tortuguero' order by created_at asc limit 1),
  'PA',
  null, -- pas de figure SHU publique fiable
  null,
  'Vinaigre, ají chombo, moutarde, épices',
  '{"fr": "L''ají chombo est la variante panaméenne du piment Scotch Bonnet — fruité, plutôt que simplement brûlant. Cette recette de Bocas del Toro le garde volontairement simple : vinaigre, moutarde, épices, rien de plus.", "en": "Ají chombo is Panama''s take on the Scotch Bonnet pepper — fruity rather than simply hot. This Bocas del Toro recipe keeps it deliberately simple: vinegar, mustard, spices, nothing more.", "es": "El ají chombo es la variante panameña del chile Scotch Bonnet — afrutado, más que simplemente picante."}',
  'silver', 'editorial', 'published', null,
  null, null, null, null, null
), (
  'Hoff & Pepper Hoff''s Haus Sauce',
  'Hoff''s Haus Sauce',
  (select id from brands where name = 'Hoff & Pepper' order by created_at asc limit 1),
  'US',
  null, -- mélange de trois piments, trop variable pour une estimation fiable
  null,
  'Jalapeño rouge, habanero, chipotle, vinaigre, miel de trèfle, sel, ail, moutarde noire, aneth, épices',
  '{"fr": "Trois piments dans la même bouteille — jalapeño rouge, habanero, chipotle — adoucis par le miel de trèfle et relevés par la moutarde noire et l''aneth. Une sauce de Chattanooga qui mise sur la superposition plutôt que sur un seul piment vedette.", "en": "Three peppers in one bottle — red jalapeño, habanero, chipotle — softened by clover honey and sharpened by black mustard and dill. A Chattanooga sauce built on layering rather than a single star pepper.", "es": "Tres chiles en la misma botella — jalapeño rojo, habanero, chipotle."}',
  'silver', 'editorial', 'published', null,
  null, null, null, null, null
), (
  'Renae Small Batch Hot Sauce',
  'Renae Small Batch',
  (select id from brands where name = 'Renae' order by created_at asc limit 1),
  'ES',
  null, -- seulement 8% de Carolina Reaper dans un mélange plus large, trop variable pour une estimation fiable
  null,
  'Eau, jalapeño fumé, oignon, Carolina Reaper 8%, ail, citron, vinaigre de cidre, sel',
  '{"fr": "Le Carolina Reaper ne représente que 8% de la recette — le reste est construit autour du jalapeño fumé, de l''ail et du citron. Une des rares sauces espagnoles du catalogue, produite en petites séries en Andalousie.", "en": "Carolina Reaper makes up only 8% of the recipe — the rest is built around smoked jalapeño, garlic and lemon. One of the few Spanish sauces in the catalog, produced in small batches in Andalusia.", "es": "El Carolina Reaper representa solo el 8% de la receta — el resto se construye alrededor del jalapeño ahumado, el ajo y el limón."}',
  'silver', 'editorial', 'published', null,
  null, null, null, null, null
)
on conflict (name_short) do nothing;

-- ---------------------------------------------------------
-- Liens piments et sauces
-- ---------------------------------------------------------

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Melinda''s Ghost Pepper' and p.name_fr in ('Habanero', 'Piment Fantôme (Bhut Jolokia)')
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Marie Sharp''s Smokin''' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Congo Picante Original' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Royal Bourbon' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Branford''s Serrano' and p.name_fr = 'Piment Serrano'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'El Tortuguero Ají Chombo' and p.name_fr like 'Piment Scotch Bonnet%'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Hoff''s Haus Sauce' and p.name_fr in ('Habanero', 'Piment Jalapeño')
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Renae Small Batch' and p.name_fr in ('Piment Jalapeño', 'Piment Carolina Reaper')
on conflict (sauce_id, pepper_type_id) do nothing;

-- ---------------------------------------------------------
-- Tags aromatiques
-- ---------------------------------------------------------

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Melinda''s Ghost Pepper' and f.slug in ('acidule', 'citronne', 'aille')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Marie Sharp''s Smokin''' and f.slug in ('fume', 'epice', 'poivre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Congo Picante Original' and f.slug in ('vinaigre', 'acidule', 'epice')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Royal Bourbon' and f.slug in ('sucre', 'caramel', 'fruite')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Branford''s Serrano' and f.slug in ('herbace', 'citronne', 'acidule')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'El Tortuguero Ají Chombo' and f.slug in ('vinaigre', 'epice', 'acidule')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Hoff''s Haus Sauce' and f.slug in ('sucre', 'aille', 'epice')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Renae Small Batch' and f.slug in ('fume', 'acidule', 'aille')
on conflict (sauce_id, flavor_tag_id) do nothing;
