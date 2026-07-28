// ═══════════════════════════════════════════════════════════
// Configuration Ajimento — à remplir une fois ton projet Supabase créé
// ═══════════════════════════════════════════════════════════
//
// Où trouver ces valeurs : dans ton projet Supabase, menu
// "Project Settings" (roue crantée) → "API".
// - "Project URL"      → colle-la dans SUPABASE_URL
// - "anon public" key  → colle-la dans SUPABASE_ANON_KEY
//
// Cette clé "anon" est PUBLIQUE PAR CONCEPTION chez Supabase — elle est
// prévue pour être visible dans le code d'une app (contrairement à un
// mot de passe). La vraie protection vient des règles de sécurité (RLS)
// définies dans schema.sql. Donc pas de souci à la voir dans ce fichier.
//
// Tant que ces deux valeurs ne sont pas remplies, l'app continue de
// fonctionner avec des données de démonstration — rien ne casse.

window.AJIMENTO_CONFIG = {
  SUPABASE_URL: "https://cjyfrndzjzmakohdodkx.supabase.co",
  SUPABASE_ANON_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqeWZybmR6anptYWtvaGRvZGt4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUyNjY0MzEsImV4cCI6MjEwMDg0MjQzMX0.4duv38O8c3C8G3W_oXkNmN4RMXfwFzBUVlSr9nzVm-E",
};
