#####Build stage
FROM node:24.4.1-alpine3.21 AS build
LABEL maintainer="rfatolahzade <https://github.com/rfatolahzade>" \
      contributor="MJ <https://github.com/dashtaki>" \
      repository="https://github.com/rfatolahzade/Dockerizing-a-NodeJS-web-app"

WORKDIR /usr/src/app
COPY script/package*.json ./

RUN npm ci && npm cache clean --force

COPY script/ .
COPY test/ .
RUN npm test
#####Final stage
FROM node:24.4.1-alpine3.21
WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package*.json ./

RUN npm ci --omit=dev && npm cache clean --force && rm package-lock.json

COPY --from=build /usr/src/app ./

EXPOSE 8080

RUN chown -R node:node /usr/src/app
USER node

CMD [ "node", "app.js" ]
