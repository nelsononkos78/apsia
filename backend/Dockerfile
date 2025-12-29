FROM node:20-alpine

WORKDIR /app

# Install Python and build dependencies for native modules
RUN apk add --no-cache python3 make g++

COPY package*.json ./

# Install dependencies (including devDependencies for build and migrations)
RUN npm install

COPY . .

# Build TypeScript
RUN npm run build

EXPOSE 4000

CMD ["npm", "start"]
