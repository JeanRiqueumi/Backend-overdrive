# Estágio de Compilação
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app

# Instala o Maven manualmente
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copia os arquivos do projeto e gera o build
COPY . .
RUN mvn clean package -DskipTests

# Estágio de Execução
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copia o arquivo .jar gerado no estágio anterior
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]