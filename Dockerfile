FROM node:26.13.0-alpine@sha256:8996bb5821d62a8fd9bb27c1cb07462f3fdce6e47d640c6a881ead0b064ce216 AS base
LABEL maintainer="rfatolahzade <https://github.com/rfatolahzade>" \
      contributor="MJ <https://github.com/dashtaki>" \
      repository="https://github.com/rfatolahzade/Dockerizing-a-NodeJS-web-app"

WORKDIR /usr/src/app

FROM base AS build
COPY script/package.json ./
# Generate the updated lockfile inside the image; the repository lockfile is unchanged.
RUN npm install --package-lock-only && npm ci

COPY script/app.js ./
COPY script/routes/ ./routes/
COPY script/public/ ./public/
COPY test/ .
RUN npm test

FROM base AS production-deps
COPY --from=build /usr/src/app/package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

FROM base AS runtime
ENV NODE_ENV=production

COPY --from=production-deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json /usr/src/app/app.js ./
COPY --from=build /usr/src/app/routes ./routes
COPY --from=build /usr/src/app/public ./public

EXPOSE 8080

USER node

CMD [ "node", "app.js" ]
