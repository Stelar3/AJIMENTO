// ═══════════════════════════════════════════════════════════
// Couche de données Ajimento
// ═══════════════════════════════════════════════════════════
// Essaie de récupérer une vraie sauce depuis Supabase.
// Si la config n'est pas remplie (config.js) ou que la requête
// échoue, renvoie `null` — la page qui appelle cette fonction
// doit alors garder ses données de démonstration.

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
        story, completion_level,
        heat_avg, flavor_avg, balance_avg, finish_avg, score_avg,
        brands ( name ),
        sauce_flavor_tags ( flavor_tags ( label_fr ) )
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
      ratings: {
        heat: data.heat_avg,
        flavor: data.flavor_avg,
        balance: data.balance_avg,
        finish: data.finish_avg,
        score: data.score_avg,
      },
      flavorTags: (data.sauce_flavor_tags || []).map(t => t.flavor_tags?.label_fr).filter(Boolean),
    };
  } catch (err) {
    console.warn("Ajimento: connexion Supabase impossible, retour aux données de démo.", err);
    return null;
  }
}
