# SCOVL — Analyse multi-prismes : Base de données
### Vision panoramique pour aligner les décisions avant de construire
*Juin 2026 — Document de référence interne*

---

## Contexte de l'analyse

Les photos fournies documentent un rayon hot sauce d'un supermarché au Panama. On y identifie environ 25 références actives : marques locales artisanales (Really Buokas, Ajichombo/Doraz, D'Elidas, Congo/Proluxsa, D Doria, Mamita, Amazon Pepper, La Picon), marques latino-américaines (Picantos Colombia, Amazon Pepper), et marques internationales grand public (Tabasco, Frank's RedHot, Kikkoman Wasabi, The Ginger People). Ces photos constituent le point de départ empirique — non la limite — de la base de données SCOVL.

---

## PRISME 1 — Business Manager

### Ce que la base de données représente stratégiquement

La base de données n'est pas une feature. C'est **l'actif central** de SCOVL. Sans elle, l'application n'est qu'une interface vide. Sa valeur croît avec le temps, le volume, et la qualité des données — exactement comme le catalogue de Vivino, qui est aujourd'hui la barrière à l'entrée la plus difficile à répliquer pour un concurrent.

### Modèle économique de la donnée

Le choix d'un **modèle hybride éditorial + communauté** est stratégiquement pertinent, mais génère une tension réelle :

- **Couche éditoriale** (contrôlée par SCOVL) : garantit la qualité, la cohérence du ton, la profondeur du storytelling. C'est le différenciateur de marque. Elle doit couvrir les 300 à 500 références "premium" les plus documentables en priorité.
- **Couche communautaire** (alimentée par les utilisateurs) : permet la scalabilité mondiale sans budget. Elle doit être encadrée par un protocole de validation strict pour ne pas diluer la crédibilité.

**Risque business :** une base mondiale dès le lancement avec des données partielles ou approximatives dégrade l'expérience et donc la rétention. Il vaut mieux **500 sauces excellemment documentées** que 5 000 fiches incomplètes.

### Recommandation business

Définir trois niveaux de complétude de fiche comme politique interne :

| Niveau | Contenu minimum | Usage dans l'app |
|--------|----------------|-----------------|
| **Bronze** | Nom, marque, pays, photo, code-barres | Scannable, cataloguable |
| **Silver** | + Scoville estimé, ingrédients, type de piment | Recommandable, comparable |
| **Gold** | + Storytelling, profil aromatique complet, notes éditoriales | Mise en avant éditoriale, Cave |

L'objectif au lancement : **150 fiches Gold minimum**, représentatives de 6 à 8 grandes familles géographiques.

---

## PRISME 2 — Expert UX/UI

### Ce que l'utilisateur attend de la base de données

L'utilisateur de SCOVL interagit avec la base de données dans **quatre contextes distincts**, chacun ayant des exigences différentes :

1. **Scan** : reconnaissance instantanée par code-barres ou image. Tolérance à l'échec : quasi-nulle. Si la sauce n'est pas reconnue, l'expérience est brisée. → La base doit couvrir les codes EAN/UPC prioritairement.

2. **Exploration** : navigation par filtres (niveau de chaleur, origine, type de piment, profil aromatique). L'utilisateur veut découvrir. → La taxinomie des données doit être pensée pour le filtrage multi-critères, pas seulement pour le stockage.

3. **Fiche produit** : consultation approfondie. L'utilisateur veut comprendre l'histoire de la sauce, ses arômes, ses usages. → Le storytelling est une donnée UX, pas seulement éditoriale.

4. **Cave personnelle** : organisation de sa collection. L'utilisateur veut noter, comparer, partager. → Les données doivent supporter des états utilisateur (noté, dans ma cave, goûté, envie de goûter).

### Contraintes UX sur la structure de données

- **Le nom de la sauce doit exister en version courte** (max 25 caractères) pour les cards de liste. "Mamita Salsa Picante Habanero" doit avoir un alias "Mamita Habanero".
- **Le niveau Scoville doit avoir une représentation visuelle normalisée** (ex : échelle de 1 à 10 + valeur SHU) car les chiffres bruts (100 000 SHU) sont illisibles pour le grand public.
- **Le profil aromatique doit être structuré en tags fermés**, pas en texte libre, pour permettre le filtrage (ex : fumé / fruité / acidulé / terreux / floral).
- **Les images** : chaque sauce doit avoir au minimum une photo de la bouteille sur fond neutre ET une photo en contexte (rayon, table, cuisine). L'identité visuelle de SCOVL repose sur la qualité photographique.

### Point de vigilance UX critique

La contribution communautaire des photos est le risque UX le plus élevé. Une photo floue ou de mauvaise qualité sur une fiche détruit la perception de la marque. Il faut un **système de modération visuelle** avant publication, même automatisé (détection de flou, vérification de résolution minimum).

---

## PRISME 3 — Développeur Back-end

### Architecture de la base de données

Le modèle de données doit être pensé pour supporter les trois usages principaux : scan, exploration, contribution communautaire.

#### Entités principales proposées

```
SAUCE
├── id (UUID)
├── name_full (string, 100 chars)
├── name_short (string, 25 chars)
├── brand_id (FK → BRAND)
├── origin_country (ISO 3166)
├── origin_region (string, optionnel)
├── heat_level_shu_min (int, nullable)
├── heat_level_shu_max (int, nullable)
├── heat_level_display (int, 1-10, calculé)
├── pepper_types[] (FK → PEPPER_TYPE)
├── flavor_tags[] (FK → FLAVOR_TAG, liste fermée)
├── ingredients_raw (text, optionnel)
├── ingredients_parsed[] (FK → INGREDIENT)
├── nutrition_per_100g (JSONB)
├── net_weight_g (int)
├── barcodes[] (EAN13, UPC-A, QR)
├── story (text, markdown, optionnel)
├── completion_level (enum: bronze/silver/gold)
├── source (enum: editorial/community/import)
├── created_at / updated_at
└── status (enum: published/pending/rejected)

BRAND
├── id, name, country_of_origin
├── founding_year (nullable)
├── description (text, optionnel)
├── website, social_handles
└── type (enum: artisanal/industrial/international)

PEPPER_TYPE
├── id, name_fr, name_en, name_es
├── shu_range (int[2])
├── origin_region
└── family (enum: capsicum_annuum/chinense/frutescens/...)

FLAVOR_TAG (liste fermée, ~20 valeurs)
├── fumé, fruité, acidulé, terreux, floral, sucré,
    fermenté, herbacé, umami, aillé, citronné...

USER_COLLECTION
├── user_id, sauce_id
├── status (enum: tasted/wishlist/collection)
├── rating (int, 1-5, nullable)
├── notes (text, nullable)
└── added_at
```

### Points techniques critiques

**1. Gestion du Scoville**
La valeur SHU est rarement officielle pour les sauces artisanales. Il faut distinguer `shu_certified` (valeur de laboratoire), `shu_estimated` (calculé depuis les piments déclarés) et `shu_community` (consensus utilisateurs). Les trois coexistent dans le modèle.

**2. Multilinguisme**
La base doit supporter FR / EN / ES minimum dès la conception. Les champs narratifs (story, description) doivent avoir une structure i18n native, pas une table de traduction ajoutée après coup.

**3. Code-barres et reconnaissance**
Un produit peut avoir plusieurs codes-barres (formats différents selon pays). La table `barcodes` est une relation 1:N sur SAUCE. La reconnaissance par image (OCR de l'étiquette) est une couche séparée, non stockée en base — elle s'appuie sur l'API de matching.

**4. Scalabilité de la contribution communautaire**
Toute contribution utilisateur arrive en statut `pending`. Un workflow de validation est nécessaire (auto-validation sur critères simples + modération humaine pour les fiches Gold). Prévoir un champ `contributor_id` et `validated_by`.

---

## PRISME 4 — Développeur Front-end

### Ce que la base de données implique pour l'interface

**Performance d'abord.** Une base mondiale signifie potentiellement des milliers de fiches. Les listes et l'exploration doivent fonctionner en **pagination cursor-based** (pas offset), avec lazy loading des images. Sur mobile, chaque milliseconde de chargement compte.

### Contraintes front induites par les choix de données

**Recherche et filtres :**
Le moteur de recherche doit fonctionner offline pour les sauces déjà consultées (cache local). La recherche doit être tolérante aux fautes (fuzzy matching) — un utilisateur qui tape "tabasco" sans majuscule, "Really Buokas" avec une faute, ou "aji chombo" doit trouver le bon résultat.

**Affichage du niveau de chaleur :**
Le `heat_level_display` (1-10) est la valeur front. Elle doit être calculée côté back et exposée directement — le front ne recalcule jamais depuis SHU brut.

**Images :**
Deux formats requis par la base : `image_bottle` (fond blanc, ratio 2:3) et `image_context` (libre, ratio 16:9 ou carré). Le front doit gérer les fallbacks proprement : si `image_context` est absent, on affiche `image_bottle` avec un fond généré depuis la couleur dominante de la sauce (feature atmosphérique définie dans la spec UX).

**Contribution communautaire depuis le front :**
Le formulaire d'ajout doit guider l'utilisateur via un wizard en étapes (pas un formulaire unique), avec suggestions intelligentes pour les champs normalisés (type de piment, tags aromatiques). L'objectif est d'obtenir la meilleure donnée possible sans décourager la contribution.

**États de la fiche :**
Le front doit afficher clairement le niveau de complétude (Bronze/Silver/Gold) et l'inciter à compléter via la contribution communautaire quand une fiche est incomplète.

---

## PRISME 5 — Creative Manager

### La base de données comme matière éditoriale

Pour SCOVL, la base de données n'est pas un catalogue froid. Chaque sauce est un **sujet éditorial**. Le Creative Manager doit définir comment les données sont racontées, pas seulement stockées.

### Hiérarchie narrative par type de données

**Le piment d'origine** est le héros de chaque fiche. Avant la marque, avant le prix, avant le niveau de chaleur : quel piment, d'où vient-il, quelle est sa personnalité. C'est le fil conducteur éditorial qui différencie SCOVL de tout catalogue générique.

**Le storytelling de marque** doit suivre une structure éditoriale cohérente :
- Origine géographique et culturelle
- Intention du créateur (artisan vs industriel)
- Ce qui rend cette sauce unique dans son contexte
- Suggestion d'usage ou d'accord (comme Vivino avec les accords mets-vins)

**Les tags aromatiques** doivent avoir une écriture maison. Pas "fruité" en texte générique, mais une formulation qui incarne le ton de SCOVL : précis, chaleureux, sobre. Ex : "fruité tropical · notes de mangue" plutôt qu'un simple tag "fruité".

### Observations visuelles depuis les photos

Les photos révèlent des données créatives précieuses pour la base :

- **Really Buokas** : identité afro-antillaise forte, mascotte, palette vert/rouge/jaune — matière pour un récit culturel riche
- **Amazon Pepper** : storytelling déjà présent sur l'étiquette (légende amazoniènne de la guacamaya) — à capturer intégralement dans la fiche Gold
- **Ajichombo/Doraz** : design dark premium sur fond noir avec habanero en sunburst — positionnement visuel distinctif dans son segment
- **Mamita** : positionnement santé (curcuma, clean label) — angle éditorial nutrition/bien-être
- **Picantos Colombia** : Naga Jolokia (Ghost Pepper), packaging crème minimaliste — sauce extrême avec identité sobre, tension créative intéressante

Ces observations doivent **alimenter la base de données** sous forme de notes éditoriales, pas seulement de tags techniques.

### Recommandation créative

Créer un champ `editorial_angle` (text, usage interne SCOVL uniquement) pour que l'équipe éditoriale puisse noter l'angle narratif à développer pour chaque fiche. Ce champ n'est jamais exposé en front — il sert de brief interne.

---

## PRISME 6 — Remise en question stratégique

### Question 1 : La base mondiale dès le lancement est-elle réaliste ?

**Verdict : ambitieux mais piégeux si mal exécuté.**

Une base mondiale avec des fiches incomplètes est pire qu'une base régionale avec des fiches Gold. L'utilisateur qui scanne une sauce et tombe sur une fiche vide perd confiance immédiatement — et ne revient pas.

**Recommandation :** annoncer une base mondiale mais **prioriser l'exécution** sur 4 à 6 marchés clés au lancement : USA, Mexique, Colombie, Panama, France, Espagne. Ce sont les marchés avec le plus grand nombre de références documentables, le plus fort engagement hot sauce, et la plus grande probabilité d'early adopters SCOVL. La base mondiale devient une promesse de roadmap, pas un état au jour 1.

### Question 2 : Le modèle hybride éditorial + communauté tient-il sans modération active ?

**Verdict : non, sans infrastructure de validation, la communauté dégrade la base.**

Vivino a résolu ce problème avec un volume suffisant de contributions croisées (consensus). SCOVL au lancement n'a pas ce volume. Il faut donc un **seuil minimum de contributions avant publication** d'une fiche communautaire (ex : 3 utilisateurs différents confirment les mêmes données), et une modération manuelle légère sur les données sensibles (Scoville notamment).

### Question 3 : La différenciation face à Sauced et aux bases existantes est-elle assurée ?

**Verdict : oui, mais à une condition.**

Les bases existantes (Sauced, Hot Ones, Reddit r/hotsauce) ont de la largeur mais peu de profondeur éditoriale. SCOVL doit être **l'encyclopédie culturelle** des hot sauces, pas un simple catalogue. La différenciation réelle se joue sur :
- La qualité du storytelling (champ `story`, éditorialisé)
- La précision du profil aromatique (taxonomy fermée, cohérente)
- La mise en valeur des sauces artisanales et régionales (angle que ni Tabasco ni Sauced n'occupent sérieusement)

**Ce que personne ne fait bien encore :** valoriser les sauces d'Amérique Centrale et du Sud, d'Afrique, et d'Asie du Sud-Est avec le même sérieux que les références nord-américaines et mexicaines. SCOVL peut prendre ce territoire éditorial.

### Question 4 : Les données nutritionnelles et ingrédients valent-elles l'effort ?

**Verdict : oui pour les fiches Gold, conditionnel pour Bronze/Silver.**

Les valeurs nutritionnelles sont rarement disponibles pour les sauces artisanales. Les forcer en champ obligatoire bloque les contributions. En revanche, elles sont un **differenciateur premium** pour les fiches éditoriales (ex : sauces sans sucre ajouté, sans conservateurs — angle Mamita Curcuma observé dans les photos). Rendre ce champ optionnel mais valoriser visuellement les fiches qui l'ont.

---

## Synthèse et prochaines décisions

| Décision | Recommandation | Urgence |
|----------|---------------|---------|
| Périmètre lancement | 4-6 marchés prioritaires, base mondiale en roadmap | Avant développement |
| Nombre fiches Gold au lancement | 150 minimum | Avant lancement |
| Taxonomie aromatique | Liste fermée de 20 tags, définie maintenant | Avant modélisation BDD |
| Politique Scoville | 3 types de valeur distincts (certifié/estimé/communauté) | Avant modélisation BDD |
| Seuil publication communautaire | Minimum 3 contributions croisées | Avant dev back |
| Champ `editorial_angle` | Créer en usage interne uniquement | Avant premier contenu |
| Multilinguisme | FR/EN/ES natif dès la conception | Avant modélisation BDD |

---

*Document produit pour SCOVL — usage interne — Juin 2026*
