# Estágio 1: Compilação usando uma imagem estável que EXISTE
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copia os arquivos e compila usando o Maven estável
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução usando a imagem oficial do Java 21
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copia o arquivo gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Configura a porta dinâmica exigida pelo Render
ENV SERVER_PORT=${PORT:-8080}

ENTRYPOINT ["java", "-jar", "app.jar"]