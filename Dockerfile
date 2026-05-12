FROM node:20-alpine

WORKDIR /app

# Copy package files first (caching layer)
COPY package*.json ./

# Install backend dependencies
RUN npm install

# Copy backend source code
# node_modules and client/ are excluded via .dockerignore
COPY . .

EXPOSE 7777

CMD ["node", "server.js"]