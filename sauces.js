// ═══════════════════════════════════════════════════════════
// Couche de données Ajimento
// ═══════════════════════════════════════════════════════════
// Essaie de récupérer une vraie sauce depuis Supabase.
// Si la config n'est pas remplie (config.js) ou que la requête
// échoue, renvoie `null` — la page qui appelle cette fonction
// doit alors garder ses données de démonstration.

// Récupère toutes les sauces publiées, pour l'écran Explorer.
// Renvoie [] (liste vide) si Supabase n'est pas configuré ou en cas d'erreur —
// jamais `null`, pour que la page appelante puisse toujours faire un .map() sans planter.
export async function fetchAllSauces() {
  const cfg = window.AJIMENTO_CONFIG;
  if (!cfg || !cfg.SUPABASE_URL || !cfg.SUPABASE_ANON_KEY) {
    console.log("Ajimento: Supabase non configuré — Explorer restera vide tant que config.js n'est pas rempli.");
    return [];
  }
  try {
    const { createClient } = await import("https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm");
    const supabase = createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);

    const { data, error } = await supabase
      .from("sauces")
      .select(`
        name_full, name_short, origin_country, completion_level,
        shu_certified, shu_estimated, shu_community, heat_level_display,
        score_avg, ingredients_raw,
        brands ( name ),
        sauce_flavor_tags ( flavor_tags ( label_fr ) ),
        sauce_pepper_types ( pepper_types ( name_fr ) )
      `)
      .eq("status", "published")
      .order("created_at", { ascending: false });

    if (error) {
      console.warn("Ajimento: erreur Supabase (liste des sauces).", error.message);
      return [];
    }
    return (data || []).map(row => ({
      nameFull: row.name_full,
      nameShort: row.name_short,
      brandName: row.brands?.name ?? "",
      originCountry: row.origin_country ?? "",
      shu: row.shu_certified ?? row.shu_estimated ?? row.shu_community ?? null,
      heatLevelDisplay: row.heat_level_display,
      scoreAvg: row.score_avg,
      tier: row.completion_level,
      ingredientsRaw: row.ingredients_raw || null,
      flavorTags: (row.sauce_flavor_tags || []).map(t => t.flavor_tags?.label_fr).filter(Boolean),
      peppers: (row.sauce_pepper_types || []).map(p => p.pepper_types?.name_fr).filter(Boolean),
    }));
  } catch (err) {
    console.warn("Ajimento: connexion Supabase impossible (liste des sauces).", err);
    return [];
  }
}

export async function fetchSauceByShortName(nameShort) {
  const cfg = window.AJIMENTO_CONFIG;
  if (!cfg || !cfg.SUPABASE_URL || !cfg.SUPABASE_ANON_KEY) {
    console.log("Ajimento: Supabase non configuré (config.js vide) — utilisation des données de démo.");
    return null;
  }

  try {
    // Chargé uniquement si la config existe, pour ne pas ralentir
    // l'app inutilement tant que Supabase n'est pas branché.
    const { createClient } = await import("https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm");
    const supabase = createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);

    const { data, error } = await supabase
      .from("sauces")
      .select(`
        name_full, name_short, origin_country,
        shu_certified, shu_estimated, shu_community, heat_level_display,
        story, completion_level, image_bottle_url, ingredients_raw,
        heat_avg, flavor_avg, balance_avg, finish_avg, score_avg,
        brands ( name ),
        sauce_flavor_tags ( flavor_tags ( label_fr ) ),
        sauce_pepper_types ( pepper_types ( name_fr ) )
      `)
      .eq("name_short", nameShort)
      .eq("status", "published")
      .maybeSingle();

    if (error) {
      console.warn("Ajimento: erreur Supabase, retour aux données de démo.", error.message);
      return null;
    }
    if (!data) return null;

    // On simplifie la forme des données pour que la page n'ait pas
    // à connaître la structure exacte de la base.
    return {
      nameFull: data.name_full,
      nameShort: data.name_short,
      brandName: data.brands?.name ?? "",
      originCountry: data.origin_country ?? "",
      shu: data.shu_certified ?? data.shu_estimated ?? data.shu_community ?? null,
      shuSource: data.shu_certified ? "certifiée" : data.shu_estimated ? "estimée" : "communauté",
      heatLevelDisplay: data.heat_level_display,
      story: data.story?.fr ?? "",
      tier: data.completion_level,
      imageBottleUrl: data.image_bottle_url || null,
      ingredientsRaw: data.ingredients_raw || null,
      ratings: {
        heat: data.heat_avg,
        flavor: data.flavor_avg,
        balance: data.balance_avg,
        finish: data.finish_avg,
        score: data.score_avg,
      },
      flavorTags: (data.sauce_flavor_tags || []).map(t => t.flavor_tags?.label_fr).filter(Boolean),
      peppers: (data.sauce_pepper_types || []).map(p => p.pepper_types?.name_fr).filter(Boolean),
    };
  } catch (err) {
    console.warn("Ajimento: connexion Supabase impossible, retour aux données de démo.", err);
    return null;
  }
}

// Retrouve une sauce à partir d'un code-barres scanné (EAN13/UPC-A/QR).
// Renvoie le `name_short` de la sauce si trouvée et publiée, sinon `null`
// (que ce soit parce que Supabase n'est pas configuré, que le code n'existe
// pas en base, ou que la sauce liée n'est pas encore publiée).
export async function fetchSauceByBarcode(code) {
  const cfg = window.AJIMENTO_CONFIG;
  if (!cfg || !cfg.SUPABASE_URL || !cfg.SUPABASE_ANON_KEY) {
    console.log("Ajimento: Supabase non configuré — le scanner ne peut pas chercher de code-barres.");
    return null;
  }
  try {
    const { createClient } = await import("https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm");
    const supabase = createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);

    const { data, error } = await supabase
      .from("barcodes")
      .select(`
        code,
        sauces ( name_short, status )
      `)
      .eq("code", code)
      .maybeSingle();

    if (error) {
      console.warn("Ajimento: erreur Supabase (recherche code-barres).", error.message);
      return null;
    }
    if (!data || !data.sauces || data.sauces.status !== "published") return null;
    return data.sauces.name_short;
  } catch (err) {
    console.warn("Ajimento: connexion Supabase impossible (recherche code-barres).", err);
    return null;
  }
}

// ═══════════════════════════════════════════════════════════
// Recherche par texte d'étiquette (scanner)
// ═══════════════════════════════════════════════════════════
// Le scanner ne lit pas un code-barres : il photographie l'étiquette,
// en extrait le texte par OCR (côté scanner.html), puis appelle
// matchSaucesByLabelText() ci-dessous pour retrouver les sauces les
// plus proches. Fait côté client (pas de fonction SQL à écrire) —
// suffisant tant que le catalogue reste à quelques centaines de sauces ;
// à revoir (recherche côté base, trigram déjà indexé dans schema.sql)
// si la base grossit beaucoup au-delà.

function normalizeText(s) {
  return (s || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "");
}

function scoreLabelMatch(ocrTextNormalized, sauce) {
  const candidate = normalizeText(`${sauce.brandName} ${sauce.nameFull} ${sauce.nameShort}`);
  const words = candidate.split(/[^a-z0-9]+/).filter((w) => w.length >= 3);
  let score = 0;
  for (const w of words) {
    if (ocrTextNormalized.includes(w)) score += w.length;
  }
  if (sauce.nameShort && ocrTextNormalized.includes(normalizeText(sauce.nameShort))) score += 25;
  if (sauce.brandName && ocrTextNormalized.includes(normalizeText(sauce.brandName))) score += 20;
  return score;
}

// Renvoie jusqu'à 5 sauces les plus proches du texte lu sur l'étiquette,
// triées par pertinence décroissante. Renvoie [] si rien de probant.
export async function matchSaucesByLabelText(ocrText) {
  const all = await fetchAllSauces();
  const norm = normalizeText(ocrText);
  if (!norm.trim()) return [];
  return all
    .map((sauce) => ({ sauce, score: scoreLabelMatch(norm, sauce) }))
    .filter((x) => x.score > 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, 5)
    .map((x) => x.sauce);
}
