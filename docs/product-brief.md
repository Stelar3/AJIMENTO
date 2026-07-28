# Ajimento — Note de cadrage produit

*Dernière mise à jour : 28 juillet 2026*

> Ce document répond à trois questions simples : c'est quoi, pour qui, et pourquoi maintenant. Il sert de référence quand on doit trancher une question de priorité plus tard.

## En une phrase

Ajimento est une application pour découvrir, noter et cataloguer des sauces piquantes du monde entier — un peu comme Vivino le fait pour le vin, mais pour le piment.

## Le problème

Les gens qui aiment les sauces piquantes n'ont pas d'endroit sérieux pour explorer au-delà des marques qu'ils connaissent déjà, garder une trace de ce qu'ils ont goûté, et découvrir des sauces artisanales moins connues — en particulier celles d'Amérique latine, d'Afrique et d'Asie du Sud-Est, largement absentes des applications existantes.

## Pour qui

Des amateurs de sauces piquantes, du curieux occasionnel au collectionneur qui a une étagère dédiée. Pas besoin de s'y connaître pour commencer.

## Ce qui différencie Ajimento

- **Profondeur éditoriale plutôt que gamification** : pas de classements compétitifs, pas de "qui a la sauce la plus forte" — l'app raconte l'histoire de chaque sauce (origine, producteur, culture).
- **Couverture mondiale sous-représentée ailleurs** : Amérique latine, Afrique, Asie du Sud-Est — le territoire que les concurrents actuels du marché n'occupent pas.
- **Qualité avant quantité** : un catalogue construit par paliers de qualité (voir `architecture.md`), avec un objectif d'environ 150 fiches complètes ("Gold") au lancement plutôt qu'un catalogue massif mais superficiel.

## Fonctionnalités clés (résumé — détail dans `ux-notes.md`)

1. Cataloguer chaque sauce essayée, avec une note sur 4 critères : Chaleur (Heat), Saveur (Flavor), Équilibre (Balance), Finale (Finish)
2. Explorer un catalogue mondial avec une jauge de piquant (échelle de Scoville) animée
3. Garder sa collection personnelle ("la Cave")
4. Scanner une bouteille pour retrouver rapidement une fiche existante

## Contraintes importantes à garder en tête

- **Solo, temps limité** : Brice porte ce projet seul en plus de son activité professionnelle — toute solution doit être simple à maintenir et à faire évoluer sans équipe.
- **Multilingue dès le départ** : français, anglais, espagnol. Ce n'est pas une option à ajouter plus tard — l'architecture doit le prévoir dès la première version (voir `architecture.md`).
- **Modération des photos communautaires** : identifié comme le point le plus délicat à concevoir plus tard, à ne pas sous-estimer quand cette fonctionnalité arrivera.

## Ce que ce document ne couvre pas encore

Certains travaux existent déjà dans d'autres espaces de travail de Brice (spec écran par écran complète, analyse détaillée de la base de données, plan de contenu Instagram) mais n'ont pas encore été rapatriés ici dans le détail. Ce document reprend uniquement la synthèse disponible — à enrichir si besoin.
