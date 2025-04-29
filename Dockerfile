# Build stage
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]