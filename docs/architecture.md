# Ajimento — Note d'architecture (langage simple)

*Dernière mise à jour : 28 juillet 2026*

> Ce document explique les choix techniques et pourquoi, en évitant le jargon quand possible. Chaque terme technique est expliqué à sa première apparition.

## Le choix technique : une PWA

**PWA = Progressive Web App**, autrement dit un site web construit pour se comporter comme une application. Concrètement, ça veut dire :

- Ajimento sera d'abord un **site web** (une adresse comme `ajimento.app`)
- Depuis un téléphone, on peut l'**ajouter à l'écran d'accueil** : elle apparaît alors comme une app normale, avec une icône, en plein écran, sans la barre d'adresse du navigateur
- Pas besoin d'App Store ni de Google Play pour la tester ou l'utiliser au début

### Pourquoi ce choix

- **C'est le plus simple à tester** : dès qu'une première version existe, il suffit d'ouvrir un lien sur ton téléphone pour la voir tourner — pas d'installation compliquée, pas d'outil supplémentaire à apprendre
- **Un seul code pour tout le monde** : la même version fonctionne sur iPhone, Android, et ordinateur
- **Ça n'empêche rien pour plus tard** : si un jour tu veux une vraie fiche App Store / Google Play, il existe des outils qui transforment une PWA en app "officielle" sans tout refaire — ce sera une étape à part, pas un mur

### Ce que ça veut dire pour le "télécharger sur mon téléphone"

Dès qu'une première version très simple existera (un écran d'accueil, par exemple), tu pourras :
1. Ouvrir un lien sur ton téléphone
2. Appuyer sur "Ajouter à l'écran d'accueil" (Safari sur iPhone, Chrome sur Android)
3. Elle apparaît comme une app, avec son icône

Pas de compte développeur à payer, pas d'attente de validation Apple/Google pour tester.

## L'identité visuelle réelle : sombre et atmosphérique

Le tout premier écran construit utilisait un fond clair (crème) par erreur, faute d'avoir le détail complet de la charte sous la main. La vraie charte, retrouvée dans le kit de contenu Instagram (`content/instagram-templates.jsx`), est **sombre et atmosphérique** : fond quasi noir (`#0A0909`), dégradés radiaux colorés, ingrédients qui flottent doucement en arrière-plan, trois polices (Cormorant Garamond pour les titres, DM Mono pour les données, Outfit pour le texte courant), et une palette élargie (Rouge `#C0392B`, Feu `#D4603A`, Or `#B8963E`). Les écrans ont été reconstruits sur cette base — voir `index.html` et `fiche-produit.html`.

## La base de données

Analyse complète disponible dans `docs/SCOVL_analyse_multiprismes_BDD.md` (le document de référence original). Résumé de ce qui structure le schéma (`database/schema.sql`) :

- **Trois paliers de qualité pour chaque fiche sauce** : Bronze (basique), Silver (intermédiaire), Gold (complet et vérifié). Objectif : environ 150 fiches Gold au lancement plutôt qu'un catalogue immense mais pauvre en contenu.
- **Une vingtaine de tags de saveur** (une liste fermée, pas un champ libre, pour garder le catalogue cohérent) — déjà créés dans le schéma.
- **Trois façons de connaître le niveau de piquant (Scoville)** d'une sauce : valeur certifiée en laboratoire, valeur estimée, valeur donnée par la communauté — chacune affichée différemment pour ne pas induire en erreur. L'app n'affiche jamais que la valeur déjà calculée sur 10 (`heat_level_display`).
- **Multilingue dès le départ** : français, anglais, espagnol, natif dans la structure (champ `story` en JSON par langue).

**Hébergement choisi : Supabase** (gratuit pour démarrer, base de données + comptes utilisateurs inclus). Détail de la mise en place dans `docs/database.md`.

## Ce qu'il reste à décider

- Brancher l'app sur la vraie base de données Supabase (actuellement, la fiche produit affiche des données de démonstration codées en dur)
- Le détail technique du scan de bouteille (fonctionnalité plus avancée, pas nécessaire pour une toute première version)
