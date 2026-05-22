# Etapa 1: Build con Maven
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -q
COPY src ./src
RUN ./mvnw package -DskipTests -q

# Etapa 2: Imagen final liviana
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Puerto expuesto (Railway lo detecta automáticamente con $PORT)
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
