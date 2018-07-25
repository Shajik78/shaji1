# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM angular/ngcontainer as build-stage
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY ./ /app/
ARG configuration=production
RUN npm run build --prod --source-map --build-optimizer false
