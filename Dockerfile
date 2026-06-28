# Estágio 1: Compilação usando Java 25
FROM maven:3.9.9-eclipse-temurin-25 AS build
WORKDIR /app

# Copia os arquivos e compila usando o Maven nativo com Java 25
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução usando o mesmo Java 25
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copia o arquivo gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Configura o Spring Boot para usar a porta dinâmica que o Render exige
ENV SERVER_PORT=${PORT:-8080}

ENTRYPOINT ["java", "-jar", "app.jar"]