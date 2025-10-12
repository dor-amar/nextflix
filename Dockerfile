# ---- Build stage ----
FROM node:18-alpine AS build
WORKDIR /app

# Needed by Next.js/sharp on Alpine
RUN apk add --no-cache libc6-compat

# Install deps with npm (no yarn)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi

# Copy source and build
COPY . .
RUN npm run build

# ---- Runtime stage ----
FROM node:18-alpine
ENV NODE_ENV=production
WORKDIR /app

COPY --from=build /app ./
EXPOSE 3000
CMD ["npm","start","--","-p","3000"]
