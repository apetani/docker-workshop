FROM node:8.16.0

EXPOSE 3000
WORKDIR /var/www
COPY package.json package-lock.json /var/www/
RUN npm install
COPY . /var/www/

CMD npm start