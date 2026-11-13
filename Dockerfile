FROM node:26.13.0-alpine AS base

# Apply available Alpine security updates during the image build.
RUN apk update && apk upgrade --no-cache

LABEL maintainer="rfatolahzade <https://github.com/rfatolahzade>" \
      contributor="MJ <https://github.com/dashtaki>" \
      repository="https://github.com/rfatolahzade/Dockerizing-a-NodeJS-web-app"

WORKDIR /usr/src/app

FROM base AS build
# COPY both package.json and the newly generated package-lock.json
COPY script/package*.json ./
# npm ci is strict, fast, and uses the lockfile. --ignore-scripts maintains security.
RUN npm ci --ignore-scripts

COPY script/app.js ./
COPY script/routes/ ./routes/
COPY script/public/ ./public/
COPY test/ .
RUN npm test

FROM base AS production-deps
COPY --from=build /usr/src/app/package*.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force

FROM base AS runtime
ENV NODE_ENV=production

COPY --from=production-deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json /usr/src/app/app.js ./
COPY --from=build /usr/src/app/routes ./routes
COPY --from=build /usr/src/app/public ./public

# npm is not needed to run the application. Remove its bundled dependency tree
# from the final image to avoid shipping vulnerable npm-only packages.
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

EXPOSE 8080

USER node

CMD [ "node", "app.js" ]
