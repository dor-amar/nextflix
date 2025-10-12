# ---- Build stage ----
FROM node:20-alpine AS build
WORKDIR /app

# Install deps
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source and build
COPY . .
# If your app needs public runtime vars at build time, pass them as build args
# ARG NEXT_PUBLIC_BASE_URL
# ENV NEXT_PUBLIC_BASE_URL=$NEXT_PUBLIC_BASE_URL
RUN yarn build

# ---- Runtime stage ----
FROM node:20-alpine
ENV NODE_ENV=production
WORKDIR /app

# Copy the built app and only the minimal runtime deps
COPY --from=build /app ./

# Expose Next.js port
EXPOSE 3000

# Start Next.js in production
CMD ["yarn","start","-p","3000"]
