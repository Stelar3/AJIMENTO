-- ═══════════════════════════════════════════════════════════
-- Ajimento — Codes-barres
-- ═══════════════════════════════════════════════════════════
-- À exécuter après seed_3.sql. Alimente la table `barcodes`,
-- utilisée par le Scanner (scanner.html) pour retrouver une
-- sauce à partir d'un vrai code-barres photographié.
--
-- Un seul code pour l'instant : celui de Melinda's Ghost Pepper,
-- lisible sur la photo de l'étiquette arrière prise par Brice
-- ("barcode 7 36924 50703 4" → UPC-A 736924507034). Comme pour
-- les ingrédients et le SHU : on ne devine jamais un code-barres,
-- on ne l'ajoute que quand il est réellement lisible sur une photo.
-- Les prochaines vagues de cataloguage devront noter le code-barres
-- quand il est visible, pour enrichir cette table au fil du temps.
--
-- Réexécutable sans risque (ON CONFLICT DO NOTHING) grâce à la
-- contrainte d'unicité ajoutée sur barcodes.code (voir schema.sql).

insert into barcodes (sauce_id, code, type)
  select id, '736924507034', 'UPC-A'
  from sauces
  where name_short = 'Melinda''s Ghost Pepper'
on conflict (code) do nothing;
