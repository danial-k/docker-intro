# Multistage Docker image for building and distrubuting a sample .net
# ASP C# application.  Stage 1 uses SDK, stage 2 uses ASP Runtime

# Stage 1 - build release
# For dotnet options see https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS sdk
WORKDIR /app
COPY app /app
# Publish source to output, used in next stage
RUN dotnet publish -c Release -o published

# Stage 2 - create deployable image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
# Set working directory
WORKDIR /app
# Copy output from previous stage to this stage's workdir
COPY --from=sdk app/published .
CMD ["dotnet", "app.dll"]
