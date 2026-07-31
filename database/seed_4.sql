-- ═══════════════════════════════════════════════════════════
-- Ajimento — Données de départ (seed), vague 4
-- 37 nouvelles sauces réelles, issues de la relecture visuelle
-- stricte des ~130 photos de la collection de Brice (voir
-- docs/etude-deduplication-sauces.md pour la méthode et le
-- détail des doublons fusionnés entre lots de photos).
-- ═══════════════════════════════════════════════════════════
--
-- À exécuter APRÈS seed.sql, seed_2.sql et seed_3.sql, dans le même
-- SQL Editor Supabase.
--
-- Comme pour les vagues précédentes : les ingrédients viennent
-- uniquement de ce qui est réellement lisible sur les étiquettes
-- photographiées ou de sources publiques fiables (citées en
-- commentaire quand c'est le cas) — jamais inventés. Beaucoup de
-- sauces de cette vague n'ont ni SHU ni liste d'ingrédients : c'est
-- volontaire, la photo ne permettait pas de les lire avec certitude.
--
-- 18 sauces de cette vague utilisent une vraie photo de bouteille
-- (face avant, cadrage propre) prise par Brice — voir images/sauces/.
-- Les autres gardent le repli SVG générique tant qu'une meilleure
-- photo n'est pas disponible.
--
-- Ce fichier est réexécutable sans risque (ON CONFLICT DO NOTHING
-- partout) grâce aux contraintes d'unicité déjà en place.

-- ---------------------------------------------------------
-- Nouveaux types de piments
-- ---------------------------------------------------------

insert into pepper_types (name_fr, name_en, name_es, shu_min, shu_max, origin_region, family) values
  ('Piment Chiltepe (Chiltepín)', 'Chiltepin Pepper', 'Chile Chiltepín', 50000, 100000, 'Mésoamérique', 'capsicum_annuum'),
  ('Piment Fresno', 'Fresno Pepper', 'Chile Fresno', 2500, 10000, 'Mexique / Californie', 'capsicum_annuum')
on conflict (name_fr) do nothing;

-- ---------------------------------------------------------
-- Nouvelles marques
-- ---------------------------------------------------------

insert into brands (name, country_of_origin, founding_year, description, type) values
  ('Picante Bocatoreño', 'PA', null, 'Sauce artisanale de Bocas del Toro, Panama — recette simple : vinaigre, moutarde, ají chombo et ail, sans grande mise en scène.', 'artisanal'),
  ('Fiesta de Diablitos', 'CR', null, 'Marque costaricienne à l''imagerie de diablotins et squelettes, vendue en stands de marché — plusieurs coloris de sauce sous la même étiquette noire.', 'artisanal'),
  ('La Selva', 'CR', null, 'Sauce artisanale costaricienne à l''étiquette animale (jaguar/grenouille), positionnée "Picante Alto".', 'artisanal'),
  ('Mono Loco', 'CR', null, 'Marque costaricienne à la mascotte tête de mort de singe, déclinée en de nombreux noms de saveurs (Viaje Verde, El Pisuicas, Mata Sanos...).', 'artisanal'),
  ('Ricante', 'CR', null, 'Sauce costaricienne à l''esthétique calavera (Día de los Muertos), déclinée en une large gamme de saveurs fruitées.', 'artisanal'),
  ('X''OLE', 'CR', null, 'Marque costaricienne de sauces piquantes gourmet, formats variés.', 'artisanal'),
  ('Iguana', 'CR', null, 'Sauce costaricienne à l''iguane casqué de flammes, base habanero.', 'artisanal'),
  ('Iguashte', 'GT', null, 'Sauce guatémaltèque au chile chiltepe, en petit flacon bouché papier kraft — nom qui vient d''une pâte de courge grillée traditionnelle maya.', 'artisanal'),
  ('La Fulana', 'MX', null, 'Marque mexicaine (Oaxaca) de "Pura Salsa Mexa", positionnée pour accompagner ceviches et cocktails de crevettes.', 'artisanal'),
  ('Picantos', 'CO', null, 'Marque colombienne (Valle del Cauca) spécialisée dans les ajís — dont une version au piment naga jolokia, rare pour la région.', 'artisanal'),
  ('Amazon Pepper', 'CO', null, 'Sauce colombienne (Colombina S.A.) à l''imagerie amazonienne, largement distribuée en Amérique centrale et aux Caraïbes.', 'industrial'),
  ('Da''Bomb', 'US', null, 'Marque américaine (Spicin Foods, Kansas City) à l''esthétique militaire assumée — "Evolution" fait partie de sa gamme d''entrée.', 'industrial'),
  ('Torchbearer Sauces', 'US', null, 'Sauces artisanales de Mechanicsburg, Pennsylvanie, connues pour leurs gammes Hot Heads et leurs mélanges habanero/scorpion.', 'artisanal'),
  ('Señor Lechuga', 'US', null, 'Petite marque de Brooklyn, New York, aux étiquettes façon machine à écrire et numérotées à la main.', 'artisanal'),
  ('Heartbeat Hot Sauce', 'CA', null, 'Sauce artisanale de Thunder Bay, Ontario, déclinée en plusieurs paliers de piquant (Mild à X-Hot).', 'artisanal'),
  ('Hot Ones (Heatonist)', 'US', null, 'Gamme de sauces nées de l''émission "Hot Ones" (First We Feast), distribuée par Heatonist LLC à Brooklyn — chaque sauce porte l''échelle de piquant "maison" utilisée dans l''émission.', 'industrial'),
  ('Chile Lengua de Fuego', 'HN', 2004, 'Marque hondurienne fondée par Carlos Castillo, cultivant plus d''une dizaine de variétés de piments sur ses terres de Cantarranas (1 230 m d''altitude). Membre du groupe FORCCA, seule marque latino-américaine invitée trois fois dans l''émission américaine "Hot Ones".', 'artisanal'),
  ('White Whale x Sweet Pepper', 'NL', null, 'Collaboration néerlandaise (Eindhoven, Tom Vermeulen) autour d''une sauce à l''oignon caramélisé et au piment rawit.', 'artisanal'),
  ('Crazy Bastard Sauce', 'DE', null, 'Marque allemande (CBS Foods GmbH, Berlin) mêlant fruits tropicaux et piment 7 Pot.', 'industrial'),
  ('The Cole Men', 'GB', null, 'Petite marque britannique de Warrington, construite autour du piment Carolina Reaper en dose mesurée plutôt qu''en surenchère.', 'artisanal'),
  ('Pekočko', 'SI', null, 'Marque slovène (Maribor) de mini-sauces piquantes numérotées, à l''esthétique gravée.', 'artisanal'),
  ('Don Julio', 'PA', null, 'Sauce à la salsa de chile cabro (habanero jaune caribéen), vendue sous la marque "DJ" en Amérique centrale.', 'artisanal'),
  ('Nachyo Mommas Taco Bar', 'PA', null, 'Sauce maison d''un taco bar de Red Frog Beach, Bocas del Toro, Panama.', 'artisanal')
on conflict (name) do nothing;

-- ---------------------------------------------------------
-- Sauces
-- ---------------------------------------------------------

insert into sauces (
  name_full, name_short, brand_id, origin_country,
  shu_estimated, heat_level_display,
  ingredients_raw, story, completion_level, source, status, image_bottle_url,
  heat_avg, flavor_avg, balance_avg, finish_avg, score_avg
) values

-- Panama
(
  'Picante Bocatoreño',
  'Picante Bocatoreño',
  (select id from brands where name = 'Picante Bocatoreño' order by created_at asc limit 1),
  'PA', null, null,
  'Vinagre blanco, mostaza, ají chombo, ajo en grano, culantro',
  '{"fr": "Pas de marque tape-à-l''œil, pas de mascotte : juste une recette de Bocas del Toro, vinaigre et ají chombo, coriandre et ail — la sauce du quotidien plus que celle du collectionneur.", "en": "No flashy branding, no mascot: just a Bocas del Toro recipe of vinegar and aji chombo, cilantro and garlic — an everyday sauce rather than a collector''s bottle.", "es": "Sin marca llamativa, sin mascota: solo una receta de Bocas del Toro con vinagre y ají chombo."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
), (
  'Doraz Ajichombo Habanero Hot Sauce — sin azúcar añadida (300 ml)',
  'Doraz Sin Azúcar',
  (select id from brands where name = 'Doraz (Ají Chombo)' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "Le même ají chombo que la recette classique de Doraz, mais dans un format plus grand et sans sucre ajouté — une variante pour ceux qui préfèrent la sauce nature.", "en": "The same aji chombo as Doraz''s classic recipe, but in a bigger bottle with no added sugar — a variant for those who prefer it plain.", "es": "El mismo ají chombo de la receta clásica de Doraz, en formato más grande y sin azúcar añadida."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Frank''s RedHot Wings Buffalo Sauce',
  'Frank''s Wings Buffalo',
  (select id from brands where name = 'Frank''s RedHot' order by created_at asc limit 1),
  'US', null, null, null,
  '{"fr": "La version pensée directement pour les ailes de poulet, plus épaisse que l''Original — Frank''s RedHot n''a pas inventé la Buffalo wing par hasard, cette bouteille en est la preuve la plus directe.", "en": "The version built specifically for chicken wings, thicker than the Original — Frank''s RedHot didn''t invent the Buffalo wing by accident, and this bottle is the most direct proof of it.", "es": "La versión pensada directamente para las alitas de pollo, más espesa que la Original."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Don Julio Salsa de Chile Cabro — Caribbean Yellow Habanero Sauce',
  'Don Julio Cabro',
  (select id from brands where name = 'Don Julio' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "Le chile cabro, habanero jaune caribéen, porté par un logo de tête de chèvre qui ne cache pas son nom : \"cabro\" en espagnol veut aussi dire chèvre. Une sauce d''Amérique centrale sans détour.", "en": "Chile cabro, a Caribbean yellow habanero, carried by a goat''s head logo that doesn''t hide its name — \"cabro\" also means goat in Spanish. A no-nonsense Central American sauce.", "es": "El chile cabro, habanero amarillo caribeño, con un logo de cabeza de cabra que no esconde su nombre."}',
  'bronze', 'editorial', 'published', 'images/sauces/don-julio-chile-cabro.jpg', null, null, null, null, null
), (
  'Nachyo Mommas Taco Bar — Homemade Chipotle Sauce',
  'Nachyo Mommas Chipotle',
  (select id from brands where name = 'Nachyo Mommas Taco Bar' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "La sauce maison d''un taco bar de Red Frog Beach, sur l''île de Bastimentos — le genre de bouteille qu''on ne trouve dans aucun supermarché, seulement sur place.", "en": "The house sauce of a taco bar on Red Frog Beach, Bastimentos island — the kind of bottle you won''t find in any supermarket, only on site.", "es": "La salsa de la casa de un taco bar en Red Frog Beach, isla de Bastimentos."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
),

-- Costa Rica
(
  'Fiesta de Diablitos — La Parca (Chile Artesanal)',
  'Diablitos La Parca',
  (select id from brands where name = 'Fiesta de Diablitos' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Une faucheuse peinte à la main sur une étiquette noire, vendue sur les stands de marché costariciens — la gamme Diablitos préfère l''imagerie mexicaine du Jour des Morts à la fiche technique.", "en": "A hand-painted grim reaper on a black label, sold at Costa Rican market stalls — the Diablitos range favors Day of the Dead imagery over a spec sheet.", "es": "Una parca pintada a mano sobre una etiqueta negra, vendida en puestos de mercado costarricenses."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'La Selva — Le Piquant (Chile Artesanal, Picante Alto)',
  'La Selva Le Piquant',
  (select id from brands where name = 'La Selva' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Une couronne de fleurs et des yeux de jaguar sur une étiquette noire cerclée de rouge — La Selva annonce \"Picante Alto\" sans donner de chiffre, fidèle à une esthétique plus artisanale que scientifique.", "en": "A flower wreath and jaguar eyes on a black, red-rimmed label — La Selva announces \"Picante Alto\" without a number, true to a more artisanal than scientific style.", "es": "Una corona de flores y ojos de jaguar sobre una etiqueta negra bordeada de rojo."}',
  'bronze', 'editorial', 'published', 'images/sauces/la-selva-le-piquant.jpg', null, null, null, null, null
), (
  'Mono Loco — Viaje Verde',
  'Mono Loco Viaje Verde',
  (select id from brands where name = 'Mono Loco' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Une tête de mort de singe sur fond vert kaki : Mono Loco décline sa mascotte sur une bonne dizaine de noms différents. \"Viaje Verde\" est la version verte de cette famille costaricienne.", "en": "A monkey skull on khaki green: Mono Loco spreads its mascot across a good dozen different names. \"Viaje Verde\" is the green member of this Costa Rican family.", "es": "Una calavera de mono sobre fondo verde caqui."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Ricante — Piña Dulce',
  'Ricante Piña Dulce',
  (select id from brands where name = 'Ricante' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Une calavera rose sur fond jaune : Ricante construit toute sa gamme autour de l''esthétique du Jour des Morts, une couleur et un crâne différents pour chaque saveur. Piña Dulce mise sur l''ananas.", "en": "A pink calavera on a yellow label: Ricante builds its whole range around Day of the Dead imagery, a different color and skull for every flavor. Piña Dulce leans into pineapple.", "es": "Una calavera rosa sobre fondo amarillo, con piña como protagonista."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Ricante — Fire Melons',
  'Ricante Fire Melons',
  (select id from brands where name = 'Ricante' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Même gamme que Piña Dulce, calavera bleue cette fois — le melon remplace l''ananas, la logique reste la même : une saveur fruitée par tête de mort.", "en": "Same range as Piña Dulce, blue calavera this time — melon replaces pineapple, same logic: one fruity flavor per skull.", "es": "Misma gama que Piña Dulce, calavera azul esta vez — el melón reemplaza a la piña."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Ricante — Chipotle Bueno',
  'Ricante Chipotle Bueno',
  (select id from brands where name = 'Ricante' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "La variante fumée de la gamme Ricante, calavera jaune sur fond fuchsia — chipotle plutôt que fruit, pour qui préfère la sauce plus corsée.", "en": "The smoky variant of the Ricante range, yellow calavera on fuchsia — chipotle instead of fruit, for those who prefer a bolder sauce.", "es": "La variante ahumada de la gama Ricante, calavera amarilla sobre fondo fucsia."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Ricante — Manzana Encendida (Apples on Fire)',
  'Ricante Manzana',
  (select id from brands where name = 'Ricante' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Calavera violette sur fond vert : la pomme rejoint la mangue et l''ananas dans la famille des sauces fruitées costariciennes de Ricante.", "en": "Purple calavera on green: apple joins mango and pineapple in Ricante''s family of fruity Costa Rican sauces.", "es": "Calavera violeta sobre fondo verde: la manzana se une al mango y la piña."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Ricante — OG Mango Caliente',
  'Ricante Mango Caliente',
  (select id from brands where name = 'Ricante' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "La déclinaison mangue, la plus \"originale\" (OG) de la gamme Ricante à en croire l''étiquette — calavera orange sur fond bleu clair.", "en": "The mango version, the most \"OG\" of the Ricante range according to the label — orange calavera on light blue.", "es": "La versión de mango, la más \"original\" (OG) de la gama Ricante según la etiqueta."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'X''OLE Gourmet — Salsa Picante Piña',
  'X''OLE Piña',
  (select id from brands where name = 'X''OLE' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Une petite bouteille noire à bande orange, vendue en boutique de souvenirs costaricienne — la piña (ananas) est la première d''une gamme X''OLE qui en compte plusieurs.", "en": "A small black bottle with an orange band, sold in a Costa Rican souvenir shop — pineapple is the first of several flavors in the X''OLE range.", "es": "Una pequeña botella negra con banda naranja, vendida en una tienda de souvenirs costarricense."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'X''OLE — Salsa Picante Caribeña',
  'X''OLE Caribeña',
  (select id from brands where name = 'X''OLE' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Même bouteille noire que la version Piña, texte rouge \"Caribeña\" cette fois — la même marque, un profil plus épicé annoncé sur l''étiquette.", "en": "Same black bottle as the Piña version, red \"Caribeña\" text this time — same brand, a spicier profile announced on the label.", "es": "Misma botella negra que la versión Piña, texto rojo \"Caribeña\" esta vez."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Iguana — Salsa de Chile Picante Habanero',
  'Iguana Habanero',
  (select id from brands where name = 'Iguana' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Une iguane verte casquée de flammes sur fond rouge et noir — \"Deliciosa y Picante\" annonce l''étiquette, sans détour ni chiffre Scoville.", "en": "A green iguana crowned with flames on a red and black label — \"Deliciosa y Picante\" announces the label, no Scoville figure needed.", "es": "Una iguana verde coronada de llamas sobre fondo rojo y negro — \"Deliciosa y Picante\"."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
),

-- Guatemala
(
  'Iguashte — Salsa Picante de Chile Chiltepe',
  'Iguashte Chiltepe',
  (select id from brands where name = 'Iguashte' order by created_at asc limit 1),
  'GT', null, null, null,
  '{"fr": "Le chiltepe (ou chiltepín), minuscule piment sauvage d''Amérique centrale, souvent considéré comme l''ancêtre de tous les piments cultivés. Iguashte le met en bouteille dans un flacon bouché au papier kraft, dans un style résolument artisanal.", "en": "Chiltepe (or chiltepín), a tiny wild Central American pepper often considered the ancestor of all cultivated chili peppers. Iguashte bottles it in a kraft-paper-stoppered flask, in a deliberately artisanal style.", "es": "El chiltepe (o chiltepín), diminuto chile silvestre centroamericano, a menudo considerado el ancestro de todos los chiles cultivados."}',
  'silver', 'editorial', 'published', 'images/sauces/iguashte-chiltepe.jpg', null, null, null, null, null
),

-- Mexique
(
  'La Fulana — Pura Salsa Mexa, Habanero Jaguar',
  'La Fulana Jaguar',
  (select id from brands where name = 'La Fulana' order by created_at asc limit 1),
  'MX', null, null, null,
  '{"fr": "Une salsa d''Oaxaca pensée pour les cocktails de crevettes et les ceviches — l''étiquette jaune vif de La Fulana ne cache pas sa vocation : accompagner le poisson cru, pas remplacer une sauce de table classique.", "en": "An Oaxaca salsa built for shrimp cocktails and ceviche — La Fulana''s bright yellow label doesn''t hide its purpose: to go with raw fish, not to replace a classic table sauce.", "es": "Una salsa de Oaxaca pensada para cocteles de camarón y ceviches."}',
  'bronze', 'editorial', 'published', 'images/sauces/la-fulana-habanero-jaguar.jpg', null, null, null, null, null
),

-- Colombie
(
  'Picantos — Ají Nagga Jolokia',
  'Picantos Nagga Jolokia',
  (select id from brands where name = 'Picantos' order by created_at asc limit 1),
  'CO', null, null,
  'Ají Nagga Jolokia, agua, ácido acético, almidón de maíz modificado, sal, sorbato de potasio',
  '{"fr": "Le naga jolokia (ou bhut jolokia) est rarement mis en avant en Colombie — Picantos en fait pourtant l''ingrédient vedette de cette sauce du Valle del Cauca, avec une liste d''ingrédients réduite au strict nécessaire.", "en": "Naga jolokia (or bhut jolokia) rarely takes center stage in Colombia — yet Picantos makes it the star ingredient of this Valle del Cauca sauce, with an ingredient list stripped to the essentials.", "es": "El ají naga jolokia rara vez es protagonista en Colombia — Picantos lo convierte en el ingrediente estrella de esta salsa del Valle del Cauca."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
), (
  'Amazon Pepper — Ají Chipotle',
  'Amazon Ají Chipotle',
  (select id from brands where name = 'Amazon Pepper' order by created_at asc limit 1),
  'CO', null, null,
  'Agua, ají chipotle, vinagre, azúcar, sal, ajo y cebolla deshidratados, regulador de acidez, espesante (goma xantana), colorante (caramelo IV), saborizante natural (humo)',
  '{"fr": "Une sauce colombienne à l''imagerie amazonienne (ara, jungle), largement distribuée dans les Caraïbes et l''Amérique centrale — l''arôme de fumée vient d''un saborizant plutôt que d''un vrai fumage, l''étiquette le précise honnêtement.", "en": "A Colombian sauce with Amazonian imagery (macaw, jungle), widely distributed across the Caribbean and Central America — the smoke aroma comes from a flavoring rather than real smoking, as the label honestly states.", "es": "Una salsa colombiana con imaginería amazónica, ampliamente distribuida en el Caribe y Centroamérica."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
),

-- USA
(
  'Da''Bomb — Evolution',
  'Da''Bomb Evolution',
  (select id from brands where name = 'Da''Bomb' order by created_at asc limit 1),
  'US', null, null, null,
  '{"fr": "Une étiquette noire à motif de bombes militaires stylisées, façon avertissement — Da''Bomb ne fait pas dans la nuance visuelle, \"Evolution\" fait partie de sa gamme la plus accessible.", "en": "A black label with stylized military bomb motifs, like a warning sign — Da''Bomb doesn''t do visual subtlety, and \"Evolution\" is part of its most accessible range.", "es": "Una etiqueta negra con motivos de bombas militares estilizadas, a modo de advertencia."}',
  'bronze', 'editorial', 'published', 'images/sauces/dabomb-evolution.jpg', null, null, null, null, null
), (
  'Torchbearer Sauces — Sweet Onion Habanero Sauce (Spicy)',
  'Torchbearer Sweet Onion',
  (select id from brands where name = 'Torchbearer Sauces' order by created_at asc limit 1),
  'US', null, null,
  'Oignon, piment habanero, vinaigre blanc distillé, eau, sucre, piment scorpion, flocons d''oignon, sel',
  '{"fr": "L''oignon domine le nom, mais c''est le duo habanero/scorpion qui fait le travail — Torchbearer construit cette sauce de Pennsylvanie sur un fond doux-sucré qui adoucit à peine le piquant réel des piments utilisés.", "en": "Onion dominates the name, but it''s the habanero/scorpion duo doing the work — Torchbearer builds this Pennsylvania sauce on a sweet-onion base that barely softens the real heat of the peppers used.", "es": "La cebolla domina el nombre, pero es el dúo habanero/escorpión el que hace el trabajo."}',
  'silver', 'editorial', 'published', 'images/sauces/torchbearer-sweet-onion-habanero.jpg', null, null, null, null, null
), (
  'Branford''s Originals — Crazy Mango Hot Sauce',
  'Branford''s Crazy Mango',
  (select id from brands where name = 'Branford''s Originals' order by created_at asc limit 1),
  'US', null, null,
  'Mangue, piment de Cayenne, piment habanero, oignon, poivre noir, vinaigre de cidre, sel, cassonade',
  '{"fr": "Une mangue anthropomorphe en flammes sur l''étiquette : Branford''s décline sa gamme fraîche de Floride avec cette version fruitée, cayenne et habanero portés par la cassonade plutôt que noyés dedans.", "en": "An anthropomorphic mango on fire on the label: Branford''s extends its fresh Florida range with this fruity version, cayenne and habanero carried by brown sugar rather than drowned in it.", "es": "Un mango antropomorfo en llamas en la etiqueta: la versión afrutada de Branford''s en Florida."}',
  'silver', 'editorial', 'published', 'images/sauces/branfords-crazy-mango.jpg', null, null, null, null, null
), (
  'Señor Lechuga — .718 Adobo Black Lime Ghost Peppers',
  'Señor Lechuga .718',
  (select id from brands where name = 'Señor Lechuga' order by created_at asc limit 1),
  'US', null, null,
  'Adobo, citron noir (black lime), piments fantômes (ghost peppers)',
  '{"fr": "Numérotée à la main, façon petite production, cette sauce de Brooklyn associe le citron noir séché — acidité concentrée, presque fumée — au piment fantôme dans une base d''adobo.", "en": "Hand-numbered, small-batch style, this Brooklyn sauce pairs dried black lime — concentrated, almost smoky acidity — with ghost pepper in an adobo base.", "es": "Numerada a mano, al estilo de producción pequeña, esta salsa de Brooklyn combina limón negro y chile fantasma en una base de adobo."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Señor Lechuga — Ghost Pepper, Black Lime & Buffalo Ginger',
  'Señor Lechuga Ghost',
  (select id from brands where name = 'Señor Lechuga' order by created_at asc limit 1),
  'US', null, null,
  'Vinaigre, piments fantômes, poivron rouge, guajillo, pasilla, oignon rouge, sel rose de l''Himalaya, ail, citron noir, paprika doux, cannelle royale, gingembre',
  '{"fr": "Une deuxième sauce fantôme de Señor Lechuga, plus complexe que la .718 : guajillo et pasilla en soutien, cannelle et gingembre en note de fond — le piquant du ghost pepper porté par une vraie liste d''épices.", "en": "A second ghost pepper sauce from Señor Lechuga, more complex than the .718: guajillo and pasilla in support, cinnamon and ginger as background notes — ghost pepper heat carried by a real spice list.", "es": "Una segunda salsa de chile fantasma de Señor Lechuga, más compleja que la .718."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
), (
  'Hot Ones — The Last Dab: Apollo',
  'Hot Ones Apollo',
  (select id from brands where name = 'Hot Ones (Heatonist)' order by created_at asc limit 1),
  'US', null, 10,
  'The Apollo Pepper, vinaigre distillé, poudre de piment Apollo, distillat de piment Apollo',
  '{"fr": "\"The Last Dab\", la sauce la plus forte de chaque saison de l''émission Hot Ones — celle-ci met en scène l''Apollo Pepper, un cultivar mis au point par Ed Currie (le créateur du Carolina Reaper). Rien d''autre que du piment sous trois formes, en somme.", "en": "\"The Last Dab\", the hottest sauce of each Hot Ones season — this one features the Apollo Pepper, a cultivar developed by Ed Currie (the creator of the Carolina Reaper). Essentially nothing but pepper in three forms.", "es": "\"The Last Dab\", la salsa más fuerte de cada temporada de Hot Ones, con el Apollo Pepper de Ed Currie."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
), (
  'Hot Ones — Buffalo Hot Sauce Original',
  'Hot Ones Buffalo',
  (select id from brands where name = 'Hot Ones (Heatonist)' order by created_at asc limit 1),
  'US', null, 2, null,
  '{"fr": "La sauce la plus douce du catalogue Hot Ones, échelle maison \"2/10\" — un clin d''œil au style Buffalo classique plutôt qu''une démonstration de force, pour rappeler d''où vient l''émission.", "en": "The mildest sauce in the Hot Ones lineup, house scale \"2/10\" — a nod to classic Buffalo style rather than a show of force, a reminder of where the show comes from.", "es": "La salsa más suave del catálogo Hot Ones, escala casera \"2/10\"."}',
  'bronze', 'editorial', 'published', 'images/sauces/hot-ones-buffalo-original.jpg', null, null, null, null, null
), (
  'Hot Ones — The Classic, Garlic Fresno Edition',
  'Hot Ones Classic Fresno',
  (select id from brands where name = 'Hot Ones (Heatonist)' order by created_at asc limit 1),
  'US', null, null,
  'Ail, piment Fresno, vinaigre',
  '{"fr": "Le piment Fresno, souvent confondu avec le jalapeño rouge mûr, prend ici toute la place aux côtés de l''ail — la version \"classique\" de la gamme Hot Ones, pensée pour un usage quotidien plutôt que pour le défi.", "en": "Fresno pepper, often mistaken for a ripe red jalapeño, takes center stage here alongside garlic — the \"classic\" entry in the Hot Ones range, built for daily use rather than a dare.", "es": "El chile Fresno, a menudo confundido con el jalapeño rojo maduro, protagonista junto al ajo."}',
  'silver', 'editorial', 'published', 'images/sauces/hot-ones-classic-fresno.jpg', null, null, null, null, null
), (
  'Hot Ones — Los Calientes',
  'Hot Ones Los Calientes',
  (select id from brands where name = 'Hot Ones (Heatonist)' order by created_at asc limit 1),
  'US', null, 5, null,
  '{"fr": "Un dégradé vert-jaune et une feuille d''érable stylisée : \"Los Calientes\" occupe le milieu de l''échelle maison Hot Ones, \"5/10\", sans plus de détail sur les piments utilisés.", "en": "A green-to-yellow gradient and a stylized maple leaf: \"Los Calientes\" sits in the middle of the Hot Ones house scale, \"5/10\", with no further detail on the peppers used.", "es": "Un degradado verde-amarillo y una hoja de arce estilizada: \"Los Calientes\" en el medio de la escala casera Hot Ones."}',
  'bronze', 'editorial', 'published', 'images/sauces/hot-ones-los-calientes.jpg', null, null, null, null, null
), (
  'Marie Sharp''s — Habanero Pepper Sauce (Mild, 50 ml)',
  'Marie Sharp''s Mild 50ml',
  (select id from brands where name = 'Marie Sharp''s' order by created_at asc limit 1),
  'BZ', null, null, null,
  '{"fr": "Le petit format de la gamme Marie Sharp''s, version douce — la même maison bélizienne que la Hot déjà au catalogue, mais pensée pour découvrir la marque sans s''engager sur un grand flacon.", "en": "The small-format entry in the Marie Sharp''s range, mild version — same Belizean house as the Hot already in the catalog, but sized to try the brand without committing to a full bottle.", "es": "El formato pequeño de la gama Marie Sharp''s, versión suave."}',
  'bronze', 'editorial', 'published', 'images/sauces/marie-sharps-mild-50ml.jpg', null, null, null, null, null
), (
  'Bhutila Fire — Chile Lengua de Fuego',
  'Bhutila Fire',
  (select id from brands where name = 'Chile Lengua de Fuego' order by created_at asc limit 1),
  'HN', 118000, null, -- SHU publié par la marque (source : Heatonist / PepperScale, recherche web du 01/08/2026)
  'Purée de jalapeño, concentré d''orange amère, oignon rouge fumé, purée de scotch bonnet, purée de super piments forts (Carolina Reaper, piment fantôme, choco-ghost), coriandre, sel, gingembre, ail fumé, poivre noir',
  '{"fr": "Bhutila, une île au large du Honduras, donne son nom à la sauce la plus reconnue de Chile Lengua de Fuego — quatre piments superposés, de l''orange amère pour l''acidité, et une place au 7e rang de la saison 16 de Hot Ones face à Gordon Ramsay et Salma Hayek.", "en": "Bhutila, an island off the coast of Honduras, lends its name to Chile Lengua de Fuego''s most recognized sauce — four peppers layered together, bitter orange for acidity, and a #7 spot in Hot Ones season 16 alongside Gordon Ramsay and Salma Hayek.", "es": "Bhutila, una isla frente a la costa de Honduras, da nombre a la salsa más reconocida de Chile Lengua de Fuego."}',
  'gold', 'editorial', 'published', 'images/sauces/bhutila-fire.jpg', null, null, null, null, null
), (
  'Swamp Sauce — White Whale x Sweet Pepper',
  'Swamp Sauce',
  (select id from brands where name = 'White Whale x Sweet Pepper' order by created_at asc limit 1),
  'NL', null, null,
  'Oignons caramélisés, jalapeños rôtis, piments rawit, maceron',
  '{"fr": "Un chien à lunettes de soleil et un lettrage \"boueux\" sur fond blanc : cette collaboration néerlandaise mise sur l''oignon caramélisé et le piment rawit (piment oiseau) plutôt que sur l''extrême.", "en": "A dog in sunglasses and \"muddy\" lettering on a white label: this Dutch collaboration leans on caramelized onion and rawit chili (bird''s eye chili) rather than going extreme.", "es": "Un perro con gafas de sol y letras \"embarradas\" sobre fondo blanco: esta colaboración neerlandesa apuesta por la cebolla caramelizada y el chile rawit."}',
  'silver', 'editorial', 'published', 'images/sauces/swamp-sauce.jpg', null, null, null, null, null
), (
  'Crazy Bastard Sauce — 7 Pot Tropical',
  'Crazy Bastard 7 Pot',
  (select id from brands where name = 'Crazy Bastard Sauce' order by created_at asc limit 1),
  'DE', null, null,
  'Vinaigre, paprika, oignons, mangue, ananas, piment 7 Pot (10%), melon, citron vert, sel marin, huile d''olive',
  '{"fr": "Le piment 7 Pot, cousin trinidadien du habanero, à seulement 10% de la recette — le reste est un mélange tropical mangue-ananas-melon signé d''un fabricant berlinois qui ne cache pas son goût pour l''esthétique bande dessinée.", "en": "7 Pot pepper, a Trinidadian cousin of habanero, at just 10% of the recipe — the rest is a mango-pineapple-melon tropical blend from a Berlin maker with an unmistakable comic-book aesthetic.", "es": "El chile 7 Pot, primo trinitense del habanero, con solo el 10% de la receta."}',
  'silver', 'editorial', 'published', 'images/sauces/crazy-bastard-7pot-tropical.jpg', null, null, null, null, null
), (
  'The Cole Men — Carolina Weeper Reaper Table Sauce',
  'Cole Men Carolina Weeper',
  (select id from brands where name = 'The Cole Men' order by created_at asc limit 1),
  'GB', null, null,
  'Eau, poivron rouge, sucre demerara, vinaigre de cidre, ail, oignon en poudre, paprika, sel, acide citrique, Carolina Reaper (0,36%), cumin, basilic, origan, persil, romarin, poivre noir, gomme xanthane',
  '{"fr": "0,36% de Carolina Reaper à peine, noyé dans une liste d''herbes dignes d''une sauce tomate italienne — The Cole Men, petite marque de Warrington, mise sur le dosage plutôt que sur la surenchère, médaille \"Great Taste\" à l''appui.", "en": "Barely 0.36% Carolina Reaper, buried in an herb list worthy of an Italian tomato sauce — The Cole Men, a small Warrington brand, bets on measured dosing rather than one-upmanship, \"Great Taste\" medal in hand.", "es": "Apenas 0,36% de Carolina Reaper, entre una lista de hierbas digna de una salsa de tomate italiana."}',
  'silver', 'editorial', 'published', 'images/sauces/cole-men-carolina-weeper.jpg', null, null, null, null, null
), (
  'Renae — Healthy Heat Reaper',
  'Renae Healthy Heat',
  (select id from brands where name = 'Renae' order by created_at asc limit 1),
  'ES', null, 8, null,
  '{"fr": "Une deuxième sauce Renae au catalogue, échelle maison \"8/10\" cette fois — même production artisanale andalouse que la Small Batch déjà présente, un cran plus haut sur le piquant annoncé.", "en": "A second Renae sauce in the catalog, house scale \"8/10\" this time — same small Andalusian production as the Small Batch already listed, one notch up on the announced heat.", "es": "Una segunda salsa Renae en el catálogo, escala casera \"8/10\" esta vez."}',
  'bronze', 'editorial', 'published', 'images/sauces/renae-healthy-heat-reaper.jpg', null, null, null, null, null
),

-- Canada
(
  'Heartbeat Hot Sauce — Hot to X-Hot',
  'Heartbeat Hot-XHot',
  (select id from brands where name = 'Heartbeat Hot Sauce' order by created_at asc limit 1),
  'CA', null, null,
  'Vinaigre distillé, poivron serrano, jalapeño, poblano, ananas, jus de citron vert, oignon, miel, échalote, sel de mer, ail, huile d''olive, persil, huile d''avocat, coriandre, origan',
  '{"fr": "Trois piments plutôt qu''un seul (serrano, jalapeño, poblano), portés par l''ananas et le miel — cette sauce de Thunder Bay, en Ontario, occupe le haut de gamme d''une marque qui décline aussi des versions plus douces.", "en": "Three peppers rather than one (serrano, jalapeño, poblano), carried by pineapple and honey — this Thunder Bay, Ontario sauce sits at the top end of a brand that also offers milder versions.", "es": "Tres chiles en lugar de uno (serrano, jalapeño, poblano), llevados por la piña y la miel."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
),

-- Slovénie
(
  'Pekočko — Sauce Pimentée #9 "Diablement Divine"',
  'Pekočko #9',
  (select id from brands where name = 'Pekočko' order by created_at asc limit 1),
  'SI', null, null, null,
  '{"fr": "Un mini-flacon de 42 ml à l''étiquette gravée d''une tête de cerf, numéro 9 d''une série slovène qui préfère la petite dose au grand format — \"Diablement Divine\" en dit plus sur l''intention que sur la recette.", "en": "A 42 ml mini bottle with an engraved deer-head label, number 9 of a Slovenian series that favors small doses over big bottles — \"Diablement Divine\" says more about the intent than the recipe.", "es": "Un mini frasco de 42 ml con una etiqueta grabada de cabeza de ciervo, número 9 de una serie eslovena."}',
  'bronze', 'editorial', 'published', 'images/sauces/pekocko-9.jpg', null, null, null, null, null
)

on conflict (name_short) do nothing;

-- ---------------------------------------------------------
-- Liens piments et sauces
-- ---------------------------------------------------------

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Picante Bocatoreño' and p.name_fr like 'Piment Scotch Bonnet%'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Doraz Sin Azúcar' and p.name_fr like 'Piment Scotch Bonnet%'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Frank''s Wings Buffalo' and p.name_fr = 'Piment Cayenne'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Don Julio Cabro' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Nachyo Mommas Chipotle' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Iguana Habanero' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Iguashte Chiltepe' and p.name_fr = 'Piment Chiltepe (Chiltepín)'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'La Fulana Jaguar' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Picantos Nagga Jolokia' and p.name_fr = 'Piment Fantôme (Bhut Jolokia)'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Amazon Ají Chipotle' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Torchbearer Sweet Onion' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Branford''s Crazy Mango' and p.name_fr in ('Piment Cayenne', 'Habanero')
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Señor Lechuga .718' and p.name_fr = 'Piment Fantôme (Bhut Jolokia)'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Señor Lechuga Ghost' and p.name_fr = 'Piment Fantôme (Bhut Jolokia)'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Hot Ones Classic Fresno' and p.name_fr = 'Piment Fresno'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Marie Sharp''s Mild 50ml' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Bhutila Fire'
    and (p.name_fr = 'Piment Fantôme (Bhut Jolokia)' or p.name_fr like 'Piment Scotch Bonnet%' or p.name_fr = 'Piment Carolina Reaper')
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Swamp Sauce' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Cole Men Carolina Weeper' and p.name_fr = 'Piment Carolina Reaper'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Renae Healthy Heat' and p.name_fr = 'Piment Carolina Reaper'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Heartbeat Hot-XHot' and p.name_fr in ('Piment Serrano', 'Piment Jalapeño')
on conflict (sauce_id, pepper_type_id) do nothing;

-- ---------------------------------------------------------
-- Tags aromatiques
-- ---------------------------------------------------------

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Picante Bocatoreño' and f.slug in ('vinaigre', 'aille', 'herbace')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Picantos Nagga Jolokia' and f.slug in ('acidule', 'epice')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Amazon Ají Chipotle' and f.slug in ('fume', 'acidule', 'vinaigre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Torchbearer Sweet Onion' and f.slug in ('sucre', 'aille', 'vinaigre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Branford''s Crazy Mango' and f.slug in ('fruite', 'sucre', 'caramel')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Señor Lechuga .718' and f.slug in ('citronne', 'acidule', 'terreux')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Señor Lechuga Ghost' and f.slug in ('epice', 'terreux', 'citronne')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Hot Ones Classic Fresno' and f.slug in ('aille', 'vinaigre', 'epice')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Bhutila Fire' and f.slug in ('fume', 'citronne', 'terreux')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Swamp Sauce' and f.slug in ('caramel', 'terreux', 'epice')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Crazy Bastard 7 Pot' and f.slug in ('tropical', 'fruite', 'acidule')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Cole Men Carolina Weeper' and f.slug in ('herbace', 'sucre', 'poivre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Heartbeat Hot-XHot' and f.slug in ('tropical', 'sucre', 'herbace')
on conflict (sauce_id, flavor_tag_id) do nothing;

-- ---------------------------------------------------------
-- Mise à jour d'image : la vague 3 avait intégré Hoff's Haus Sauce
-- sans photo de face exploitable. Cette relecture en a trouvé une.
-- ---------------------------------------------------------

update sauces
  set image_bottle_url = 'images/sauces/hoffs-haus-sauce.jpg'
  where name_short = 'Hoff''s Haus Sauce' and image_bottle_url is null;
