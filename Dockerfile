FROM alpine:3.24.1


ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

RUN set -eux; \
    apk add --no-cache curl tar gzip; \
    ARCH="$(apk --print-arch)"; \
    case "${ARCH}" in \
        x86_64)  BINARY_URL="https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_x64_alpine-linux_hotspot_25.0.2_10.tar.gz" ;; \
        aarch64) BINARY_URL="https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_aarch64_alpine-linux_hotspot_25.0.2_10.tar.gz" ;; \
        *) echo "Unsupportete Architektur: ${ARCH}"; exit 1 ;; \
    esac; \
    mkdir -p "$JAVA_HOME"; \
    curl -LfsSo /tmp/openjdk.tar.gz "${BINARY_URL}"; \
    tar -xzf /tmp/openjdk.tar.gz -C "$JAVA_HOME" --strip-components=1; \
    rm /tmp/openjdk.tar.gz; \
    apk del curl tar gzip

RUN apk add --no-cache graphviz bash ca-certificates java-cacerts

RUN java -version

CMD ["/bin/bash"]