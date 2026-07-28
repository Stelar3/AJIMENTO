import { useState } from "react";

// ═══════════════════════════════════════
// DESIGN TOKENS
// ═══════════════════════════════════════
const C = {
  red: "#C0392B", fire: "#D4603A", gold: "#B8963E",
  bg: "#0A0909", card: "#141212", card2: "#1C1919",
  border: "#2A2424", text: "#F2EDE8", muted: "#7A6F6A", dim: "#2E2828",
};

const GGRADIENT = "linear-gradient(90deg,#F5D76E 0%,#E8A838 25%,#D4603A 55%,#C0392B 78%,#7B1A1A 100%)";

const CSS = `
  @import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400;1,600&family=DM+Mono:wght@300;400;500&family=Outfit:wght@300;400;500;600;700&display=swap');
  *{box-sizing:border-box;margin:0;padding:0;}
  body{background:#060404;}
  .sc{font-family:'Outfit',sans-serif;color:#F2EDE8;}
  .serif{font-family:'Cormorant Garamond',serif;}
  .mono{font-family:'DM Mono',monospace;}
  @keyframes ingredientDrift{0%,100%{transform:translate(0,0) rotate(var(--r))}50%{transform:translate(3px,-5px) rotate(calc(var(--r) + 4deg))}}
  @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
  @keyframes fillBar{from{width:0}to{width:var(--w)}}
  @keyframes gaugeFill{from{width:0%}to{width:var(--pct)}}
  @keyframes scaleIn{from{opacity:0;transform:scale(.96)}to{opacity:1;transform:scale(1)}}
  .fade-in{animation:fadeIn .5s ease forwards;}
  .scale-in{animation:scaleIn .4s ease forwards;}
  .ingredient{animation:ingredientDrift 7s ease-in-out infinite;}
  .gauge-fill{animation:gaugeFill 1.2s cubic-bezier(.34,1.2,.64,1) forwards;}
`;

// ═══════════════════════════════════════
// DATA
// ═══════════════════════════════════════
const DROP_EXAMPLES = [
  {
    id: 1,
    name: "Habanero Rojo",
    brand: "El Yucateco",
    country: "Mexique", flag: "🇲🇽",
    shu: 11400, level: "Relevé", levelIdx: 1,
    score: 4.2, notesCount: 127,
    heat: 4.3, flavor: 3.8, balance: 4.1, finish: 3.5,
    peppers: ["Habanero", "Ail", "Tomate"],
    aromas: ["Fruité", "Fumé", "Vinégré"],
    caption: `El Yucateco. Habanero Rojo.\nMexique. Depuis 1968.\n\n11 400 SHU. Niveau Relevé.\n\nArômes : Fruité · Fumé · Vinégré.\nAccords : Tacos · Viandes grillées · Œufs.\n\nL'une des sauces les plus vendues au monde.\nEt pourtant, la plupart de ceux qui l'utilisent\ntous les jours ne savent pas vraiment\nce qu'ils ont dans les mains.\n\nSCOVL raconte cette histoire.\n\n#ElYucateco #Habanero #SCOVL #HotSauce`,
    theme: { bg1: "#3D0800", bg2: "#1A0400", accent: "#E8521A", bottleColor: "#8B0000", labelColor: "#FF6B35" },
    ingredients: [
      { emoji: "🌶️", x: 6, y: 8, size: 100, opacity: 0.18, rotate: -25 },
      { emoji: "🧄", x: 74, y: 6, size: 80, opacity: 0.14, rotate: 12 },
      { emoji: "🍅", x: 72, y: 62, size: 80, opacity: 0.13, rotate: -10 },
      { emoji: "🌶️", x: 5, y: 65, size: 65, opacity: 0.11, rotate: 20 },
    ],
  },
  {
    id: 2,
    name: "Mango Habanero",
    brand: "Truff Reserve",
    country: "Jamaïque", flag: "🇯🇲",
    shu: 125000, level: "Fort", levelIdx: 2,
    score: 4.6, notesCount: 743,
    heat: 3.8, flavor: 4.9, balance: 4.7, finish: 4.2,
    peppers: ["Habanero", "Mangue", "Ananas"],
    aromas: ["Tropical", "Fruité", "Sucré-Piquant"],
    caption: `Truff Reserve. Mango Habanero.\nJamaïque.\n\n125 000 SHU. Niveau Fort.\n\nArômes : Tropical · Fruité · Sucré-Piquant.\nAccords : Poulet grillé · Crevettes · Tacos.\n\nLà où la chaleur et le fruit\napprennent à coexister.\nUne tension parfaite.\n\n#MangoHabanero #SCOVL #HotSauce #Jamaïque`,
    theme: { bg1: "#2D1800", bg2: "#1A0C00", accent: "#F59E0B", bottleColor: "#92400E", labelColor: "#FBBF24" },
    ingredients: [
      { emoji: "🥭", x: 5, y: 5, size: 115, opacity: 0.2, rotate: -15 },
      { emoji: "🍍", x: 68, y: 8, size: 90, opacity: 0.16, rotate: 10 },
      { emoji: "🌶️", x: 74, y: 60, size: 72, opacity: 0.14, rotate: -20 },
      { emoji: "🥭", x: 42, y: 75, size: 55, opacity: 0.1, rotate: 18 },
    ],
  },
  {
    id: 3,
    name: "Ghost Pepper Reserve",
    brand: "Blair's",
    country: "USA", flag: "🇺🇸",
    shu: 850000, level: "Intense", levelIdx: 3,
    score: 4.5, notesCount: 892,
    heat: 4.8, flavor: 4.3, balance: 3.9, finish: 4.7,
    peppers: ["Bhut Jolokia", "Habanero", "Ail noir"],
    aromas: ["Fruité", "Terreux", "Fumé"],
    caption: `Blair's. Ghost Pepper Reserve.\nUSA.\n\n850 000 SHU. Niveau Intense.\n\nArômes : Fruité · Terreux · Fumé.\nAccords : Viandes grillées · Chili · Marinades.\n\nLe Bhut Jolokia.\nTraduction littérale : piment fantôme.\nCe n'est pas une métaphore.\n\n#GhostPepper #BlairsSauce #SCOVL #Intense`,
    theme: { bg1: "#0D0020", bg2: "#050010", accent: "#7B2FBE", bottleColor: "#2D0050", labelColor: "#A855F7" },
    ingredients: [
      { emoji: "👻", x: 5, y: 8, size: 105, opacity: 0.15, rotate: -10 },
      { emoji: "🌶️", x: 68, y: 10, size: 82, opacity: 0.12, rotate: 25 },
      { emoji: "🖤", x: 75, y: 62, size: 60, opacity: 0.18, rotate: 0 },
      { emoji: "🧄", x: 8, y: 60, size: 68, opacity: 0.12, rotate: -20 },
    ],
  },
];

const ORIGINS_EXAMPLES = [
  {
    id: 1,
    category: "PIMENT",
    title: "Le Habanero",
    subtitle: "Amazonie · Caraïbes · Monde entier",
    data: [
      { label: "Origine", value: "Bassin amazonien" },
      { label: "SHU", value: "100 000 – 350 000" },
      { label: "Niveau", value: "Fort" },
      { label: "Arômes", value: "Fruité · Floral · Citronné" },
      { label: "Usage", value: "Sauces · Cuisines · Marinades" },
    ],
    body: `Domestiqué dans les Caraïbes.\nAujourd'hui présent dans les cuisines\nde 140 pays.\n\nCe qui frappe à première gorge :\nune chaleur franche, rapide.\nCe qui reste : des notes fruitées,\npresque florales.`,
    emoji: "🌶️",
    accent: "#E8521A",
    caption: `Le Habanero.\n\nOriginaire du bassin amazonien, domestiqué dans les Caraïbes, aujourd'hui présent dans les cuisines de 140 pays.\n\nCe qui frappe à première gorge : une chaleur franche, rapide, qui monte sans prévenir.\nCe qui reste : des notes fruitées, presque florales.\nComme si la brûlure avait quelque chose à dire.\n\nSHU : 100 000 – 350 000 unités. Niveau : Fort.\n\n#Habanero #Piment #SCOVL #HotSauce #Origins`,
  },
  {
    id: 2,
    category: "HISTOIRE",
    title: "La Fermentation",
    subtitle: "Un processus vieux de 3 000 ans",
    data: [
      { label: "Méthode", value: "Fermentation lactique" },
      { label: "Ingrédients", value: "Piment · Sel · Temps" },
      { label: "Durée", value: "3 semaines → 3 ans" },
      { label: "Exemples", value: "Tabasco · Gochujang · Valentina" },
      { label: "Résultat", value: "Profondeur · Complexité · Umami" },
    ],
    body: `Avant d'être une sauce,\nc'était du temps.\n\nLe sel. Les piments.\nL'absence d'oxygène.\nEt la patience.\n\nTabasco attend 3 ans\nen fûts de chêne blanc.`,
    emoji: "⏳",
    accent: "#B8963E",
    caption: `Avant d'être une sauce, c'était du temps.\n\nLa fermentation lactique. Un processus vieux de 3 000 ans, utilisé aujourd'hui dans les meilleures hot sauces du monde.\n\nLe sel. Les piments. L'absence d'oxygène. Et la patience.\n\nC'est comme ça que Tabasco attend 3 ans en fûts de chêne blanc. C'est comme ça que le Gochujang coréen prend 6 mois minimum.\n\nLa chaleur ça se fabrique vite. Le caractère, ça se construit lentement.\n\n#Fermentation #HotSauce #SCOVL #FoodScience #Artisan`,
  },
  {
    id: 3,
    category: "GÉOGRAPHIE",
    title: "La Louisiane",
    subtitle: "Le berceau américain de la sauce piquante",
    data: [
      { label: "État", value: "Louisiane, USA" },
      { label: "Sauce emblème", value: "Tabasco · Crystal · Louisiana" },
      { label: "Fondée", value: "Tabasco 1868" },
      { label: "Production", value: "Île Avery · Sel naturel" },
      { label: "Piment clé", value: "Piment Tabasco" },
    ],
    body: `En 1868, Edmund McIlhenny\nemboutille sa première sauce\nsur l'Île Avery, Louisiane.\n\nIl ne savait pas qu'il allait créer\nla sauce piquante la plus vendue\nde l'histoire.\n\n155 ans plus tard.`,
    emoji: "🏛️",
    accent: "#C0392B",
    caption: `La Louisiane et la naissance de la sauce piquante américaine.\n\nEn 1868, Edmund McIlhenny emboutille sa première sauce sur l'Île Avery, Louisiane, avec des piments Tabasco cultivés dans son jardin.\n\nIl ne savait pas qu'il allait créer la sauce piquante la plus vendue de l'histoire.\n\n155 ans plus tard, Tabasco est présent dans 195 pays. Toujours fabriquée au même endroit.\n\n#Louisiane #Tabasco #SCOVL #HotSauceHistory #Origins`,
  },
];

const MOOD_EXAMPLES = [
  {
    id: 1,
    quote: "On ne collectionne pas les sauces.",
    quote2: "On collectionne les voyages qu'on n'a pas encore faits.",
    sub: "",
    style: "quote",
    accent: "#C0392B",
    bg: "radial-gradient(ellipse at 30% 40%, #2D0800 0%, #0A0404 60%, #040404 100%)",
    ingredients: [
      { emoji: "🌶️", x: 5, y: 10, size: 110, opacity: 0.08, rotate: -20 },
      { emoji: "🌶️", x: 72, y: 68, size: 80, opacity: 0.06, rotate: 15 },
    ],
    caption: `On ne collectionne pas les sauces.\nOn collectionne les voyages qu'on n'a pas encore faits.\n\n#SCOVL #HotSauce #FoodCulture #Collection #SaucesPiquantes`,
  },
  {
    id: 2,
    quote: "Wilbur Scoville.",
    quote2: "1912.",
    sub: "Il voulait mesurer la chaleur des piments.\nIl ne savait pas qu'il allait créer\nl'unité la plus redoutée de la gastronomie.",
    style: "editorial",
    accent: "#B8963E",
    bg: "radial-gradient(ellipse at 60% 30%, #1A1200 0%, #080600 60%, #040404 100%)",
    ingredients: [
      { emoji: "⚗️", x: 6, y: 8, size: 90, opacity: 0.1, rotate: 5 },
      { emoji: "📋", x: 70, y: 65, size: 75, opacity: 0.08, rotate: -10 },
    ],
    caption: `Wilbur Scoville. 1912.\n\nUn pharmacien américain qui voulait mesurer la chaleur des piments. Il ne savait pas qu'il allait créer l'unité de mesure la plus redoutée de la gastronomie mondiale.\n\n0 à 3 000 000 unités. Du poivron doux à l'extract pur.\n\nSur SCOVL, chaque sauce a son niveau exact.\n\n#Scoville #SHU #HotSauce #SCOVL #PimentFort`,
  },
  {
    id: 3,
    quote: "La chaleur ça se fabrique vite.",
    quote2: "Le caractère, ça se construit lentement.",
    sub: "",
    style: "minimal",
    accent: "#D4603A",
    bg: "radial-gradient(ellipse at 40% 60%, #1A0800 0%, #060404 70%, #040404 100%)",
    ingredients: [
      { emoji: "🫙", x: 8, y: 12, size: 95, opacity: 0.09, rotate: -8 },
      { emoji: "⏳", x: 68, y: 60, size: 85, opacity: 0.1, rotate: 12 },
    ],
    caption: `La chaleur ça se fabrique vite.\nLe caractère, ça se construit lentement.\n\nC'est la différence entre une sauce industrielle et une sauce fermentée.\nEntre 3 jours et 3 ans.\n\n#SCOVL #HotSauce #Artisan #Fermentation #FoodCulture`,
  },
];

// ═══════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════
const gaugePct = (shu, lvl) => {
  const bases = [0, 20, 40, 60, 80];
  const ranges = [[0, 1e4], [1e4, 1e5], [1e5, 5e5], [5e5, 1e6], [1e6, 3e6]];
  const i = Math.min(lvl, 4), [mn, mx] = ranges[i];
  return bases[i] + Math.min(1, Math.max(0, (shu - mn) / (mx - mn))) * 20;
};
const fmtSHU = n => n >= 1e6 ? `${(n / 1e6).toFixed(1)}M` : n >= 1e3 ? `${Math.round(n / 1e3)}k` : `${n}`;
const LEVELS = ["Doux", "Relevé", "Fort", "Intense", "Extrême"];
const LEVEL_COLORS = ["#F5D76E", "#E8A838", "#D4603A", "#C0392B", "#7B1A1A"];

// ═══════════════════════════════════════
// BOTTLE SVG
// ═══════════════════════════════════════
function Bottle({ theme, size = 130 }) {
  const s = size / 160;
  return (
    <svg width={70 * s} height={160 * s} viewBox="0 0 70 160" fill="none" style={{ filter: `drop-shadow(0 12px 30px ${theme.accent}55)` }}>
      <rect x="26" y="1" width="18" height="16" rx="5" fill={theme.accent} opacity=".92" />
      <path d="M23 17 L19 32 L51 32 L47 17 Z" fill={theme.bottleColor} opacity=".95" />
      <rect x="17" y="31" width="5" height="4" rx="1" fill={theme.accent} opacity=".5" />
      <rect x="48" y="31" width="5" height="4" rx="1" fill={theme.accent} opacity=".5" />
      <path d="M13 35 Q9 46 9 58 L9 128 Q9 144 35 146 Q61 144 61 128 L61 58 Q61 46 57 35 Z" fill={theme.bottleColor} opacity=".95" />
      <rect x="14" y="64" width="42" height="56" rx="3" fill={theme.labelColor} opacity=".15" />
      <rect x="14" y="64" width="42" height="10" rx="3" fill={theme.accent} opacity=".7" />
      <rect x="18" y="78" width="34" height="2.5" rx="1" fill="white" opacity=".2" />
      <rect x="20" y="84" width="30" height="2" rx="1" fill="white" opacity=".14" />
      <rect x="22" y="90" width="26" height="1.5" rx="1" fill="white" opacity=".1" />
      <text x="35" y="110" textAnchor="middle" fontFamily="'Cormorant Garamond', serif" fontSize="14" fontWeight="700" fill={theme.accent} opacity=".65">S</text>
      <path d="M18 50 Q19 65 18 82" stroke="white" strokeWidth="2.5" strokeLinecap="round" opacity=".06" />
      <ellipse cx="35" cy="136" rx="18" ry="5" fill="white" opacity=".03" />
    </svg>
  );
}

// ═══════════════════════════════════════
// ATMOSPHERIC BG
// ═══════════════════════════════════════
function AtmoBg({ theme, ingredients, children, style = {} }) {
  return (
    <div style={{ position: "relative", overflow: "hidden", ...style }}>
      <div style={{ position: "absolute", inset: 0, background: `radial-gradient(ellipse at 25% 30%, ${theme.bg1} 0%, ${theme.bg2} 55%, #030303 100%)` }} />
      <div style={{ position: "absolute", inset: 0, background: `radial-gradient(ellipse at 78% 72%, ${theme.accent}18 0%, transparent 65%)` }} />
      {ingredients.map((ing, i) => (
        <div key={i} className="ingredient" style={{ position: "absolute", left: `${ing.x}%`, top: `${ing.y}%`, fontSize: ing.size, opacity: ing.opacity, "--r": `${ing.rotate}deg`, transform: `rotate(${ing.rotate}deg)`, pointerEvents: "none", userSelect: "none", lineHeight: 1, animationDelay: `${i * 0.9}s` }}>
          {ing.emoji}
        </div>
      ))}
      <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at center, transparent 35%, rgba(0,0,0,.6) 100%)" }} />
      {children}
    </div>
  );
}

// ═══════════════════════════════════════
// TEMPLATE : DROP
// ═══════════════════════════════════════
function TemplateDrop({ data, showCaption, onToggleCaption }) {
  const pct = gaugePct(data.shu, data.levelIdx);
  const lc = LEVEL_COLORS[data.levelIdx];

  return (
    <div className="fade-in" style={{ display: "flex", flexDirection: "column", gap: 0 }}>
      {/* Post visual — 1:1 square */}
      <div style={{ position: "relative", width: "100%", aspectRatio: "1/1", borderRadius: "16px 16px 0 0", overflow: "hidden" }}>
        <AtmoBg theme={data.theme} ingredients={data.ingredients} style={{ position: "absolute", inset: 0 }} />

        {/* Content */}
        <div style={{ position: "absolute", inset: 0, padding: "18px 20px", display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
          {/* Top row */}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
            <div style={{ background: `${lc}22`, border: `1px solid ${lc}44`, borderRadius: 20, padding: "4px 11px" }}>
              <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 9, color: lc, fontWeight: 600, letterSpacing: ".08em" }}>{data.level.toUpperCase()}</span>
            </div>
            <span style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 22, fontWeight: 700, color: "rgba(255,255,255,.22)", letterSpacing: ".2em" }}>SCOVL</span>
          </div>

          {/* Bottle */}
          <div style={{ display: "flex", justifyContent: "center", alignItems: "center", flex: 1 }}>
            <Bottle theme={data.theme} size={150} />
          </div>

          {/* Bottom info */}
          <div>
            {/* Sauce name */}
            <div style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 26, fontWeight: 700, color: "#fff", lineHeight: 1.15, marginBottom: 2, textShadow: "0 2px 20px rgba(0,0,0,.6)" }}>{data.name}</div>
            <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: "rgba(255,255,255,.4)", letterSpacing: ".06em", marginBottom: 12 }}>{data.brand.toUpperCase()} · {data.flag} {data.country.toUpperCase()}</div>

            {/* Gauge */}
            <div style={{ marginBottom: 8 }}>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 5 }}>
                <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 8, color: "rgba(255,255,255,.3)", letterSpacing: ".1em" }}>SCOVILLE</span>
                <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 11, color: data.theme.accent, fontWeight: 500 }}>{fmtSHU(data.shu)} SHU</span>
              </div>
              <div style={{ height: 6, background: "rgba(0,0,0,.5)", borderRadius: 3, overflow: "hidden" }}>
                <div style={{ height: "100%", width: `${pct}%`, background: GGRADIENT, backgroundSize: "300px 100%", borderRadius: 3 }} />
              </div>
              <div style={{ display: "flex", justifyContent: "space-between", marginTop: 4 }}>
                {LEVELS.map((l, i) => (
                  <span key={l} style={{ fontFamily: "'DM Mono',monospace", fontSize: 7.5, color: i === data.levelIdx ? data.theme.accent : "rgba(255,255,255,.2)", fontWeight: i === data.levelIdx ? 700 : 400 }}>{l}</span>
                ))}
              </div>
            </div>

            {/* Scores */}
            <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
              {[{ label: "Heat", v: data.heat }, { label: "Flavor", v: data.flavor }, { label: "Balance", v: data.balance }, { label: "Finish", v: data.finish }].map(cr => (
                <div key={cr.label} style={{ background: "rgba(0,0,0,.5)", borderRadius: 8, padding: "4px 8px", display: "flex", gap: 4, alignItems: "center" }}>
                  <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 8, color: "rgba(255,255,255,.35)", letterSpacing: ".04em" }}>{cr.label}</span>
                  <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: data.theme.accent, fontWeight: 600 }}>{cr.v.toFixed(1)}</span>
                </div>
              ))}
              <div style={{ marginLeft: "auto", background: "rgba(0,0,0,.5)", borderRadius: 8, padding: "4px 10px", display: "flex", alignItems: "center", gap: 5 }}>
                <span style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 16, fontWeight: 700, color: C.gold }}>{data.score.toFixed(1)}</span>
                <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 7, color: "rgba(255,255,255,.3)" }}>/ 5</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Caption toggle */}
      <CaptionBlock caption={data.caption} show={showCaption} onToggle={onToggleCaption} />
    </div>
  );
}

// ═══════════════════════════════════════
// TEMPLATE : ORIGINS
// ═══════════════════════════════════════
function TemplateOrigins({ data, showCaption, onToggleCaption }) {
  return (
    <div className="fade-in" style={{ display: "flex", flexDirection: "column" }}>
      <div style={{ position: "relative", width: "100%", aspectRatio: "1/1", borderRadius: "16px 16px 0 0", overflow: "hidden", background: "#060404" }}>
        {/* Background */}
        <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at 20% 80%, #1A0600 0%, #060404 70%)" }} />
        <div style={{ position: "absolute", inset: 0, background: `radial-gradient(ellipse at 75% 20%, ${data.accent}15 0%, transparent 60%)` }} />

        {/* Large emoji background */}
        <div style={{ position: "absolute", right: "-5%", bottom: "-5%", fontSize: 200, opacity: .04, userSelect: "none", lineHeight: 1 }}>{data.emoji}</div>

        {/* Vertical line accent */}
        <div style={{ position: "absolute", left: 28, top: 56, bottom: 28, width: 2, background: `linear-gradient(180deg, ${data.accent} 0%, transparent 100%)`, borderRadius: 1 }} />

        {/* Content */}
        <div style={{ position: "absolute", inset: 0, padding: "24px 24px 24px 44px", display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
          {/* Header */}
          <div>
            <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 9, color: data.accent, letterSpacing: ".15em", marginBottom: 6 }}>{data.category}</div>
            <div style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 38, fontWeight: 700, color: "#fff", lineHeight: 1.1, marginBottom: 4 }}>{data.title}</div>
            <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: "rgba(255,255,255,.3)", letterSpacing: ".05em" }}>{data.subtitle}</div>
          </div>

          {/* Data table */}
          <div style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", padding: "16px 0" }}>
            {data.data.map((d, i) => (
              <div key={i} style={{ display: "flex", borderBottom: `1px solid rgba(255,255,255,.06)`, padding: "7px 0", alignItems: "baseline", gap: 10 }}>
                <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 9, color: data.accent, letterSpacing: ".06em", minWidth: 80, flexShrink: 0 }}>{d.label.toUpperCase()}</span>
                <span style={{ fontFamily: "'Outfit',sans-serif", fontSize: 13, color: "rgba(255,255,255,.7)", lineHeight: 1.4 }}>{d.value}</span>
              </div>
            ))}
          </div>

          {/* Body text */}
          <div style={{ borderLeft: `2px solid ${data.accent}44`, paddingLeft: 12 }}>
            <div style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 15, fontStyle: "italic", color: "rgba(255,255,255,.55)", lineHeight: 1.7, whiteSpace: "pre-line" }}>{data.body}</div>
          </div>
        </div>

        {/* SCOVL watermark */}
        <div style={{ position: "absolute", bottom: 20, right: 22, fontFamily: "'Cormorant Garamond',serif", fontSize: 12, fontWeight: 700, color: "rgba(255,255,255,.12)", letterSpacing: ".25em" }}>SCOVL</div>
      </div>

      <CaptionBlock caption={data.caption} show={showCaption} onToggle={onToggleCaption} />
    </div>
  );
}

// ═══════════════════════════════════════
// TEMPLATE : MOOD
// ═══════════════════════════════════════
function TemplateMood({ data, showCaption, onToggleCaption }) {
  return (
    <div className="fade-in" style={{ display: "flex", flexDirection: "column" }}>
      <div style={{ position: "relative", width: "100%", aspectRatio: "1/1", borderRadius: "16px 16px 0 0", overflow: "hidden" }}>
        {/* Background */}
        <div style={{ position: "absolute", inset: 0, background: data.bg }} />
        {data.ingredients.map((ing, i) => (
          <div key={i} className="ingredient" style={{ position: "absolute", left: `${ing.x}%`, top: `${ing.y}%`, fontSize: ing.size, opacity: ing.opacity, "--r": `${ing.rotate}deg`, transform: `rotate(${ing.rotate}deg)`, pointerEvents: "none", userSelect: "none", lineHeight: 1, animationDelay: `${i * 1.2}s` }}>
            {ing.emoji}
          </div>
        ))}
        <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at center, rgba(0,0,0,.1) 0%, rgba(0,0,0,.7) 100%)" }} />

        {/* Horizontal rule top */}
        <div style={{ position: "absolute", top: 48, left: 28, right: 28, height: 1, background: `linear-gradient(90deg, transparent, ${data.accent}88, transparent)` }} />

        {/* Content */}
        <div style={{ position: "absolute", inset: 0, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", padding: "60px 32px", textAlign: "center" }}>
          <div style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 34, fontWeight: 700, fontStyle: "italic", color: "#fff", lineHeight: 1.25, marginBottom: data.quote2 ? 10 : 0, textShadow: "0 2px 30px rgba(0,0,0,.6)" }}>{data.quote}</div>
          {data.quote2 && (
            <div style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 34, fontWeight: 300, color: "rgba(255,255,255,.7)", lineHeight: 1.25, textShadow: "0 2px 30px rgba(0,0,0,.6)" }}>{data.quote2}</div>
          )}
          {data.sub && (
            <div style={{ fontFamily: "'Outfit',sans-serif", fontSize: 13, color: "rgba(255,255,255,.4)", lineHeight: 1.7, marginTop: 20, whiteSpace: "pre-line" }}>{data.sub}</div>
          )}
        </div>

        {/* Horizontal rule bottom */}
        <div style={{ position: "absolute", bottom: 48, left: 28, right: 28, height: 1, background: `linear-gradient(90deg, transparent, ${data.accent}88, transparent)` }} />

        {/* SCOVL bottom */}
        <div style={{ position: "absolute", bottom: 22, left: 0, right: 0, textAlign: "center" }}>
          <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 9, color: "rgba(255,255,255,.2)", letterSpacing: ".25em" }}>SCOVL · EVERY DROP HAS A STORY.</span>
        </div>
      </div>

      <CaptionBlock caption={data.caption} show={showCaption} onToggle={onToggleCaption} />
    </div>
  );
}

// ═══════════════════════════════════════
// CAPTION BLOCK
// ═══════════════════════════════════════
function CaptionBlock({ caption, show, onToggle }) {
  return (
    <div style={{ background: C.card, borderRadius: "0 0 16px 16px", border: `1px solid ${C.border}`, borderTop: "none" }}>
      <button onClick={onToggle} style={{ width: "100%", padding: "12px 18px", display: "flex", justifyContent: "space-between", alignItems: "center", background: "none", border: "none", cursor: "pointer", borderBottom: show ? `1px solid ${C.border}` : "none" }}>
        <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.muted, letterSpacing: ".1em" }}>CAPTION INSTAGRAM</span>
        <span style={{ color: C.muted, fontSize: 16, lineHeight: 1, transform: show ? "rotate(180deg)" : "rotate(0)", transition: "transform .2s" }}>›</span>
      </button>
      {show && (
        <div style={{ padding: "14px 18px 16px" }}>
          <pre style={{ fontFamily: "'Outfit',sans-serif", fontSize: 13, color: C.muted, whiteSpace: "pre-wrap", lineHeight: 1.7, margin: 0 }}>{caption}</pre>
          <button onClick={() => navigator.clipboard?.writeText(caption)} style={{ marginTop: 12, padding: "8px 14px", background: C.red + "22", border: `1px solid ${C.red}44`, borderRadius: 8, fontSize: 11, fontFamily: "'DM Mono',monospace", color: C.red, cursor: "pointer", letterSpacing: ".06em" }}>
            COPIER LA CAPTION
          </button>
        </div>
      )}
    </div>
  );
}

// ═══════════════════════════════════════
// FORMAT SELECTOR PILL
// ═══════════════════════════════════════
function FormatPill({ label, active, color, onClick }) {
  return (
    <button onClick={onClick} style={{ padding: "8px 18px", borderRadius: 24, fontSize: 12, fontFamily: "'DM Mono',monospace", letterSpacing: ".08em", background: active ? color : "transparent", color: active ? "#fff" : C.muted, border: `1.5px solid ${active ? color : C.border}`, cursor: "pointer", transition: "all .2s", fontWeight: active ? 600 : 400 }}>
      {label}
    </button>
  );
}

// ═══════════════════════════════════════
// EXAMPLE NAV DOTS
// ═══════════════════════════════════════
function NavDots({ count, active, onSelect, color }) {
  return (
    <div style={{ display: "flex", gap: 6, justifyContent: "center" }}>
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} onClick={() => onSelect(i)} style={{ width: i === active ? 20 : 7, height: 7, borderRadius: 4, background: i === active ? color : C.dim, cursor: "pointer", transition: "all .3s" }} />
      ))}
    </div>
  );
}

// ═══════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════
export default function ScovlTemplates() {
  const [format, setFormat] = useState("DROP");
  const [dropIdx, setDropIdx] = useState(0);
  const [originsIdx, setOriginsIdx] = useState(0);
  const [moodIdx, setMoodIdx] = useState(0);
  const [showCaption, setShowCaption] = useState(false);

  const formats = [
    { id: "DROP", label: "DROP", color: C.red, desc: "Fiche produit · 2×/semaine" },
    { id: "ORIGINS", label: "ORIGINS", color: C.gold, desc: "Culture & histoire · 1×/semaine" },
    { id: "MOOD", label: "MOOD", color: "#5B4FD4", desc: "Lifestyle & ambiance · 1×/semaine" },
  ];

  const currentFormat = formats.find(f => f.id === format);

  const handleCaptionToggle = () => setShowCaption(p => !p);

  return (
    <div className="sc" style={{ minHeight: "100vh", background: "#060404", padding: "24px 16px 48px", display: "flex", flexDirection: "column", gap: 0 }}>
      <style>{CSS}</style>

      {/* Header */}
      <div style={{ textAlign: "center", marginBottom: 28 }}>
        <div style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 28, fontWeight: 700, color: C.text, letterSpacing: ".2em", marginBottom: 4 }}>SCOVL</div>
        <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.muted, letterSpacing: ".15em" }}>KIT TEMPLATES INSTAGRAM</div>
      </div>

      {/* Format selector */}
      <div style={{ display: "flex", gap: 8, justifyContent: "center", marginBottom: 10, flexWrap: "wrap" }}>
        {formats.map(f => (
          <FormatPill key={f.id} label={f.label} active={format === f.id} color={f.color} onClick={() => { setFormat(f.id); setShowCaption(false); }} />
        ))}
      </div>

      {/* Format descriptor */}
      <div style={{ textAlign: "center", marginBottom: 20 }}>
        <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: currentFormat.color, letterSpacing: ".08em" }}>{currentFormat.desc}</span>
      </div>

      {/* Template display */}
      <div style={{ maxWidth: 440, margin: "0 auto", width: "100%" }}>

        {/* Usage tip */}
        <div style={{ display: "flex", gap: 8, marginBottom: 14, background: C.card, borderRadius: 12, padding: "10px 14px", border: `1px solid ${C.border}` }}>
          <span style={{ fontSize: 14 }}>💡</span>
          <div>
            <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 9, color: currentFormat.color, letterSpacing: ".08em", marginBottom: 3 }}>USAGE CANVA</div>
            {format === "DROP" && <span style={{ fontSize: 11, color: C.muted, lineHeight: 1.5 }}>Format 1:1 (1080×1080px). Fond atmosphérique → Bouteille centrée → Données produit en bas. Dupliquer le template et remplacer les couleurs selon la sauce.</span>}
            {format === "ORIGINS" && <span style={{ fontSize: 11, color: C.muted, lineHeight: 1.5 }}>Format 1:1 (1080×1080px). Ligne verticale comme ancre gauche. Tableau de données au centre. Citation en bas. Structure fixe, seuls les contenus changent.</span>}
            {format === "MOOD" && <span style={{ fontSize: 11, color: C.muted, lineHeight: 1.5 }}>Format 1:1 (1080×1080px). Fond atmosphérique sombre. Une ou deux phrases en Cormorant Garamond centré. Règles horizontales accent. Minimaliste.</span>}
          </div>
        </div>

        {/* Template */}
        {format === "DROP" && (
          <>
            <TemplateDrop key={dropIdx} data={DROP_EXAMPLES[dropIdx]} showCaption={showCaption} onToggleCaption={handleCaptionToggle} />
            <div style={{ marginTop: 16 }}>
              <NavDots count={DROP_EXAMPLES.length} active={dropIdx} onSelect={i => { setDropIdx(i); setShowCaption(false); }} color={C.red} />
            </div>
          </>
        )}

        {format === "ORIGINS" && (
          <>
            <TemplateOrigins key={originsIdx} data={ORIGINS_EXAMPLES[originsIdx]} showCaption={showCaption} onToggleCaption={handleCaptionToggle} />
            <div style={{ marginTop: 16 }}>
              <NavDots count={ORIGINS_EXAMPLES.length} active={originsIdx} onSelect={i => { setOriginsIdx(i); setShowCaption(false); }} color={C.gold} />
            </div>
          </>
        )}

        {format === "MOOD" && (
          <>
            <TemplateMood key={moodIdx} data={MOOD_EXAMPLES[moodIdx]} showCaption={showCaption} onToggleCaption={handleCaptionToggle} />
            <div style={{ marginTop: 16 }}>
              <NavDots count={MOOD_EXAMPLES.length} active={moodIdx} onSelect={i => { setMoodIdx(i); setShowCaption(false); }} color="#5B4FD4" />
            </div>
          </>
        )}

        {/* Canva specs */}
        <div style={{ marginTop: 24, background: C.card, borderRadius: 16, padding: "18px", border: `1px solid ${C.border}` }}>
          <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.muted, letterSpacing: ".12em", marginBottom: 14 }}>SPÉCIFICATIONS CANVA</div>
          <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
            {[
              { label: "Format", value: "1080 × 1080 px — Publication carrée" },
              { label: "Font display", value: "Cormorant Garamond · Bold / Italic" },
              { label: "Font data", value: "DM Mono · Regular / Medium" },
              { label: "Font body", value: "Outfit · Regular / Medium" },
              { label: "Rouge SCOVL", value: "#C0392B" },
              { label: "Or SCOVL", value: "#B8963E" },
              { label: "Feu", value: "#D4603A" },
              { label: "Fond", value: "#0A0909" },
              { label: "Texte principal", value: "#F2EDE8" },
              { label: "Texte secondaire", value: "#7A6F6A" },
            ].map((s, i) => (
              <div key={i} style={{ display: "flex", justifyContent: "space-between", padding: "6px 0", borderBottom: `1px solid ${C.border}` }}>
                <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.muted, letterSpacing: ".04em" }}>{s.label}</span>
                <span style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.text }}>{s.value}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Batch production guide */}
        <div style={{ marginTop: 14, background: C.card, borderRadius: 16, padding: "18px", border: `1px solid ${C.border}` }}>
          <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.muted, letterSpacing: ".12em", marginBottom: 14 }}>MÉTHODE BATCHING — &lt; 2H/SEMAINE</div>
          {[
            { step: "01", label: "Session mensuelle (2h)", desc: "Créer les 16 visuels du mois en dupliquant les templates Canva." },
            { step: "02", label: "Captions (30 min)", desc: "Rédiger ou adapter les captions depuis ce kit. Copier-coller disponible." },
            { step: "03", label: "Scheduling (15 min)", desc: "Programmer sur Meta Business Suite ou Later. Gratuit." },
            { step: "04", label: "Daily (10 min/j)", desc: "Répondre aux commentaires. Commenter 5 comptes similaires." },
          ].map(s => (
            <div key={s.step} style={{ display: "flex", gap: 14, marginBottom: 12, paddingBottom: 12, borderBottom: `1px solid ${C.border}` }}>
              <span style={{ fontFamily: "'Cormorant Garamond',serif", fontSize: 22, fontWeight: 700, color: C.red, flexShrink: 0, lineHeight: 1 }}>{s.step}</span>
              <div>
                <div style={{ fontFamily: "'Outfit',sans-serif", fontSize: 13, fontWeight: 600, color: C.text, marginBottom: 2 }}>{s.label}</div>
                <div style={{ fontSize: 12, color: C.muted, lineHeight: 1.5 }}>{s.desc}</div>
              </div>
            </div>
          ))}
        </div>

        {/* Hashtag bank */}
        <div style={{ marginTop: 14, background: C.card, borderRadius: 16, padding: "18px", border: `1px solid ${C.border}` }}>
          <div style={{ fontFamily: "'DM Mono',monospace", fontSize: 10, color: C.muted, letterSpacing: ".12em", marginBottom: 12 }}>BANQUE HASHTAGS — À ROTATION</div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {["#SCOVL","#HotSauce","#SaucesPiquantes","#PimentFort","#FoodCulture","#HotSauceAddict","#Scoville","#Spicy","#FoodPhotography","#Gastronomie","#Piment","#Origins","#HotSauceCollector","#ArtisanHotSauce","#SpicyFood","#ChiliPepper","#FoodLovers","#WorldFood","#HotSauceOfTheDay","#Fermentation"].map(h => (
              <span key={h} style={{ background: `${C.red}18`, color: C.red, fontSize: 10, padding: "4px 10px", borderRadius: 16, border: `1px solid ${C.red}30`, fontFamily: "'DM Mono',monospace", letterSpacing: ".02em" }}>{h}</span>
            ))}
          </div>
          <div style={{ marginTop: 10, fontFamily: "'Outfit',sans-serif", fontSize: 11, color: C.muted, lineHeight: 1.6 }}>
            Utiliser 5 à 8 hashtags par post. Alterner entre niches (ex: #Scoville #Habanero) et grands volumes (#FoodPhotography #Spicy). Ne jamais répéter les mêmes hashtags deux posts de suite.
          </div>
        </div>

      </div>

      <div style={{ textAlign: "center", marginTop: 28, fontFamily: "'DM Mono',monospace", fontSize: 9, color: C.dim, letterSpacing: ".15em" }}>
        SCOVL · TEMPLATE KIT V1.0 · EVERY DROP HAS A STORY.
      </div>
    </div>
  );
}
