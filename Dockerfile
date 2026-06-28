# Estágio de Compilação
FROM ubuntu:24.04 AS build
WORKDIR /app

# Instala o Java 25 (OpenJDK) e o Maven de forma automatizada
RUN apt-get update && apt-get install -y \
    openjdk-25-jdk \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Copia os arquivos do projeto e gera o build
COPY . .
RUN mvn clean package -DskipTests

# Estágio de Execução
FROM ubuntu:24.04
WORKDIR /app

# Instala apenas o Java necessário para rodar
RUN apt-get update && apt-get install -y \
    openjdk-25-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Copia o arquivo .jar gerado no estágio anterior
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]