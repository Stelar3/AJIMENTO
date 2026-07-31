# Étude de déduplication — les ~130 photos de sauces

Réalisée le 31/07/2026, en réponse à la question de Brice : *"il n'y a pas autant de sauces, il y a maximum 50 — regarde les formats de bouteilles, les étiquettes, les codes couleurs, les contenus."*

## Méthode

Le premier catalogage (`photos-inventaire-brut.md`) listait ~150 sauces à partir de **noms présumés**, sans vérifier systématiquement si deux photos montraient la même bouteille sous un autre angle. Cette fois, 5 lots de ~26 photos ont été revus **un par un, visuellement** (forme de bouteille, couleur de bouchon, design/couleurs d'étiquette, logo ou mascotte) par 5 agents séparés, avec pour consigne explicite de fusionner deux photos dès qu'elles montrent la même bouteille. J'ai ensuite recroisé les 5 lots entre eux pour repérer les doublons qui traversent les lots (le même magasin ou la même bouteille photographiée à des moments différents de la collection).

**Point important à te signaler honnêtement : le vrai total n'est pas ~50, il est plus proche de 110–130 produits distincts.** Pas parce que le premier comptage était mauvais sur les doublons d'angle — sur ce point ton intuition était juste, j'ai fusionné une bonne vingtaine de doublons (voir plus bas). Mais parce que plusieurs de tes photos sont des **photos de rayon entier** (boutique Costa Rica, supermarché Panama, vitrine Honduras, vitrine Guatemala, duty-free) qui contiennent chacune 10 à 20 bouteilles différentes côte à côte. Une seule photo = un seul fichier, mais 15 produits dessus. C'est ce qui fait remonter le total, pas une erreur de dédoublonnage.

## Doublons inter-lots confirmés (fusionnés)

Ces produits apparaissaient sous des noms/lots séparés dans le premier catalogage ; ils désignent la même bouteille :

- **La Selva — Le Piquant (Picante Alto)** : lot 1 (053e47c3, 06d511dd) + lot 4 (b7470661)
- **Branford's — Crazy Mango Hot Sauce** : lot 1 (065b29aa, 08e5be46) + lot 5 (e9f73de6)
- **Da'Bomb — Evolution** : lot 1 (12842a22, face) + lot 2 (300ea60b, dos)
- **The Cole Men — Carolina Weeper** : lot 1 (17b4eb7c, face) + lot 3 (8ebac55a, dos)
- **Hoff & Pepper — Hoff's Haus Sauce** : lot 1 (10833baf, 1cc40122) + lot 3 (8a9c7ffb, face) — **déjà en base** (seed_3.sql), la photo 8a9c7ffb donne enfin une face avant exploitable pour remplacer l'image manquante
- **Hot Ones — The Last Dab: Apollo** : lot 2 (2e21e0a1, face) + lot 3 (63356b96, dos) + lot 4 (9a1040bb, dos)
- **Hot Ones — Buffalo Hot Sauce Original** : lot 2 (2fe46a09, dos) + lot 3 (898fdb3d, face)
- **Mono Loco — Viaje Verde** : lot 2 (2e5645d0, 4d67f4fd) + lot 5 (f5157211)
- **D'Elidas — Picante Chombo Verde Pura Pulpa** : lot 2 (3366d5a0) + lot 5 (f3eea67d)
- **Doraz — Ajichombo sin azúcar añadida (300 ml)** : lot 2 (3366d5a0) + lot 4 (b0adc52d, étiquette prix) + lot 5 (f3eea67d)
- **White Whale x Sweet Pepper — Swamp Sauce** : lot 2 (3c48087e, dos) + lot 3 (6d732edf, face)
- **Iguashte — Salsa picante de chile chiltepe** : lot 1 (2208dd66, 1d7bef43) + lot 2 (404bc55e)
- **Picantos — Ají Nagga Jolokia** : lot 1 (034d1180) + lot 2 (4575e4dd)
- **Don Julio — Salsa de Chile Cabro (Caribbean Yellow Habanero)** : lot 1 (2208dd66) + lot 2 (5855035b) + lot 5 (d6535e71)
- **Renae — Small Batch Carolina Reaper** : lot 2 (46a7a488) — **déjà en base** (seed_3.sql), confirmé identique, aucune nouvelle info
- **Congo — Picante Antillano (Coluxsa/Proluxsa)** : lot 2 (3366d5a0) — **déjà en base** sous "Congo Picante Original" (mêmes ingrédients exacts), confirmé identique
- **Marque non identifiée (Slovénie, whisky Laphroaig)** : lot 2 (5a6cfc70, dos) + lot 4 (932e9a4d, ca6b65c7, dos) — 3 photos du dos de la même bouteille, marque toujours non visible → à chercher (voir plus bas)
- **Amazon Pepper — Ají Chipotle** : lot 2 (2a2ecfb9, face) + lot 4 (b2fdf34a, 68db5e7e, dos) + lot 5 (e1533a7c, dos)
- **Melinda's — Bhut Jolokia Ghost Pepper** : lot 3 (7012d7fe, dos — c'est la photo déjà utilisée en base) + lot 4 (bbb4806f face, cf6762f8 dos) — **déjà en base**, et bbb4806f est justement la photo de face qui vient de remplacer l'ancienne image dos dans `images/sauces/melindas-ghost-pepper.jpg`
- **Marie Sharp's — Smokin' Marie (Special Edition)** : lot 3 (cf214853, face) + lot 5 (e607c73d, dos) — **déjà en base**

## Produits déjà en base — confirmés / précisés par cette relecture

| Sauce déjà intégrée | Ce que cette relecture apporte |
|---|---|
| Hoff's Haus Sauce | Photo de face disponible (8a9c7ffb) → à utiliser pour donner une image bouteille à cette fiche, qui n'en a pas |
| Renae Small Batch | Confirmé identique, rien de neuf |
| Congo Picante Original | Confirmé identique, rien de neuf |
| Melinda's Ghost Pepper | Confirmé identique — photo de face déjà intégrée aujourd'hui |
| Marie Sharp's Smokin' | Confirmé identique, une meilleure photo de dos disponible si besoin |

## Estimation chiffrée

- **Sightings bruts relevés par les 5 lots** : environ 208 lignes (avant tout recoupement)
- **Doublons inter-lots fusionnés** : ~20 (liste ci-dessus)
- **Déjà en base (vague 1/2/3)** : 20 sauces, dont 5 revues ici
- **Produits neufs à confiance ÉLEVÉE** (marque + nom clairement lisibles, prêts à intégrer) : **~45–50**
- **Produits neufs à confiance MOYENNE** (marque claire, variante/nom à confirmer, souvent vus en rayon) : **~35–40**
- **Produits à confiance FAIBLE** (texte flou/trop petit en rayon, non exploitables tels quels) : **~25–30**
- **Entrées à marque non identifiée** (nécessitent une recherche web pour identifier le fabricant) : une douzaine, dont notamment :
  - La vitrine "Gourmet Hot Sauce" au Guatemala (~15 saveurs, marque exacte du fabricant non visible sur l'étiquette)
  - La bouteille slovène au whisky Laphroaig (Carolina Reaper + Trinidad Scorpion, marque non visible)
  - "Bhutila Fire" / "Lengua de Fuego" (Honduras) — deux appellations proches, à clarifier si c'est une ou deux marques
  - Plusieurs sauces UK ("Flavour First Sauces", Warrington) et françaises (sauce Carolina Reaper/Trinidad Scorpion, marque coupée sur la photo)

## Recommandation

Vu l'écart avec l'estimation initiale, je propose de procéder ainsi plutôt que tout intégrer d'un coup :

1. **Vague 4 (maintenant)** : les ~45-50 produits à confiance élevée, cross-dédupliqués — c'est la liste la plus sûre, aucune invention, marque et nom lisibles sur la photo elle-même.
2. **Vague 5 (ensuite)** : les entrées à marque non identifiée, après recherche web ciblée (tâche déjà en cours).
3. **Laissées de côté pour l'instant** : les ~25-30 sightings à confiance faible (rayons flous, texte trop petit) — sauf si tu confirmes toi-même certains noms de mémoire, je préfère ne rien deviner.

## Annexe — tableaux bruts des 5 lots

Les tableaux complets produits par chaque relecture (avec tous les fichiers sources, signatures visuelles, ingrédients et niveaux de confiance détaillés) sont conservés dans l'historique de session ; je les intègre ici en synthèse condensée par lot pour référence future si besoin de revérifier une entrée précise. Pour le détail fichier-par-fichier, se référer aux 5 rapports de catalogage du 31/07/2026.

- **Lot 1** (fichiers 00408c19 → 29739f5b) : 38 sightings bruts, 32 à confiance moyenne/élevée
- **Lot 2** (fichiers 2a2ecfb9 → 633350aa) : 37 sightings bruts, 37 à confiance moyenne/élevée (peu de doublons d'angle dans ce lot)
- **Lot 3** (fichiers 63356b96 → 8ebac55a) : 32 sightings bruts, dont 16 en gros plan individuel + 5 vues de rayon regroupant plusieurs SKU
- **Lot 4** (fichiers 911a4766 → cf6762f8) : 45 sightings bruts, 16 en gros plan individuel + 29 vus en rayon (Panama, Guatemala/Costa Rica, France)
- **Lot 5** (fichiers d197ebfb → fd9f09ff) : 56 sightings bruts — lot avec le plus de photos de rayon (13/33), d'où le total élevé
