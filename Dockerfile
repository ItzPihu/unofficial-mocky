FROM eclipse-temurin:17-jdk AS builder
ARG SBT_VERSION=1.9.9
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && update-ca-certificates \
    && curl -fsSL https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xz -C /opt \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/opt/sbt/bin:${PATH}"
WORKDIR /app
COPY server ./server
WORKDIR /app/server
RUN sbt clean stage

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN apk add --no-cache bash
COPY --from=builder /app/server/target/universal/stage ./
EXPOSE 10000
CMD ["sh", "-c", "exec $(ls bin/* | grep -v '\\.bat$' | head -n 1)"]