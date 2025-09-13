# Stage 1: Build the Vue app
FROM ubuntu:22.04 AS builder

# Install Node.js and other essentials
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency files and install
COPY package*.json ./
RUN npm install

# Copy source and build the app
COPY . .
RUN npm run build

# Stage 2: Serve the built app using nginx on Ubuntu
FROM ubuntu:22.04

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy built files to nginx root
COPY --from=builder /app/dist /var/www/html

# Replace nginx config with our own
COPY nginx.conf /etc/nginx/nginx.conf

# Run as non-root user (optional, requires some tweaks to permissions)
# USER www-data

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]


# docker push gcr.io/$GOOGLE_CLOUD_PROJECT/my-vue-app:latest
# gcloud auth configure-docker apps --project=$GOOGLE_CLOUD_PROJECT
# docker build -t us-east4.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/my-vue-app:latest .
# docker push -t us-east4.pkg.dev/$GOOGLE_CLOUD_PROJECT/apps/my-vue-app:latest