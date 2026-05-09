self.addEventListener('install', function() {
  self.skipWaiting();
});

self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(keys.map(function(k) { return caches.delete(k); }));
    }).then(function() { return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function(event) {
  var url = new URL(event.request.url);
  if (url.origin !== location.origin) return;
  event.respondWith(
    fetch(event.request).catch(function() {
      return caches.match(event.request).then(function(c) { return c || caches.match('/index.html'); });
    })
  );
});
