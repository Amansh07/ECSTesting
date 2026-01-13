
# Build stage (Node)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
# Adjust build command if your framework differs (React/Vue/Angular)
RUN npm run build

# Runtime stage (Nginx)
FROM nginx:alpine
# Optional: custom Nginx config for SPA routing
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

