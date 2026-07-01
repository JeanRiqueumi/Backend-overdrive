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

# Copia o arquivo compilado com sucesso
COPY --from=builder /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Configurações obrigatórias de rede do Render
ENV SERVER_PORT=${PORT:-8080}
ENV PORT=${PORT:-8080}

# COMANDO FINAL: Ativa o perfil de teste nativo do Spring que ignora bancos externos
CMD ["java", "-jar", "app.jar", "--spring.profiles.active=test"]