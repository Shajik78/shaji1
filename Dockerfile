
FROM node:8.11-alpine as build-stage

# --------------------------------------
# Install Chrome for testing
# --------------------------------------

# --------------------------------------
# Install npm packages
# --------------------------------------

WORKDIR /app
COPY package.json ./package.json

COPY . /app

# --------------------------------------
# Run Tests
# --------------------------------------
RUN ng test --progress false --single-run

# --------------------------------------
# Build PROD & BETA
# --------------------------------------
RUN ng build --prod --no-progress && \
    ng build --environment beta  --no-progress --prod --output-path dist-beta

# --------------------------------------
# Create final image
# --------------------------------------
FROM nginx:1.13.1

WORKDIR /app
COPY --from=builder /app/dist .

WORKDIR /app-beta
COPY --from=builder /app/dist-beta .

RUN  rm -rf /usr/share/nginx/html/* && \
	 cp -R /app/* /usr/share/nginx/html/  && \
	 mkdir /usr/share/nginx/html-beta/  && \
	 cp -R /app-beta/* /usr/share/nginx/html-beta/

COPY nginx.conf /etc/nginx/conf.d/default.conf

