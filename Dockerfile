# Estágio 1: Compilação
FROM maven:3-eclipse-temurin-25 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Define a porta exigida pelo Render
ENV SERVER_PORT=${PORT:-8080}
ENV PORT=${PORT:-8080}

# Desativa totalmente a inicialização de qualquer banco de dados para a API ligar pura
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration"]
