# Imagen base
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Copia los archivos del proyecto a la imagen
WORKDIR /app
COPY . ./

# Restaura las dependencias y compila la aplicación
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Crea la imagen final y copia los archivos publicados en ella
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expone el puerto que escucha la aplicación
EXPOSE 80
EXPOSE 3000

# Inicia la aplicación al ejecutar la imagen
ENTRYPOINT ["dotnet", "ToDoGrpc.dll", "--urls", "http://0.0.0.0:3000"]