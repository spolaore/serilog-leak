#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["leaking-app.csproj", "."]
RUN dotnet restore "leaking-app.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "leaking-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "leaking-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "leaking-app.dll"]
