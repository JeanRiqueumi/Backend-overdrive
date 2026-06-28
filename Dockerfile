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
COPY --from=builder /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Porta dinâmica do Render
ENV SERVER_PORT=${PORT:-8080}

# COMANDO FINAL: Desativa o banco para a API ligar direto e te dar o link do trabalho!
CMD ["java", "-jar", "app.jar", "--spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration"]