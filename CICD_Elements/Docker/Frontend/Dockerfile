# syntax=docker/dockerfile:1

FROM node:current-alpine
ENV NODE_ENV=production
COPY . /movie-analyst-ui
WORKDIR /movie-analyst-ui
RUN npm install --production
CMD [ "node", "server.js" ]