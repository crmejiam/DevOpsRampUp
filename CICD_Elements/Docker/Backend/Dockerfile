# syntax=docker/dockerfile:1

FROM node:current-alpine
ENV NODE_ENV=production
RUN apk add --no-cache git                      # For installing Git
RUN git clone https://github.com/crmejiam/movie-analyst-api.git
WORKDIR /movie-analyst-api
RUN npm install --production
CMD [ "node", "server.js" ]