# Stage 1 Build with gcc compiler
FROM gcc:9.1 AS gcc
# Set working directory
WORKDIR /app
# Copy source code (excluding items in .dockerignore)
COPY ./app .
# Install JRE for gradle to function
RUN apt-get update
RUN apt-get install openjdk-8-jre -y
# Build with gcc using Gradle wrapper
RUN ./gradlew build
RUN ls -lah /app/build/exe/main/debug/app

# Stage 2 - Deploy to debian linux container
FROM debian:buster-slim
WORKDIR /app
COPY --from=gcc /app/build/exe/main/debug/app ./app
RUN ls -lah
CMD ["./app"]
