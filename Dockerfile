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

# Copia o arquivo gerado da fase anterior
COPY --from=builder /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Configurações de rede exigidas pelo Render
ENV SERVER_PORT=${PORT:-8080}
ENV PORT=${PORT:-8080}

# COMANDO FINAL: Força uma URL genérica e desativa a validação do Hibernate de vez
CMD ["java", "-jar", "app.jar", "--spring.datasource.url=jdbc:mock://localhost/db", "--spring.jpa.properties.hibernate.temp.use_jdbc_metadata_defaults=false", "--spring.jpa.database-platform=org.hibernate.dialect.H2Dialect"]