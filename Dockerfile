# Estágio 1: Compilação
FROM maven:3-eclipse-temurin-25 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Define a porta do Render
ENV SERVER_PORT=${PORT:-8080}

# Força a aplicação a usar um banco em memória temporário para ligar com sucesso
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.datasource.url=jdbc:h2:mem:testdb", "--spring.datasource.driver-class-name=org.h2.Driver", "--spring.jpa.database-platform=org.hibernate.dialect.H2Dialect"]