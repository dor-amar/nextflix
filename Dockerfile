FROM node:18-alpine

WORKDIR /usr/src/app
# helps native deps like sharp on Alpine
RUN apk add --no-cache libc6-compat

# Install deps first (cache-friendly)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi

# Copy source
COPY . .

# 👇 Key fix: upgrade TS & Node types inside the build container
RUN npm i -D typescript@^5.4 @types/node@^18 --no-audit --no-fund

# Build
RUN npm run build

EXPOSE 3000
CMD ["npm","start","--","-p","3000"]
