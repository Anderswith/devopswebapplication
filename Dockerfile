# Set up the base image with aspnet runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER root  # Ensure we are root when building the image
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Set up the build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy the .csproj file and restore the dependencies
COPY DevOpsWebApplication/DevOpsWebApplication.csproj /src/DevOpsWebApplication/
RUN dotnet restore "/src/DevOpsWebApplication/DevOpsWebApplication.csproj"

# Copy the rest of the application code
COPY . /src/

# Build the project
WORKDIR "/src/DevOpsWebApplication"
RUN dotnet build "DevOpsWebApplication.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "DevOpsWebApplication.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Set up the final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DevOpsWebApplication.dll"]

