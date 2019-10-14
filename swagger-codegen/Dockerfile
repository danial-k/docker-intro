FROM adoptopenjdk:8u222-b10-jre-openj9-0.15.1-bionic

ARG SWAGGER_CODEGEN_VERSION=3.0.11

RUN mkdir -p /opt/swagger-codegen-cli

RUN curl -L \
    -o /opt/swagger-codegen-cli/swagger-codegen-cli.jar \
    https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/${SWAGGER_CODEGEN_VERSION}/swagger-codegen-cli-${SWAGGER_CODEGEN_VERSION}.jar

# Language/framework environment variable.
# Start this container with a different value to generate different languages/frameworks
ENV SWAGGER_LANG=spring

ARG OUTPUT_PATH=/output/${SWAGGER_LANG}

ENTRYPOINT ["java", "-jar", "/opt/swagger-codegen-cli/swagger-codegen-cli.jar"]

# Container will start up displaying the Swagger Codegen CLI version
# To use additional functionality, supply additional commands on container startup
CMD [ "version" ]
