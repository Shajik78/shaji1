FROM node:argon

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
COPY karma.conf.js /usr/src/app/
RUN npm install --quiet
EXPOSE 8000
CMD [ "npm", "run", "dev" ]
