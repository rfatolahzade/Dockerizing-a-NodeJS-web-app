FROM node:fermium-alpine3.15

WORKDIR /usr/src/app

COPY script/package*.json ./

RUN npm install

COPY script/ .

EXPOSE 8080

CMD [ "node", "app.js" ]
