# Estágio 1: Compilação usando a imagem oficial que já vem com Maven e Java 25 juntos
FROM maven:3-eclipse-temurin-25 AS build
WORKDIR /app

# Copia os arquivos do projeto e compila
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução usando a imagem leve do Java 25
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copia o jar final gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Define a porta dinâmica que o Render exige para o Spring Boot
ENV SERVER_PORT=${PORT:-8080}

ENTRYPOINT ["java", "-jar", "app.jar"]