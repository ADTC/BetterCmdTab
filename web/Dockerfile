FROM oven/bun:1-alpine AS build
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile
COPY . .
# Same non-fatal refresh as deploy-pages.yml: the committed releases.json is a valid fallback.
RUN bun run scripts/fetch-releases.ts || echo "keeping the committed releases.json"
RUN bun run build

FROM oven/bun:1-alpine
WORKDIR /app
COPY --from=build /app/out ./out
COPY serve.ts ./
USER bun
EXPOSE 3000
CMD ["bun", "serve.ts"]
