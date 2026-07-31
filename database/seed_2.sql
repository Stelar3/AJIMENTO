-- ═══════════════════════════════════════════════════════════
-- Ajimento — Données de départ (seed), vague 2
-- 8 nouvelles sauces réelles, vérifiées par recherche web
-- (pas inventées), pour enrichir le catalogue Explorer.
-- ═══════════════════════════════════════════════════════════
--
-- À exécuter APRÈS seed.sql (celui-ci suppose que El Yucateco,
-- Habanero, etc. existent déjà), dans le même SQL Editor Supabase.
--
-- Sources : recherche web du 29/07/2026 (Cholula, Valentina, Tabasco,
-- Frank's RedHot, Marie Sharp's, Ajibasco, Blair's, El Yucateco).
-- Comme pour la vague 1 : les valeurs "estimées" ne sont pas
-- certifiées labo, et certaines sauces n'ont volontairement pas
-- de valeur SHU quand les sources publiques étaient trop floues
-- ou contradictoires (mieux vaut "pas de donnée" qu'un chiffre inventé).

-- ---------------------------------------------------------
-- Nouveaux types de piments (ceux déjà en base : Habanero,
-- Piment Scotch Bonnet — pas besoin de les réinsérer)
-- ---------------------------------------------------------

insert into pepper_types (name_fr, name_en, name_es, shu_min, shu_max, origin_region, family) values
  ('Piment de Árbol', 'Arbol Pepper', 'Chile de Árbol', 15000, 30000, 'Mexique (Jalisco)', 'capsicum_annuum'),
  ('Piment Puya', 'Puya Pepper', 'Chile Puya', 5000, 10000, 'Mexique (Jalisco)', 'capsicum_annuum'),
  ('Piment Tabasco', 'Tabasco Pepper', 'Chile Tabasco', 30000, 50000, 'Louisiane (Avery Island)', 'capsicum_frutescens'),
  ('Piment Cayenne', 'Cayenne Pepper', 'Chile Cayena', 30000, 50000, 'Amérique centrale / États-Unis', 'capsicum_annuum'),
  ('Piment Fantôme (Bhut Jolokia)', 'Ghost Pepper (Bhut Jolokia)', 'Chile Fantasma', 855000, 1041427, 'Inde (Assam)', 'capsicum_chinense');

-- ---------------------------------------------------------
-- Nouvelles marques
-- ---------------------------------------------------------

insert into brands (name, country_of_origin, founding_year, description, type) values
  ('Cholula', 'MX', null, 'Recette familiale mexicaine de Chapala (Jalisco), commercialisée sous le nom de la ville de Cholula. Introduite sur le marché américain en 1989, aujourd''hui l''une des sauces mexicaines les plus reconnues au monde.', 'international'),
  ('Valentina', 'MX', 1954, 'Produite par Salsa Tamazula à Guadalajara depuis 1954. La sauce la plus vendue au Mexique, reconnaissable à son étiquette rouge en forme d''État de Jalisco.', 'industrial'),
  ('Tabasco', 'US', 1868, 'Créée par Edmund McIlhenny sur Avery Island, en Louisiane. Le piment est vieilli jusqu''à 3 ans en fûts de chêne blanc avant d''être mélangé au vinaigre — une méthode inchangée depuis plus de 150 ans.', 'international'),
  ('Frank''s RedHot', 'US', null, 'Sauce au piment cayenne popularisée par son rôle dans l''invention des ailes de poulet "Buffalo" à Buffalo, New York. Un classique doux mais incontournable de la cuisine américaine.', 'international'),
  ('Marie Sharp''s', 'BZ', null, 'Sauces belizéennes à base de habanero rouge cultivé localement, carotte, citron vert et ail. Une référence pour la cuisine caribéenne d''Amérique centrale, peu représentée dans les catalogues existants.', 'artisanal'),
  ('Ajibasco', 'CO', null, 'Marque colombienne de salsa de ají picante à base de piment habanero, dans la tradition des ajís qui accompagnent les tables colombiennes.', 'artisanal'),
  ('Blair''s', 'US', null, 'Marque américaine spécialisée dans les sauces extrêmes ("Death Sauces"), fondée par Blair Lazar. Référence culte chez les amateurs de piquant extrême.', 'industrial');

-- ---------------------------------------------------------
-- Sauces
-- ---------------------------------------------------------

insert into sauces (
  name_full, name_short, brand_id, origin_country,
  shu_estimated, heat_level_display,
  ingredients_raw, story, completion_level, source, status,
  heat_avg, flavor_avg, balance_avg, finish_avg, score_avg
) values (
  'Cholula Original',
  'Cholula Original',
  (select id from brands where name = 'Cholula' order by created_at asc limit 1),
  'MX',
  1500, -- estimation : le fabricant annonce 1 000–2 000 SHU
  2,
  'Piment árbol, piment piquin, vinaigre, épices',
  '{"fr": "Plus reconnaissable par son bouchon en bois que par son piquant : Cholula mise sur l''équilibre plutôt que sur la brûlure. Un mélange de piments árbol et piquin, pensé pour accompagner plutôt que dominer.", "en": "More recognizable by its wooden cap than by its heat: Cholula bets on balance rather than burn. A blend of arbol and piquin peppers, meant to accompany rather than dominate.", "es": "Más reconocible por su tapón de madera que por su picor: Cholula apuesta por el equilibrio antes que por el ardor."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'Valentina Salsa Picante',
  'Valentina',
  (select id from brands where name = 'Valentina' order by created_at asc limit 1),
  'MX',
  1000, -- estimation : la version "hot" standard, entre 900 et 1 200 SHU selon les sources
  2,
  'Eau, piment puya, vinaigre, sel, épices',
  '{"fr": "La sauce la plus vendue du Mexique n''est pas la plus forte — c''est précisément ce qui explique son succès. Le piment puya de Jalisco donne à Valentina une chaleur discrète, faite pour être versée sans compter.", "en": "Mexico''s best-selling hot sauce isn''t the strongest — that''s exactly why it works. Jalisco''s puya pepper gives Valentina a quiet heat, made to be poured freely.", "es": "La salsa más vendida de México no es la más fuerte — precisamente por eso funciona."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'Tabasco Original Red Sauce',
  'Tabasco Original',
  (select id from brands where name = 'Tabasco' order by created_at asc limit 1),
  'US',
  3750, -- estimation : le fabricant annonce 2 500–5 000 SHU
  2,
  'Piment Tabasco, vinaigre, sel — vieilli 3 ans en fûts de chêne',
  '{"fr": "Trois ans en fûts de chêne blanc avant même d''être mélangée au vinaigre : Tabasco traite son piment comme d''autres traitent un whisky. Une méthode inchangée depuis 1868, sur la même île de Louisiane.", "en": "Three years in white oak barrels before it''s even mixed with vinegar: Tabasco treats its pepper mash the way others treat whiskey. A method unchanged since 1868, on the same Louisiana island.", "es": "Tres años en barriles de roble blanco antes incluso de mezclarse con vinagre."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'Frank''s RedHot Original Cayenne Pepper Sauce',
  'Frank''s RedHot',
  (select id from brands where name = 'Frank''s RedHot' order by created_at asc limit 1),
  'US',
  450, -- mesure largement documentée
  2,
  'Piment cayenne, vinaigre, eau, sel, ail',
  '{"fr": "Sans Frank''s RedHot, pas d''ailes de poulet Buffalo — l''histoire veut qu''un cuisinier de Buffalo l''ait versée sur des ailes de poulet par manque d''autre chose sous la main, en 1964. Le reste est devenu un classique américain.", "en": "No Frank''s RedHot, no Buffalo wings — the story goes that a Buffalo cook poured it over chicken wings in 1964 for lack of anything else on hand. The rest became an American classic.", "es": "Sin Frank''s RedHot, no existirían las alitas Buffalo."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'Marie Sharp''s Hot Habanero Pepper Sauce',
  'Marie Sharp''s Hot',
  (select id from brands where name = 'Marie Sharp''s' order by created_at asc limit 1),
  'BZ',
  null, -- sources publiques trop larges et contradictoires (50 000 à 250 000 SHU) pour retenir un chiffre fiable
  null,
  'Habanero rouge, carotte, oignon, jus de citron vert, vinaigre, ail, sel',
  '{"fr": "Le Belize est rarement mis en avant dans les catalogues de sauces piquantes — c''est justement ce que cette fiche corrige. Marie Sharp''s construit sa recette autour de la carotte et du citron vert, qui adoucissent et prolongent le habanero plutôt que de le masquer.", "en": "Belize rarely gets its due in hot sauce catalogs — this entry corrects that. Marie Sharp''s builds its recipe around carrot and lime, which soften and extend the habanero rather than mask it.", "es": "Belice rara vez aparece en los catálogos de salsas picantes — esta ficha corrige eso."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'Ajibasco Salsa de Ají Picante',
  'Ajibasco',
  (select id from brands where name = 'Ajibasco' order by created_at asc limit 1),
  'CO',
  null, -- pas de valeur SHU publique fiable trouvée
  null,
  'Piment habanero, vinaigre, épices',
  '{"fr": "En Colombie, l''ají picante est sur toutes les tables, dans tous les restaurants de quartier. Ajibasco en propose une version en bouteille, à base de habanero, pour prolonger cette habitude au-delà des frontières.", "en": "In Colombia, ají picante sits on every table, in every neighborhood restaurant. Ajibasco offers a bottled version, habanero-based, to carry that habit beyond the country''s borders.", "es": "En Colombia, el ají picante está en todas las mesas, en todos los restaurantes de barrio."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'Blair''s Ultra Death Sauce',
  'Blair''s Ultra Death',
  (select id from brands where name = 'Blair''s' order by created_at asc limit 1),
  'US',
  1100000, -- estimation : le fabricant/revendeurs annoncent environ 1,1 million SHU (piment fantôme pur)
  10,
  'Piment fantôme (bhut jolokia), extrait de piment, vinaigre, épices',
  '{"fr": "À la frontière entre condiment et défi : Ultra Death approche le piquant du piment fantôme à l''état pur, environ 1,1 million de SHU. Pas une sauce pour assaisonner — une sauce pour tester ses limites, quelques gouttes à la fois.", "en": "On the border between condiment and dare: Ultra Death approaches the heat of raw ghost pepper, around 1.1 million SHU. Not a sauce for seasoning — a sauce for testing limits, one drop at a time.", "es": "En la frontera entre condimento y desafío: Ultra Death se acerca al picor del chile fantasma puro."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
), (
  'El Yucateco Black Label Reserve Chile Habanero',
  'El Yucateco Black Label',
  (select id from brands where name = 'El Yucateco' order by created_at asc limit 1),
  'MX',
  5000, -- estimation : les sources varient entre 4 500 et 5 500 SHU
  2,
  'Habanero noir fumé, vinaigre, épices',
  '{"fr": "La version sombre et fumée du habanero d''El Yucateco. Moins piquante que la Habanero Rojo classique de la même marque, mais avec une profondeur que le fumage vient chercher — la preuve qu''une même maison peut raconter deux histoires très différentes.", "en": "El Yucateco''s dark, smoky take on habanero. Milder than the brand''s classic Habanero Rojo, but with a depth the smoking brings out — proof that one house can tell two very different stories.", "es": "La versión oscura y ahumada del habanero de El Yucateco."}',
  'silver', 'editorial', 'published',
  null, null, null, null, null
);

-- ---------------------------------------------------------
-- Liens piments et sauces
-- ---------------------------------------------------------

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Cholula Original' and p.name_fr = 'Piment de Árbol';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Valentina' and p.name_fr = 'Piment Puya';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Tabasco Original' and p.name_fr = 'Piment Tabasco';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Frank''s RedHot' and p.name_fr = 'Piment Cayenne';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Marie Sharp''s Hot' and p.name_fr = 'Habanero';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Ajibasco' and p.name_fr = 'Habanero';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Blair''s Ultra Death' and p.name_fr = 'Piment Fantôme (Bhut Jolokia)';

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'El Yucateco Black Label' and p.name_fr = 'Habanero';

-- ---------------------------------------------------------
-- Tags aromatiques
-- ---------------------------------------------------------

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Cholula Original' and f.slug in ('acidule', 'epice', 'terreux');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Valentina' and f.slug in ('acidule', 'vinaigre', 'epice');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Tabasco Original' and f.slug in ('vinaigre', 'acidule', 'poivre');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Frank''s RedHot' and f.slug in ('vinaigre', 'aille', 'salin');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Marie Sharp''s Hot' and f.slug in ('tropical', 'acidule', 'aille');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Ajibasco' and f.slug in ('aille', 'epice', 'acidule');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Blair''s Ultra Death' and f.slug in ('fume', 'terreux', 'poivre');

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'El Yucateco Black Label' and f.slug in ('fume', 'terreux', 'umami');
