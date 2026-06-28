# Estágio de Compilação
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copia os arquivos do projeto e compila usando o Maven que já vem instalado na imagem
COPY . .
RUN mvn clean package -DskipTests

# Estágio de Execução
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copia o arquivo .jar gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]