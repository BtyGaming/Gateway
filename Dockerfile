# Build stage
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

# Copy pom first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Copy jar from build stage
COPY --from=builder /build/target/*.jar app.jar

# Expose gateway port
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]