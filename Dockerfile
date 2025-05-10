# Use the official Node.js image as the base image
FROM node:18-bullseye

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
# Add build dependencies for better-sqlite3
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && npm install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the application source code
COPY . .

# Rebuild better-sqlite3 to ensure compatibility
RUN npm rebuild better-sqlite3 --build-from-source

# Build the application
RUN npm run build

# Expose the port Strapi runs on
EXPOSE 1337

# Set the command to run the application
CMD ["npm", "run", "start"]
