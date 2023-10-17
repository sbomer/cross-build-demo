FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-cross-amd64 as builder

# Install .NET SDK
ENV DOTNET_SDK_VERSION=8.0.100-rc.2.23472.8
RUN curl -fSL --output dotnet.tar.gz https://dotnetbuilds.azureedge.net/public/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='475723ba65bd675846c732267144ecc0d4f4d4ee8bdc38140f8f9b95bc2a0b38a3de7340de3948fbf58c7f59354c22f778506145d8fda5788813967aebffd118' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar xf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && dotnet help

COPY app/*.csproj app/*.config app/*.cs app/
WORKDIR app
RUN dotnet publish -r linux-amd64 -o published -v:n


FROM ubuntu:16.04
COPY --from=builder /app/published/ /app/
WORKDIR /app
ENTRYPOINT ["./app"]
