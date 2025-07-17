# syntax=docker/dockerfile:1

# Stage 1: Frontend Build (React)
FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy package.json and package-lock.json first to leverage Docker cache
# This ensures npm install is only run if dependencies change
COPY todo/package.json todo/package-lock.json ./

RUN npm install

# Copy the rest of the frontend source code
COPY todo/ ./

# Build the React application.
# IMPORTANT: Adjust 'dist' below if your React build outputs to a different directory (e.g., 'build')
RUN npm run build

# Stage 2: Backend Build (Node.js)
FROM node:20-alpine AS backend-builder

WORKDIR /app/backend

# Copy package.json and package-lock.json first to leverage Docker cache
COPY backend/package.json backend/package-lock.json ./

RUN npm install

# Copy the rest of the backend source code
COPY backend/ ./

# Stage 3: Serve Frontend with Nginx
FROM nginx:stable-alpine AS frontend-nginx

# Copy the built React app from the frontend-builder stage to Nginx's web root
# Remember to adjust 'dist' if your React project builds to a different directory
COPY --from=frontend-builder /app/frontend/dist /usr/share/nginx/html

EXPOSE 80

# Stage 4: Run Backend (Node.js)
FROM node:20-alpine AS backend-final

WORKDIR /app

# Copy the backend code and installed dependencies from the backend-builder stage
COPY --from=backend-builder /app/backend ./backend

WORKDIR /app/backend # Change directory into the backend folder for running

EXPOSE 3001

# Command to run your Node.js backend.
# Ensure your backend/package.json has a "start" script defined.
CMD ["npm", "start"]