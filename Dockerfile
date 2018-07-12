
FROM node:8.11-alpine as build-stage

# --------------------------------------
# Install Chrome for testing
# --------------------------------------
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb
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

