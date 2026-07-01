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

# Copia o ficheiro jar compilado
COPY --from=builder /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Configurações de rede obrigatórias do Render
ENV SERVER_PORT=${PORT:-8080}
ENV PORT=${PORT:-8080}

# COMANDO SEGURO: Ignora a falta de base de dados no arranque e inicia o Tomcat
CMD ["java", "-jar", "app.jar", "--spring.datasource.url=jdbc:postgresql://localhost:5432/fakedb", "--spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect", "--spring.jpa.properties.hibernate.temp.use_jdbc_metadata_defaults=false", "--spring.jpa.hibernate.ddl-auto=none", "--spring.datasource.hikari.initialization-fail-timeout=-1"]