// ═══════════════════════════════════════════════════════════
// Détection d'ingrédients à partir du texte brut (ingredients_raw)
// ═══════════════════════════════════════════════════════════
// Utilisé par la fiche produit (fond décoratif) et par l'Explorer
// (filtre "Ingrédient" + petits repères visuels sur les cartes).
// Un seul et même dictionnaire pour les deux pages, pour rester cohérent.

// Forme SVG interne (sans couleur, injectée à l'affichage via {c}) de
// chaque ingrédient reconnu. "piment" sert aussi de repli générique.
export const ING_ICONS = {
  piment: '<path d="M32 6C40 20 50 30 50 42C50 52 42 58 32 58C22 58 14 52 14 42C14 30 24 20 32 6Z" fill="{c}"/>',
  ail: '<path d="M32 8c10 0 16 9 16 19 0 13-7 21-16 21s-16-8-16-21c0-10 6-19 16-19Z" fill="{c}"/><path d="M30 6c1-2 3-2 4 0 1 2 0 4-2 5-2-1-3-3-2-5Z" fill="{c}"/>',
  tomate: '<circle cx="32" cy="38" r="18" fill="{c}"/><path d="M32 12l2.5 5 5.5.8-4 4 1 5.5-5-2.8-5 2.8 1-5.5-4-4 5.5-.8z" fill="{c}"/>',
  oignon: '<path d="M32 14c10 2 16 12 16 22 0 11-7 18-16 18s-16-7-16-18c0-10 6-20 16-22Z" fill="{c}"/><path d="M32 14c-1-4 0-8 3-10 2 3 1 7-3 10Z" fill="{c}"/>',
  citron: '<ellipse cx="32" cy="34" rx="22" ry="16" fill="{c}"/><path d="M10 34c-3-1-5-3-4-5 1 2 3 3 4 5ZM54 34c3-1 5-3 4-5-1 2-3 3-4 5Z" fill="{c}"/>',
  carotte: '<path d="M26 10 L38 10 L34 52 Q32 58 30 52 Z" fill="{c}"/><path d="M28 10c-2-5-6-8-10-8 2 4 6 7 10 8ZM36 10c2-5 6-8 10-8-2 4-6 7-10 8Z" fill="{c}" opacity=".8"/>',
  curcuma: '<path d="M20 30c-4-6 0-14 8-14 4 0 6 3 9 2 6-2 12 2 12 9 0 5-4 7-3 12 1 6-3 11-9 11-4 0-6-3-10-2-6 2-11-2-11-8 0-4 3-6 4-10Z" fill="{c}"/>',
  mangue: '<path d="M20 42c-3-15 6-30 20-30 13 0 21 11 19 25-2 15-13 25-20 25s-16-6-19-20Z" fill="{c}"/>',
  moutarde: '<circle cx="23" cy="28" r="5" fill="{c}"/><circle cx="37" cy="24" r="5" fill="{c}"/><circle cx="29" cy="40" r="5" fill="{c}"/><circle cx="43" cy="38" r="5" fill="{c}"/>',
  miel: '<path d="M32 8 L50 20 L50 44 L32 56 L14 44 L14 20 Z" fill="{c}"/>',
};

// Ordre de priorité de détection + mots-clés associés (texte déjà
// normalisé : minuscules, sans accents).
export const ING_KEYWORDS = [
  ['piment', ['piment', 'habanero', 'chombo', 'cayenne', 'arbol', 'puya', 'jolokia', 'tabasco', 'jalapeno', 'serrano', 'scotch bonnet', 'chili', 'chile', 'ghost pepper', 'fantome', 'reaper', 'scorpion']],
  ['tomate', ['tomate']],
  ['ail', ['ail']],
  ['oignon', ['oignon']],
  ['citron', ['citron', 'lime']],
  ['carotte', ['carotte']],
  ['curcuma', ['curcuma', 'gingembre']],
  ['mangue', ['mangue', 'mango']],
  ['moutarde', ['moutarde', 'mustard']],
  ['miel', ['miel', 'honey']],
];
const FALLBACK_ORDER = ['piment', 'tomate', 'ail'];

export function stripAccents(s) {
  return s.normalize('NFD').replace(/[̀-ͯ]/g, '');
}

// Renvoie TOUS les ingrédients reconnus dans le texte brut, sans
// complément ni troncature — utile pour filtrer/étiqueter avec
// exactitude (contrairement à pickIngredients, qui complète toujours
// jusqu'à 3 pour les besoins d'un fond décoratif).
export function matchedIngredientKeys(rawText) {
  if (!rawText) return [];
  const norm = stripAccents(rawText.toLowerCase());
  const found = [];
  for (const [key, keywords] of ING_KEYWORDS) {
    if (keywords.some(k => norm.includes(k))) found.push(key);
  }
  return found;
}

// Repère jusqu'à `max` ingrédients présents dans le texte brut ; par
// défaut, complète avec un repli générique si la liste est absente ou
// trop courte, pour qu'un fond décoratif garde toujours `max` formes.
// Passer { pad: false } pour n'obtenir que les ingrédients réellement
// détectés (sans complément).
export function pickIngredients(rawText, { pad = true, max = 3 } = {}) {
  const found = matchedIngredientKeys(rawText).slice(0, max);
  if (pad) {
    for (const key of FALLBACK_ORDER) {
      if (found.length >= max) break;
      if (!found.includes(key)) found.push(key);
    }
  }
  return found.slice(0, max);
}
