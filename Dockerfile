# Estágio de Compilação (Build)
FROM maven:3.9.9-amazoncorretto-25 AS build
WORKDIR /app
COPY . .
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# Estágio de Execução (Run)
FROM amazoncorretto:25-alpine
WORKDIR /app
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]