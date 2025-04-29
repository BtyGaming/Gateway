# Build stage
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

# Copy pom first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline -Dmaven.repo.remote=false

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -Dmaven.test.skip=true

# Expose puerto 8080
EXPOSE 8080

# Run stage
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Copy jar from build stage
COPY --from=builder /build/target/Gateway-0.0.1-SNAPSHOT.jar app.jar

# Run application
CMD ["java", "-jar", "app.jar"]
