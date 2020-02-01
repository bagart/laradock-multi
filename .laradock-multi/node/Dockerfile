# Node.JS template for https://github.com/bagart/laradock-multi
ARG LARADOCK_NODE_VERSION
FROM node:${LARADOCK_NODE_VERSION}

WORKDIR /var/www

ENV PATH=/var/www/node_modules/.bin:$PATH
ENV BROWSER=none

ARG LARADOCK_NODE_PORT
ENV PORT=${LARADOCK_NODE_PORT}

RUN npm install react-scripts -g --silent

ARG LARADOCK_NODE_PATH_HOST
#Not work with external path
#COPY ${LARADOCK_NODE_PATH_HOST}/package.json /var/www
#RUN npm ci -qy

ARG LARADOCK_NODE_NODE_VERSION
EXPOSE ${LARADOCK_NODE_PORT}

CMD ["npm", "start"]

