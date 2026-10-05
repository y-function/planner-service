# syntax=docker/dockerfile:1.7

FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["nuget.config", "Directory.Build.props", "References.props", "./"]
COPY ["Y.Planner/Y.Planner.Api/Y.Planner.Api.csproj", "Y.Planner/Y.Planner.Api/"]
COPY ["Y.Planner/Y.Planner.Service/Y.Planner.Service.csproj", "Y.Planner/Y.Planner.Service/"]
COPY ["Y.Planner/Y.Planner.Service.Persistent/Y.Planner.Service.Persistent.csproj", "Y.Planner/Y.Planner.Service.Persistent/"]
RUN --mount=type=secret,id=nuget_username \
    --mount=type=secret,id=nuget_password \
    set -eu; \
    cp nuget.config /tmp/nuget.config; \
    trap 'rm -f /tmp/nuget.config' EXIT; \
    dotnet nuget update source github-y-function \
      --username "$(cat /run/secrets/nuget_username)" \
      --password "$(cat /run/secrets/nuget_password)" \
      --store-password-in-clear-text \
      --configfile /tmp/nuget.config >/dev/null; \
    dotnet restore "Y.Planner/Y.Planner.Api/Y.Planner.Api.csproj" --configfile /tmp/nuget.config
COPY . .
WORKDIR "/src/Y.Planner/Y.Planner.Api"
RUN dotnet build "./Y.Planner.Api.csproj" -c $BUILD_CONFIGURATION -f net10.0 -o /app/build --no-restore

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Y.Planner.Api.csproj" -c $BUILD_CONFIGURATION -f net10.0 -o /app/publish /p:UseAppHost=false --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Y.Planner.Api.dll"]
