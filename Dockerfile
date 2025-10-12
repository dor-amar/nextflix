FROM node:18-alpine

WORKDIR /usr/src/app
# (optional) helps native deps like sharp on Alpine
RUN apk add --no-cache libc6-compat

# Install deps first for better caching
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi

# Copy source and build
COPY . .
RUN npm run build

# App runs with TMDB_API_KEY provided at runtime (via docker run -e ...)
EXPOSE 3000
CMD ["npm","start","--","-p","3000"]
