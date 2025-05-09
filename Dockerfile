FROM node:18-alpine3.19
# Metadata labels
LABEL maintainer="rfatolahzade <https://github.com/rfatolahzade>" \
      contributor="MJ <https://github.com/dashtaki>" \
      repository="https://github.com/rfatolahzade/Dockerizing-a-NodeJS-web-app"
      
WORKDIR /usr/src/app

COPY script/package*.json ./

RUN npm install

COPY script/ .

EXPOSE 8080

RUN chown -R node:node .
USER node

CMD [ "node", "app.js" ]
