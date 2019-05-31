# Multistage Docker image for building and distrubuting a sample Thorntail
# Java application.  Stage 1 uses Maven, stage 2 uses matching JRE,

# Stage 1 - build release
FROM maven:3.6-jdk-8 AS maven
WORKDIR /app
COPY app .
# Publish source to output, used in next stage
RUN mvn clean package

# Stage 2 - create deployable image
FROM openjdk:8-jre AS jre
# Set working directory
WORKDIR /app
# Copy output from previous stage to this stage's workdir
# Note: thorntail appends -thorntail to the file name for uberjars
COPY --from=maven app/target/example-thorntail.jar .
CMD ["java", "-jar", "/app/example-thorntail.jar"]
