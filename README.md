![Node.js web app](thumbnail.png)
# Dockerizing a Node.js web app
#### Build the app’s container image
Take a look at Dockerfile:
```bash
FROM node:fermium-alpine3.15

WORKDIR /usr/src/app

COPY script/package*.json ./

RUN npm install

COPY script/ .

EXPOSE 8080

RUN chown -R node:node .
USER node

CMD [ "node", "app.js" ]

```
# Image
Now build the container image using the docker build command:
```bash
docker build . -t node-web-app

```
This command used the Dockerfile to build a new container image. You might have noticed that a lot of “layers” were downloaded.
This is because we instructed the builder that we wanted to start from the node:16 image.
But, since we didn’t have that on our machine, that image needed to be downloaded.
List of your images:
```bash
docker images
```
# Container
Now that we have an image, let’s run the application. To do so, we will use the docker run command.
Start your container using the docker run command and specify the name of the image we just created:
```bash
docker run --name=mycontainer -p 8080:8080 -d node-web-app 
```
Inside the container you can see the content of the script folder as well.
List of your containers:
```bash
docker ps -a
```
Here you go, a container named "mycontainer", exposed port "8080:8080" is there.
If you take a look inside your container you can see your script directory as well:

```bash
docker exec -it mycontainer /bin/sh
```

After that run exit to exit from container.

# Test the app
Via terminal:
```bash
curl -i localhost:8080
```
Via browser:

Open your web browser to http://localhost:8080. You should see your app.
Depends on your machine (VirtualMachine) maybe you have to set port forwarding (port:8080)
and then visit: http://localhost:8080/

