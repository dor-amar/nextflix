FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install --no-audit --no-fund

COPY . .
# 👇 this single line fixes TS5023
RUN npm i -D typescript@^5.4 --no-audit --no-fund

RUN npm run build
EXPOSE 3000
CMD ["npm","start","--","-p","3000"]
