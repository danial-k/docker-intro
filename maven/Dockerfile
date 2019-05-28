# Multistage Docker image for building and distrubuting a sample JSP
# Java application.  Stage 1 uses Maven, stage 2 uses Jetty untime,
# with matching OpenJDK version

# Stage 1 - build release
FROM maven:3.6-jdk-8 AS maven
WORKDIR /app
COPY app .
# Publish source to output, used in next stage
RUN mvn clean package

# Stage 2 - create deployable image
FROM jetty:9.4-jre8 AS jetty
# Copy output from previous stage to this stage's workdir
COPY --from=maven app/target/app.war /var/lib/jetty/webapps
