// ═══════════════════════════════════════════════════════════
// Comptes Ajimento — authentification (Supabase Auth, lien magique),
// préférences de goût, statistiques de dégustation et trophées.
// ═══════════════════════════════════════════════════════════
// Utilisé par profil.html, et par fiche-produit.html pour les CTA
// "Ajouter à ma Cave" / "Noter cette sauce".

let _client = null;
async function getClient() {
  const cfg = window.AJIMENTO_CONFIG;
  if (!cfg || !cfg.SUPABASE_URL || !cfg.SUPABASE_ANON_KEY) return null;
  if (_client) return _client;
  const { createClient } = await import("https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm");
  _client = createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);
  return _client;
}

// ---------------------------------------------------------
// Authentification — lien magique (pas de mot de passe à gérer)
// ---------------------------------------------------------

export async function sendMagicLink(email) {
  const supabase = await getClient();
  if (!supabase) return { error: "Supabase non configuré." };
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: { emailRedirectTo: location.origin + location.pathname },
  });
  return { error: error ? error.message : null };
}

export async function signOut() {
  const supabase = await getClient();
  if (!supabase) return;
  await supabase.auth.signOut();
}

// Renvoie l'utilisateur connecté (objet {id, email}) ou null.
export async function getCurrentUser() {
  const supabase = await getClient();
  if (!supabase) return null;
  const { data } = await supabase.auth.getSession();
  return data.session?.user ?? null;
}

// Prévient l'appelant à chaque changement de session (connexion,
// déconnexion, lien magique cliqué) — pratique pour re-render une page.
export async function onAuthChange(callback) {
  const supabase = await getClient();
  if (!supabase) return;
  supabase.auth.onAuthStateChange((_event, session) => callback(session?.user ?? null));
}

// ---------------------------------------------------------
// Préférences de goût (table user_preferences)
// ---------------------------------------------------------

export const FLAVOR_TAGS = [
  ['fume', 'Fumé'], ['fruite', 'Fruité'], ['acidule', 'Acidulé'], ['terreux', 'Terreux'],
  ['floral', 'Floral'], ['sucre', 'Sucré'], ['fermente', 'Fermenté'], ['herbace', 'Herbacé'],
  ['umami', 'Umami'], ['aille', 'Aillé'], ['citronne', 'Citronné'], ['vinaigre', 'Vinaigré'],
  ['epice', 'Épicé'], ['tropical', 'Tropical'], ['noix', 'Noisette'], ['caramel', 'Caramélisé'],
  ['mineral', 'Minéral'], ['boise', 'Boisé'], ['poivre', 'Poivré'], ['salin', 'Salin'],
];

export async function fetchPreferences(userId) {
  const supabase = await getClient();
  if (!supabase) return null;
  const { data, error } = await supabase
    .from('user_preferences')
    .select('display_name, heat_tolerance, favorite_flavor_tags')
    .eq('user_id', userId)
    .maybeSingle();
  if (error) { console.warn('Ajimento: erreur lecture préférences.', error.message); return null; }
  return data;
}

export async function savePreferences(userId, { displayName, heatTolerance, favoriteFlavorTags }) {
  const supabase = await getClient();
  if (!supabase) return { error: 'Supabase non configuré.' };
  const { error } = await supabase.from('user_preferences').upsert({
    user_id: userId,
    display_name: displayName,
    heat_tolerance: heatTolerance,
    favorite_flavor_tags: favoriteFlavorTags,
    updated_at: new Date().toISOString(),
  });
  return { error: error ? error.message : null };
}

// ---------------------------------------------------------
// Cave — ajouter/noter une sauce (table user_collection)
// ---------------------------------------------------------

// status: 'tasted' | 'wishlist' | 'collection'. Les notes sont optionnelles
// (1 à 5) — on peut ajouter une sauce sans encore la noter.
export async function upsertCollectionEntry(userId, sauceId, { status, rating, heatRating, flavorRating, balanceRating, finishRating, notes } = {}) {
  const supabase = await getClient();
  if (!supabase) return { error: 'Supabase non configuré.' };
  const payload = { user_id: userId, sauce_id: sauceId };
  if (status !== undefined) payload.status = status;
  if (rating !== undefined) payload.rating = rating;
  if (heatRating !== undefined) payload.heat_rating = heatRating;
  if (flavorRating !== undefined) payload.flavor_rating = flavorRating;
  if (balanceRating !== undefined) payload.balance_rating = balanceRating;
  if (finishRating !== undefined) payload.finish_rating = finishRating;
  if (notes !== undefined) payload.notes = notes;
  const { error } = await supabase.from('user_collection').upsert(payload, { onConflict: 'user_id,sauce_id' });
  return { error: error ? error.message : null };
}

// ---------------------------------------------------------
// Statistiques de dégustation (pour le tableau de bord + trophées)
// ---------------------------------------------------------

export async function fetchUserStats(userId) {
  const supabase = await getClient();
  const empty = { tastedCount: 0, countriesCount: 0, brandsCount: 0, maxShu: null, ratingsCount: 0 };
  if (!supabase) return empty;

  const { data, error } = await supabase
    .from('user_collection')
    .select(`
      status, rating,
      sauces ( origin_country, shu_certified, shu_estimated, shu_community, brands ( name ) )
    `)
    .eq('user_id', userId);

  if (error) { console.warn('Ajimento: erreur lecture statistiques.', error.message); return empty; }
  const rows = data || [];
  const tasted = rows.filter(r => r.status === 'tasted');
  const countries = new Set(tasted.map(r => r.sauces?.origin_country).filter(Boolean));
  const brands = new Set(tasted.map(r => r.sauces?.brands?.name).filter(Boolean));
  const shus = tasted.map(r => r.sauces?.shu_certified ?? r.sauces?.shu_estimated ?? r.sauces?.shu_community).filter(v => v != null);
  const ratingsCount = rows.filter(r => r.rating != null).length;

  return {
    tastedCount: tasted.length,
    countriesCount: countries.size,
    brandsCount: brands.size,
    maxShu: shus.length ? Math.max(...shus) : null,
    ratingsCount,
  };
}

// ---------------------------------------------------------
// Trophées — calculés côté client à partir des statistiques,
// pas stockés en base : ça évite une table de plus et ça reste
// facile à ajuster (nouveaux paliers, nouveaux trophées) sans migration.
// ---------------------------------------------------------

export const TROPHIES = [
  { id: 'premier-pas', title: 'Premier pas', desc: '1 sauce goûtée', check: s => s.tastedCount >= 1 },
  { id: 'curieux', title: 'Curieux', desc: '5 sauces goûtées', check: s => s.tastedCount >= 5 },
  { id: 'explorateur', title: 'Explorateur', desc: '15 sauces goûtées', check: s => s.tastedCount >= 15 },
  { id: 'collectionneur', title: 'Collectionneur', desc: '30 sauces goûtées', check: s => s.tastedCount >= 30 },
  { id: 'tour-du-monde', title: 'Tour du monde', desc: '5 pays différents', check: s => s.countriesCount >= 5 },
  { id: 'grand-tour', title: 'Grand tour', desc: '10 pays différents', check: s => s.countriesCount >= 10 },
  { id: 'tete-brulee', title: 'Tête brûlée', desc: 'Une sauce ≥ 500k SHU', check: s => (s.maxShu ?? 0) >= 500000 },
  { id: 'sang-froid', title: 'Sang-froid extrême', desc: 'Une sauce ≥ 1M SHU', check: s => (s.maxShu ?? 0) >= 1000000 },
  { id: 'critique', title: 'Critique', desc: '5 notes laissées', check: s => s.ratingsCount >= 5 },
  { id: 'fin-palais', title: 'Fin palais', desc: '15 notes laissées', check: s => s.ratingsCount >= 15 },
];

export function computeTrophies(stats) {
  return TROPHIES.map(t => ({ ...t, unlocked: t.check(stats) }));
}
