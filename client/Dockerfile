FROM node:20-alpine

WORKDIR /app

# Copy package files first (caching layer)
COPY package*.json ./

# Install frontend dependencies
RUN npm install

COPY . .

EXPOSE 3000

# --host is CRITICAL: makes Vite accessible outside container
CMD ["npm", "run", "dev", "--", "--host", "--port", "3000"]