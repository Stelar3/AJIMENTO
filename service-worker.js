// Service worker minimal — la pièce technique qui permet à l'app
// d'être "installable" et de fonctionner même sans connexion.
// Pour l'instant, il se contente de mettre en cache les fichiers de base.

const CACHE_NAME = "ajimento-v6";
const FILES_TO_CACHE = [
  "./",
  "./index.html",
  "./fiche-produit.html",
  "./explorer.html",
  "./cave.html",
  "./profil.html",
  "./onboarding.html",
  "./styles.css",
  "./config.js",
  "./sauces.js",
  "./manifest.json",
  "./icons/icon-192.png",
  "./icons/icon-512.png"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(FILES_TO_CACHE))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.match(event.request).then((cached) => cached || fetch(event.request))
  );
});
