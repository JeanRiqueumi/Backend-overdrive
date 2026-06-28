# Estágio 1: Compilação usando a imagem oficial que funciona
FROM maven:3-eclipse-temurin-25 AS build
WORKDIR /app

# Copia os arquivos do projeto e compila
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copia o jar final gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Define a porta dinâmica que o Render exige para o Spring Boot
ENV SERVER_PORT=${PORT:-8080}

# IMPORTANTE: Desativa a inicialização do banco caso as credenciais não estejam prontas
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration"]