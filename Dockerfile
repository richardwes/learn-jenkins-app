# Build stage
FROM node:23-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# Production stage
FROM node:23-alpine

WORKDIR /app

# Install serve to run the production build
RUN npm install -g serve

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001

COPY --from=builder /app/build ./build

RUN chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
