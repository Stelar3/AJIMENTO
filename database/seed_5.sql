-- ═══════════════════════════════════════════════════════════
-- Ajimento — Données de départ (seed), vague 5
-- 17 nouvelles sauces réelles, sélectionnées dans le reliquat
-- à confiance élevée de l'étude de déduplication (voir
-- docs/etude-deduplication-sauces.md) — des sauces repérées dès
-- la vague 4 mais volontairement laissées de côté pour garder
-- chaque fichier de seed à une taille raisonnable.
-- ═══════════════════════════════════════════════════════════
--
-- À exécuter APRÈS seed.sql, seed_2.sql, seed_3.sql et seed_4.sql,
-- dans le même SQL Editor Supabase.
--
-- Même discipline que les vagues précédentes : ingrédients et SHU
-- uniquement quand réellement lisibles sur l'étiquette photographiée
-- — la plupart des sauces panaméennes de cette vague ont été vues
-- en rayon, texte trop petit pour la liste d'ingrédients complète,
-- d'où beaucoup de valeurs vides ici encore.
--
-- 1 sauce de cette vague utilise une vraie photo de bouteille
-- (Heartbeat Sauce Verde) ; les autres gardent le repli SVG
-- générique, faute de photo de face isolée exploitable.
--
-- Ce fichier est réexécutable sans risque (ON CONFLICT DO NOTHING
-- partout) grâce aux contraintes d'unicité déjà en place.

-- ---------------------------------------------------------
-- Nouvelles marques
-- ---------------------------------------------------------

insert into brands (name, country_of_origin, founding_year, description, type) values
  ('D''Elidas', 'PA', null, 'Marque panaméenne déclinée en plusieurs recettes (chombo, chipotle, agridulce) — une des gammes les plus présentes en rayon de supermarché au Panama.', 'industrial'),
  ('La Picon', 'PA', null, 'Sauce panaméenne "Fuego Tropical", positionnée sur les saveurs fruitées (mangue) plutôt que sur le piquant pur.', 'artisanal'),
  ('Proluxsa', 'PA', 1964, 'Fabricant panaméen historique (depuis 1964), à l''origine de plusieurs marques du pays dont Congo — cette sauce agridulce porte directement le nom Proluxsa sur l''étiquette.', 'industrial'),
  ('D Doria', 'PA', null, 'Sauce panaméenne "Picante Natural Artesanal", positionnée gourmet et extra forte.', 'artisanal'),
  ('Tio Ivan', 'PA', null, 'Petite marque panaméenne à l''étiquette illustrée d''un visage stylisé rouge.', 'artisanal'),
  ('EBISU', 'CR', null, 'Ligne "Sabor & Sazón" costaricienne de sauces gourmet aux associations fruit/piment inhabituelles (kiwi, mûre, maracuyá).', 'artisanal')
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
  'D''Elidas Picante Chombo (Habanero Pepper Sauce)',
  'D''Elidas Chombo',
  (select id from brands where name = 'D''Elidas' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "La recette de base de D''Elidas, habanero et piments verts et rouges en illustration — une gamme panaméenne si présente en rayon qu''elle sert presque de point de comparaison pour les autres.", "en": "D''Elidas'' base recipe, habanero with red and green peppers on the label — a Panamanian range so common on shelves that it almost serves as a benchmark for the others.", "es": "La receta base de D''Elidas, habanero con chiles rojos y verdes en la ilustración."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'D''Elidas Chipotle — Sazón Suprema',
  'D''Elidas Chipotle',
  (select id from brands where name = 'D''Elidas' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "La version fumée de la gamme D''Elidas, chipotle plutôt que habanero cru — un profil plus rare dans les rayons panaméens, dominés par l''ají chombo.", "en": "The smoky entry in the D''Elidas range, chipotle rather than raw habanero — a rarer profile on Panamanian shelves, which lean heavily on aji chombo.", "es": "La versión ahumada de la gama D''Elidas, chipotle en lugar de habanero crudo."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'D''Elidas Spicy Sweet & Sour Sauce',
  'D''Elidas Sweet Sour',
  (select id from brands where name = 'D''Elidas' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "Une troisième voie pour D''Elidas, aigre-douce plutôt que franchement piquante — pensée pour les plats sautés plus que pour la table.", "en": "A third path for D''Elidas, sweet and sour rather than straightforwardly hot — built for stir-fries more than for the table.", "es": "Una tercera vía para D''Elidas, agridulce en lugar de francamente picante."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'La Picon — Salsa Picante Fuego Tropical (Mango)',
  'La Picon Fuego Tropical',
  (select id from brands where name = 'La Picon' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "La mangue plutôt que le piment en vedette : La Picon mise sur une étiquette verte lune et le mot \"tropical\" pour se démarquer des sauces panaméennes plus classiques.", "en": "Mango takes the lead over pepper here: La Picon leans on a green, moon-lit label and the word \"tropical\" to stand apart from more classic Panamanian sauces.", "es": "El mango antes que el chile como protagonista: La Picon apuesta por una etiqueta verde con luna y la palabra \"tropical\"."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Proluxsa — Salsa Agridulce con Picante (Mild)',
  'Proluxsa Agridulce',
  (select id from brands where name = 'Proluxsa' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "Proluxsa fabrique aussi les sauces Congo déjà au catalogue, mais celle-ci porte son propre nom sur l''étiquette — une version agrodulce et douce, loin de l''ají habanero pur.", "en": "Proluxsa also makes the Congo sauces already in the catalog, but this one carries its own name on the label — a mild, sweet-and-sour version, far from pure aji habanero.", "es": "Proluxsa también fabrica las salsas Congo ya presentes en el catálogo, pero esta lleva su propio nombre en la etiqueta."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'D Doria — Picante Natural Artesanal, Extra Hot',
  'D Doria Extra Hot',
  (select id from brands where name = 'D Doria' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "\"Gourmet Panamanian Special Hot Sauce\" annonce l''étiquette orange dégradé de D Doria — une promesse plus qu''un chiffre, dans un pays où peu de sauces artisanales publient leur Scoville.", "en": "\"Gourmet Panamanian Special Hot Sauce\" announces D Doria''s orange gradient label — a promise more than a number, in a country where few artisanal sauces publish their Scoville rating.", "es": "\"Gourmet Panamanian Special Hot Sauce\" anuncia la etiqueta degradada naranja de D Doria."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Tio Ivan — Pretty Spicy Afro',
  'Tio Ivan Afro',
  (select id from brands where name = 'Tio Ivan' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "Une étiquette noire à visage stylisé rouge, un nom qui ne cache pas son inspiration afro-panaméenne — une petite marque parmi les nombreuses sauces artisanales de la région de Bocas del Toro.", "en": "A black label with a stylized red face, a name that doesn''t hide its Afro-Panamanian inspiration — a small brand among the many artisanal sauces of the Bocas del Toro region.", "es": "Una etiqueta negra con un rostro estilizado rojo, un nombre que no oculta su inspiración afropanameña."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Really Buokas — Sazón Artesanal Afro-Antillano',
  'Buokas Afro-Antillano',
  (select id from brands where name = 'Really Buokas' order by created_at asc limit 1),
  'PA', null, null, null,
  '{"fr": "Une deuxième recette Really Buokas, à l''étiquette vert-jaune plutôt que rouge-vert — la même identité afro-antillane de Bocas del Toro, déclinée dans un packaging différent.", "en": "A second Really Buokas recipe, green-yellow label rather than red-green — the same Afro-Antillean identity from Bocas del Toro, in different packaging.", "es": "Una segunda receta Really Buokas, con etiqueta verde-amarilla en lugar de roja-verde."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
),

-- Costa Rica
(
  'EBISU — Salsa Gourmet Kiwi y Jalapeño',
  'EBISU Kiwi Jalapeño',
  (select id from brands where name = 'EBISU' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "Le kiwi et le jalapeño ne se croisent presque jamais dans une sauce piquante — EBISU en fait pourtant l''une de ses quatre associations \"Sabor & Sazón\", logo colibri à l''appui.", "en": "Kiwi and jalapeño almost never meet in a hot sauce — yet EBISU makes it one of its four \"Sabor & Sazón\" pairings, hummingbird logo included.", "es": "El kiwi y el jalapeño casi nunca se cruzan en una salsa picante — EBISU lo convierte en una de sus cuatro combinaciones \"Sabor & Sazón\"."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'EBISU — Salsa Volcán, Carolina Reaper',
  'EBISU Volcán Reaper',
  (select id from brands where name = 'EBISU' order by created_at asc limit 1),
  'CR', null, null, null,
  '{"fr": "La version la plus forte de la gamme EBISU, logo volcan rouge et Carolina Reaper en vedette — un contraste net avec les trois autres associations plus fruitées de la même marque.", "en": "The hottest entry in the EBISU range, red volcano logo and Carolina Reaper front and center — a sharp contrast with the brand''s three other, fruitier pairings.", "es": "La versión más fuerte de la gama EBISU, con logo de volcán rojo y Carolina Reaper como protagonista."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
), (
  'EBISU — Salsa Gourmet, Mora, Vino Tinto y Chile Chipotle',
  'EBISU Mora Chipotle',
  (select id from brands where name = 'EBISU' order by created_at asc limit 1),
  'CR', null, null,
  'Mûres, vin rouge, chipotle',
  '{"fr": "Mûre, vin rouge et chipotle : la sauce la plus \"vineuse\" de la gamme EBISU, logo orchidée violette, pensée pour les viandes rouges plutôt que pour relever un taco.", "en": "Blackberry, red wine and chipotle: the most \"wine-forward\" sauce in the EBISU range, purple orchid logo, built for red meat more than for topping a taco.", "es": "Mora, vino tinto y chipotle: la salsa más \"vinosa\" de la gama EBISU."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
), (
  'EBISU — Chutney Salsa Brava (Piña, Mango, Maracuyá, Chile Habanero)',
  'EBISU Chutney Brava',
  (select id from brands where name = 'EBISU' order by created_at asc limit 1),
  'CR', null, null,
  'Piña, mango, maracuyá, chile habanero',
  '{"fr": "Trois fruits tropicaux pour un seul piment : cette sauce EBISU, logo toucan, se présente autant comme un chutney que comme une sauce piquante classique.", "en": "Three tropical fruits for a single pepper: this EBISU sauce, toucan logo, reads as much like a chutney as a classic hot sauce.", "es": "Tres frutas tropicales para un solo chile: esta salsa EBISU se presenta tanto como chutney como salsa picante clásica."}',
  'silver', 'editorial', 'published', null, null, null, null, null, null
),

-- USA
(
  'Tabasco — Jalapeño Green Pepper Sauce',
  'Tabasco Jalapeño Verde',
  (select id from brands where name = 'Tabasco' order by created_at asc limit 1),
  'US', null, null, null,
  '{"fr": "La version verte et douce de Tabasco, jalapeño plutôt que piment tabasco vieilli — vendue dans les mêmes rayons qu''Amérique centrale que l''Original déjà au catalogue.", "en": "Tabasco''s green, milder cousin, jalapeño instead of aged tabasco pepper — sold on the same Central American shelves as the Original already in the catalog.", "es": "La versión verde y suave de Tabasco, jalapeño en lugar de chile tabasco añejado."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Tabasco — Garlic Pepper Sauce (Mild)',
  'Tabasco Garlic Mild',
  (select id from brands where name = 'Tabasco' order by created_at asc limit 1),
  'US', null, null, null,
  '{"fr": "Une déclinaison ail de la maison Tabasco, format réduit (60 ml) — moins connue que l''Original ou la version Jalapeño, mais vendue dans les mêmes circuits centraméricains.", "en": "A garlic variant from the Tabasco house, in a smaller 60 ml bottle — less known than the Original or the Jalapeño version, but sold through the same Central American channels.", "es": "Una variante de ajo de la casa Tabasco, en formato reducido (60 ml)."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
),

-- Belize
(
  'Marie Sharp''s — Nopal Green Habanero Pepper Sauce',
  'Marie Sharp''s Nopal',
  (select id from brands where name = 'Marie Sharp''s' order by created_at asc limit 1),
  'BZ', null, null, null,
  '{"fr": "Le nopal (figue de barbarie) rejoint le habanero vert dans cette variante Marie Sharp''s, moins connue que la gamme rouge classique de la maison bélizienne.", "en": "Nopal (prickly pear cactus) joins green habanero in this Marie Sharp''s variant, less known than the house''s classic red range.", "es": "El nopal se une al habanero verde en esta variante de Marie Sharp''s, menos conocida que la gama roja clásica de la casa beliceña."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
), (
  'Marie Sharp''s — Garlic Pepper Sauce',
  'Marie Sharp''s Garlic',
  (select id from brands where name = 'Marie Sharp''s' order by created_at asc limit 1),
  'BZ', null, null, null,
  '{"fr": "L''ail prend le pas sur le habanero dans cette variante de la gamme bélizienne — une sauce pensée pour parfumer plus que pour piquer, dans un petit format comme les autres membres de la famille Marie Sharp''s.", "en": "Garlic takes the lead over habanero in this Belizean range variant — a sauce built to flavor more than to burn, in a small format like the rest of the Marie Sharp''s family.", "es": "El ajo toma la delantera sobre el habanero en esta variante de la gama beliceña."}',
  'bronze', 'editorial', 'published', null, null, null, null, null, null
),

-- Canada
(
  'Heartbeat Hot Sauce x Laurent Dagenais — Sauce Verde',
  'Heartbeat Sauce Verde',
  (select id from brands where name = 'Heartbeat Hot Sauce' order by created_at asc limit 1),
  'CA', null, null, null,
  '{"fr": "Une collaboration entre Heartbeat et le chef québécois Laurent Dagenais, mascotte rose \"Toujours Faim\" à l''appui — une sauce verte, bilingue français-anglais, distincte de la gamme ontarienne classique de la marque.", "en": "A collaboration between Heartbeat and Quebec chef Laurent Dagenais, \"Toujours Faim\" pink mascot included — a green sauce, bilingual French-English, distinct from the brand''s classic Ontario range.", "es": "Una colaboración entre Heartbeat y el chef quebequense Laurent Dagenais — una salsa verde, bilingüe francés-inglés."}',
  'bronze', 'editorial', 'published', 'images/sauces/heartbeat-sauce-verde.jpg', null, null, null, null, null
)

on conflict (name_short) do nothing;

-- ---------------------------------------------------------
-- Liens piments et sauces
-- ---------------------------------------------------------

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'D''Elidas Chombo' and p.name_fr like 'Piment Scotch Bonnet%'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'D''Elidas Chipotle' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'EBISU Kiwi Jalapeño' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'EBISU Volcán Reaper' and p.name_fr = 'Piment Carolina Reaper'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'EBISU Mora Chipotle' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'EBISU Chutney Brava' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Tabasco Jalapeño Verde' and p.name_fr = 'Piment Jalapeño'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Marie Sharp''s Nopal' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

insert into sauce_pepper_types (sauce_id, pepper_type_id)
  select s.id, p.id from sauces s, pepper_types p
  where s.name_short = 'Marie Sharp''s Garlic' and p.name_fr = 'Habanero'
on conflict (sauce_id, pepper_type_id) do nothing;

-- ---------------------------------------------------------
-- Tags aromatiques
-- ---------------------------------------------------------

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'La Picon Fuego Tropical' and f.slug in ('tropical', 'fruite', 'sucre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Proluxsa Agridulce' and f.slug in ('sucre', 'acidule', 'vinaigre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'D''Elidas Sweet Sour' and f.slug in ('sucre', 'acidule', 'vinaigre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'EBISU Kiwi Jalapeño' and f.slug in ('fruite', 'acidule', 'tropical')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'EBISU Mora Chipotle' and f.slug in ('fruite', 'fume', 'terreux')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'EBISU Chutney Brava' and f.slug in ('tropical', 'fruite', 'sucre')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Marie Sharp''s Garlic' and f.slug in ('aille', 'salin')
on conflict (sauce_id, flavor_tag_id) do nothing;

insert into sauce_flavor_tags (sauce_id, flavor_tag_id)
  select s.id, f.id from sauces s, flavor_tags f
  where s.name_short = 'Heartbeat Sauce Verde' and f.slug in ('herbace', 'acidule', 'tropical')
on conflict (sauce_id, flavor_tag_id) do nothing;
