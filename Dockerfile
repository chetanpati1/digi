
#BASE IMAGE
FROM node:lts-alpine AS builder

# SETTING UP WORK DIRECTORY
WORKDIR /app

#COPYING PACKAGE.JSON TO WORKING DIRECTORY
COPY package*.json ./

#INSTALLING ANGULAR CLI 15.1.1
RUN npm i -g @angular/cli@15.1.6

#EXPOSING THE INTERNAL PORT OF ANGULAR APPLICATION 
EXPOSE 4200

#INSTALLING THE DEPENDENCIES LISTED IN PACKAGE.JSON 
RUN npm install

#COPYING EVEYTHING FROM CURRENT DIRECTORY TO THE WORK DIRECTORY
COPY . .

RUN ng build 

#SERVING THE APPLICATION
# CMD ["ng","serve","--host", "0.0.0.0"]


### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:1.23.3-alpine
# Copying compiled code and nginx config to different folder
# NOTE: This path may change according to your project's output folder 
COPY --from=builder /app/dist/tp-angular /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf
# Exposing a port, here it means that inside the container 
# the app will be using Port 80 while running
EXPOSE 80
