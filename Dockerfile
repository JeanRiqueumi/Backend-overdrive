# Estágio de Compilação (Build)
FROM amazoncorretto:25-alpine AS build
WORKDIR /app
# Instala o bash que o mvnw precisa para rodar no Alpine Linux
RUN apk add --no-cache bash
COPY . .
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# Estágio de Execução (Run)
FROM amazoncorretto:25-alpine
WORKDIR /app
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]