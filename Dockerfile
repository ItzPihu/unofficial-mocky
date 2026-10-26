# Stage 1: Build the Scala Application into a Fat JAR
FROM hseeberger/scala-sbt:17.0.2_1.6.2_3.1.1 AS builder
WORKDIR /app
COPY . .
RUN sbt assembly

# Stage 2: Production Execution Environment
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copy the compiled JAR file from the builder phase
COPY --from=builder /app/target/scala-*/*.jar ./mocky-app.jar
EXPOSE 8888

# Run the standalone JAR directly with the dynamic port configuration
ENTRYPOINT ["java", "-Dhttp.port=${PORT:-8888}", "-jar", "mocky-app.jar"]