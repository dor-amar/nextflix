FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --no-audit --no-fund
COPY . .
RUN npm i -D typescript@^5.4 @types/node@^18 --no-audit --no-fund
RUN npm run build
EXPOSE 3000
CMD ["npm","start","--","-p","3000"]
