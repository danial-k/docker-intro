##############################################################
# Stage 1 - Build with node
##############################################################
# Define Node Version as an argument that may be set externally
# ARG before FROM can only be used in FROM statement, not after
# ARGs must be declared after FROM to use in remainder of build
ARG NODE_TAG
ARG API_URL
ARG NGINX_TAG
# Stage 1 build project
FROM node:${NODE_TAG} AS node
# Set environment variables from build args
ARG API_URL
ENV REACT_APP_API_URL=${API_URL}
# Set working directory during build
WORKDIR /app
# Copy source files (excluding .dockerignore)
COPY . .
# Install development dependencies required to build
RUN npm install
# Build project to produce static assets
RUN npm run build

##############################################################
# Stage 2 - Produce nginx output image
##############################################################
# External Args for nginx version (independent of first stage)
ARG NGINX_TAG
# Use nginx base image
FROM nginx:${NGINX_TAG}
# Copy built output from previous stage to output image
COPY --from=node /app/build /usr/share/nginx/html
