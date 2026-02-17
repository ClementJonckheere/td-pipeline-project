# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .


# Stage 2: Production
FROM node:22-alpine AS production
RUN addgroup -g 1001 -S nodejs && adduser -S expressapp -u 1001
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
COPY --from=builder /app/app.js ./
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/routes ./routes
COPY --from=builder /app/public ./public
RUN chown -R expressapp:nodejs /app
USER expressapp
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "./bin/www"]