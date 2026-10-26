FROM hseeberger/scala-sbt:17.0.2_1.6.2_3.1.1 AS builder
WORKDIR /app
COPY . .
RUN sbt clean stage

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN apk add --no-cache bash
COPY --from=builder /app/target/universal/stage ./
EXPOSE 8888
CMD ["sh", "-c", "bin/<name> -Dhttp.port=${PORT:-8888}"]