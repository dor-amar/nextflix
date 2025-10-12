# Minimal, fixes TS version + keeps secrets out of image
FROM node:18-alpine

WORKDIR /app
# (optional) helps native deps like sharp on Alpine
RUN apk add --no-cache libc6-compat

# Install deps (cache-friendly)
COPY package*.json ./
RUN npm install --no-audit --no-fund

# Copy source
COPY . .

# Ensure TS understands `useUnknownInCatchVariables`
RUN npm i -D typescript@^5.4 @types/node@^18 --no-audit --no-fund

# Build
RUN npm run build

EXPOSE 3000
CMD ["npm","start","--","-p","3000"]
