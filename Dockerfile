FROM hseeberger/scala-sbt:17.0.2_1.6.2_3.1.1 AS builder
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