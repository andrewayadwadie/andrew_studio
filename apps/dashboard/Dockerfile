# Build stage: compile Jaspr dashboard
FROM dart:stable AS build

WORKDIR /app

# Install dependencies
COPY apps/dashboard/pubspec.* ./
RUN dart pub get

# Install jaspr_cli globally
RUN dart pub global activate jaspr_cli

# Copy source
COPY apps/dashboard/ .
RUN dart pub get --offline

# Build Jaspr client app (outputs to build/jaspr/)
RUN dart pub global run jaspr_cli:jaspr build

# Serve stage: nginx for static files
FROM nginx:alpine
COPY --from=build /app/build/jaspr /usr/share/nginx/html

# SPA routing: all paths serve index.html
RUN printf 'server {\n  listen 80;\n  root /usr/share/nginx/html;\n  index index.html;\n  location / {\n    try_files $uri $uri/ /index.html;\n  }\n}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
