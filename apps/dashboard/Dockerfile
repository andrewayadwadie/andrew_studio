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

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
