FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 3000

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
RUN dotnet restore "ToDoGrpc.csproj"
COPY . .
WORKDIR /src
RUN dotnet build "ToDoGrpc.csproj" -c ${BUILD_CONFIGURATION} -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ToDoGrpc.csproj" -c ${BUILD_CONFIGURATION} -o /app/publish

FROM base AS final
WORKDIR /app 
COPY --from=publish /app/publish .



ENTRYPOINT ["dotnet", "ToDoGrpc.dll"]