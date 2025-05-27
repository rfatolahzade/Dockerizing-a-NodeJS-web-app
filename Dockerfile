FROM node:24.1.0-alpine3.21
# Metadata labels
LABEL maintainer="rfatolahzade <https://github.com/rfatolahzade>" \
      contributor="MJ <https://github.com/dashtaki>" \
      repository="https://github.com/rfatolahzade/Dockerizing-a-NodeJS-web-app"
      
WORKDIR /usr/src/app

COPY script/package*.json ./

#RUN npm install
RUN npm ci --omit=dev && npm cache clean --force && rm package-lock.json
 
COPY script/ .

EXPOSE 8080

RUN chown -R node:node /usr/src/app
USER node

CMD [ "node", "app.js" ]
