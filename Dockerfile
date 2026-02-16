FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

FROM node:20-alpine AS production
RUN addgroup -g 1001 -S nodejs && adduser -S expressapp -u 1001
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY --from=builder /app/app.js ./
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/routes ./routes
COPY --from=builder /app/public ./public
RUN chown -R expressapp:nodejs /app
USER expressapp
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "./bin/www"]