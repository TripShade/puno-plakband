FROM node:lts-alpine

LABEL org.opencontainers.image.authors="René van Spronsen"

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

CMD [ "node", "dist/main.js" ]