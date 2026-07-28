# Ajimento — Base de données (langage simple)

*Dernière mise à jour : 28 juillet 2026*

> Ce document explique la base de données en évitant le jargon. Le détail technique complet est dans `database/schema.sql` et dans `SCOVL_analyse_multiprismes_BDD.md` (l'analyse d'origine, à conserver dans `docs/` comme référence).

## Ce que contient la base, en résumé

- **`sauces`** : la table centrale, une ligne par sauce. Contient le nom, la marque, le piquant (trois valeurs différentes — voir plus bas), l'histoire racontée, et un niveau de qualité (Bronze/Silver/Gold).
- **`brands`** : les marques de sauces.
- **`pepper_types`** : les variétés de piments (habanero, jalapeño, etc.), en trois langues.
- **`flavor_tags`** : une liste fermée d'environ 20 goûts possibles (fumé, fruité, acidulé...) — fermée volontairement, pour que le filtrage dans l'app reste cohérent, plutôt que du texte libre où chacun écrirait différemment.
- **`user_collection`** : la "Cave" de chaque utilisateur — quelles sauces il a goûtées, veut goûter, ou collectionne, avec sa note.
- **`barcodes`** : les codes-barres, pour que le scan fonctionne (une sauce peut en avoir plusieurs, selon le pays).

## Pourquoi trois valeurs de piquant, pas une seule

`shu_certified` (mesuré en laboratoire), `shu_estimated` (calculé), `shu_community` (donné par les utilisateurs). La plupart des sauces artisanales n'ont pas de valeur officielle — avoir les trois évite de faire semblant qu'un chiffre approximatif est une vérité scientifique.

L'app, elle, n'affiche jamais ces chiffres bruts directement : elle utilise `heat_level_display`, une note de 1 à 10 déjà calculée, plus lisible pour quelqu'un qui n'a jamais entendu parler de l'échelle de Scoville.

## Pourquoi Bronze / Silver / Gold

Plutôt que d'exiger toutes les informations dès qu'une sauce est ajoutée (ce qui découragerait les contributions), trois paliers progressifs :

| Niveau | Contenu minimum |
|---|---|
| Bronze | Nom, marque, pays, photo, code-barres |
| Silver | + piquant estimé, ingrédients, type de piment |
| Gold | + histoire racontée, profil aromatique complet |

Objectif rappelé dans l'analyse d'origine : 150 fiches Gold minimum au lancement, plutôt qu'un grand nombre de fiches vides.

## Mettre en place la vraie base (Supabase)

Supabase a été recommandé parce qu'il est gratuit pour démarrer, inclut la base de données ET la gestion des comptes utilisateurs (pas besoin de coder ça séparément), et reste simple à prendre en main.

**Étapes** :

1. Va sur [supabase.com](https://supabase.com), crée un compte (avec ton compte GitHub, c'est le plus rapide)
2. Clique **New Project**, choisis un nom (ex: `ajimento`) et un mot de passe pour la base (garde-le précieusement, ce n'est pas ton mot de passe de compte)
3. Une fois le projet créé, va dans le menu **SQL Editor** (icône à gauche)
4. Ouvre le fichier `database/schema.sql` de ce projet, copie tout son contenu, colle-le dans l'éditeur SQL de Supabase
5. Clique **Run** — toutes les tables sont créées d'un coup
6. Dans **Project Settings → API**, tu trouveras une **URL** et une **clé publique (anon key)** — c'est ce qui permettra plus tard à l'app de se connecter à cette base. Garde cette page ouverte ou note ces deux valeurs, on en aura besoin pour la prochaine étape (brancher l'app dessus).

## Ce qui reste à faire ensuite

- Brancher l'app (les écrans qu'on construit) sur cette base, pour remplacer les données de démonstration par de vraies données
- Commencer à peupler la base avec les premières sauces (les photos du rayon Panama analysées dans le document d'origine sont un bon point de départ concret)
- Mettre en place le système de modération des contributions communautaires (mentionné comme risque UX prioritaire dans l'analyse)
