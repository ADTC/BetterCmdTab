import { join, sep } from "node:path";

// Same contract as GitHub Pages: `<dir>/index.html` for a slashed URL, /404.html for anything missing.
const root = join(import.meta.dir, "out");
const notFound = () => new Response(Bun.file(join(root, "404.html")), { status: 404 });

Bun.serve({
  port: Number(process.env.PORT ?? 3000),
  async fetch(req) {
    const { pathname } = new URL(req.url);
    const path = join(root, decodeURIComponent(pathname));
    if (path !== root && !path.startsWith(root + sep)) return notFound();

    const file = Bun.file(pathname.endsWith("/") ? join(path, "index.html") : path);
    if (!(await file.exists())) return notFound();

    // Vite content-hashes everything under /assets/, so a changed file gets a new URL.
    const immutable = pathname.startsWith("/assets/");
    return new Response(file, {
      headers: immutable ? { "Cache-Control": "public, max-age=31536000, immutable" } : {},
    });
  },
});
