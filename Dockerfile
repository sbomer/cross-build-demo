FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-cross-amd64 as builder

# Install .NET SDK
COPY --from=mcr.microsoft.com/dotnet/sdk:8.0-cbl-mariner2.0-amd64 /usr/share/dotnet /usr/share/dotnet
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && dotnet --info

COPY app/*.csproj app/*.config app/*.cs app/
WORKDIR app
RUN dotnet publish -r linux-x64 -o published -v:n


FROM ubuntu:16.04
COPY --from=builder /app/published/ /app/
WORKDIR /app
ENTRYPOINT ["./app"]
