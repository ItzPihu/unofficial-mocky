# Stage 1: Build the Scala Application
FROM hseeberger/scala-sbt:17.0.2_1.6.2_3.1.1 AS builder
WORKDIR /app
COPY . .
RUN sbt compile stage

# Stage 2: Production Execution Environment
FROM openjdk:17-slim
WORKDIR /app
# Copy the compiled staged binaries from the builder phase
COPY --from=builder /app/target/universal/stage ./
EXPOSE 8888

# Dynamically bind the application to Render's required port allocation
ENTRYPOINT ["./bin/mocky", "-Dhttp.port=${PORT:-8888}"]