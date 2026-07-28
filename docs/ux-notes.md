# Ajimento — Notes UX (synthèse)

*Dernière mise à jour : 28 juillet 2026*

> Ce document résume les écrans déjà pensés pour l'app. C'est une synthèse — la version détaillée écran par écran existe ailleurs dans les espaces de travail de Brice et pourra être rapatriée ici au besoin.

## Identité visuelle (déjà validée)

- **Polices** : Cormorant Garamond (titres) + DM Mono (texte technique/données)
- **Couleur principale** : rouge brique `#C0392B`
- **Ton de voix** : précis, chaleureux, sobre
- **Personnalité de marque** : le Sage + l'Explorateur — quelqu'un qui connaît le sujet en profondeur et qui a envie de partager la découverte, sans être élitiste
- **Promesse de marque** : *"Every drop has a story"*
- **Style d'icônes** : flat design ; illustrations de bouteilles en SVG comme visuels héros

## Écrans prévus

| Écran | Rôle |
|---|---|
| Splash | Premier écran au lancement de l'app |
| Onboarding | Présentation rapide du concept à un nouvel utilisateur |
| Home | Écran d'accueil |
| Scanner | Scanner une bouteille pour retrouver sa fiche |
| Fiche produit | Détail d'une sauce : jauge de piquant animée (échelle de Scoville) + notation sur 4 critères (Chaleur / Saveur / Équilibre / Finale) |
| Explorer | Parcourir le catalogue mondial |
| La Cave | Collection personnelle de l'utilisateur |
| Profil | Informations et réglages du compte |

Deux versions de maquettes existent déjà (React, donc rejouables dans un navigateur) : une v1 fonctionnelle simple, une v2 plus riche visuellement avec un univers graphique dérivé des ingrédients.

## Ce qu'il reste à faire ici

- Rapatrier le détail écran par écran si besoin (contenu déjà produit ailleurs)
- Adapter les deux maquettes React existantes au nouveau nom **Ajimento** (elles référencent probablement encore "SCOVL")
- Vérifier que les maquettes sont compatibles avec le choix technique PWA (voir `architecture.md`) — en principe oui, puisque ce sont déjà des composants React
