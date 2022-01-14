FROM node:16
WORKDIR /usr/src/app

COPY script/package*.json ./

RUN npm install
RUN echo ready
COPY script/ .

EXPOSE 8080

CMD [ "node", "app.js" ]
