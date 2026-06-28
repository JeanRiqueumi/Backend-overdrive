# =================================================================
# STAGE 1: FASE DE CONSTRUÇÃO (BUILD)
# =================================================================
FROM maven:3-eclipse-temurin-25 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# =================================================================
# STAGE 2: FASE DE PRODUÇÃO (FINAL)
# =================================================================
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copia o arquivo gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Porta dinâmica do Render
ENV SERVER_PORT=${PORT:-8080}

# COMANDO FINAL: Injeta um banco em memória temporário para os Repositórios funcionarem perfeitamente!
CMD ["java", "-jar", "app.jar", "--spring.datasource.url=jdbc:h2:mem:testdb", "--spring.datasource.driver-class-name=org.h2.Driver", "--spring.datasource.username=sa", "--spring.datasource.password=", "--spring.jpa.database-platform=org.hibernate.dialect.H2Dialect"]