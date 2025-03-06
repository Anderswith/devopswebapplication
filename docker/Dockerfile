# Use the official ASP.NET 8.0 image as a base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK 8.0 image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DevOpsWebApplication.csproj", "DevOpsWebApplication/"]
RUN dotnet restore "DevOpsWebApplication/DevOpsWebApplication.csproj"
COPY . .
WORKDIR "/src/DevOpsWebApplication"
RUN dotnet build "DevOpsWebApplication.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "DevOpsWebApplication.csproj" -c Release -o /app/publish

# Final stage - copy the published app to the base image and set the entry point
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DevOpsWebApplication.dll"]

