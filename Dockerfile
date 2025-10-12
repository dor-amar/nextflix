# --------------------------------------------------------
# STAGE 1: Build (using a Debian base)
# --------------------------------------------------------
FROM node:18-slim AS builder
WORKDIR /app

# Install dependencies (cache-friendly layer)
COPY package*.json ./
RUN npm install --no-audit --no-fund

# Copy all application source code
COPY . .

# Ensure required TypeScript version is installed for the project
RUN npm i -D typescript@^5.4 --no-audit --no-fund

# FIX 1: Create next.config.js to bypass the build-time checks (as requested)
# FIX 2: Disable Next.js image optimization (unoptimized: true) to bypass the WASM error.
RUN cat > next.config.js <<'EOF'
module.exports = {
  typescript: { ignoreBuildErrors: true },
  eslint: { ignoreDuringBuilds: true },
  images: { unoptimized: true }, 
};
EOF

# Build the application
# FIX 3: Use the legacy provider flag to resolve the OpenSSL issue (ERR_OSSL_EVP_UNSUPPORTED)
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build

# --------------------------------------------------------
# STAGE 2: Production Runtime (Smaller Image)
# --------------------------------------------------------
# Use a separate, even smaller image for the final runtime
FROM node:18-slim 
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Next.js defaults to port 3000
EXPOSE 3000

# Start the application
CMD ["npm","start"]