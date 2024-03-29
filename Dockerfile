FROM node:fermium-alpine3.15

WORKDIR /usr/src/app

COPY script/package*.json ./

RUN npm install

COPY script/ .

EXPOSE 8080

RUN chown -R node:node .
USER node

CMD [ "node", "app.js" ]
