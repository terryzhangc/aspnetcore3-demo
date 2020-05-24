#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["aspnetcore3-demo.csproj", ""]
RUN dotnet restore "./aspnetcore3-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspnetcore3-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspnetcore3-demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnetcore3-demo.dll"]