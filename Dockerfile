# Estágio de Compilação
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app

# Copia todos os arquivos do projeto para o container
COPY . .

# Executa o Maven Wrapper direto pelo Java (evita problemas com formatação do Windows)
RUN java .mvn/wrapper/MavenWrapperDownloader.java || true
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# Estágio de Execução
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copia o arquivo .jar gerado no estágio anterior
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]