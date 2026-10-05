FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Y.Planner/Y.Planner.Api/Y.Planner.Api.csproj", "Y.Planner/Y.Planner.Api/"]
RUN dotnet restore "Y.Planner/Y.Planner.Api/Y.Planner.Api.csproj"
COPY . .
WORKDIR "/src/Y.Planner/Y.Planner.Api"
RUN dotnet build "./Y.Planner.Api.csproj" -c $BUILD_CONFIGURATION -f net10.0 -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Y.Planner.Api.csproj" -c $BUILD_CONFIGURATION -f net10.0 -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Y.Planner.Api.dll"]
