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

# CORRIGIDO: Agora aponta exatamente para "builder"
COPY --from=builder /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Configurações de rede exigidas pelo Render
ENV SERVER_PORT=${PORT:-8080}
ENV PORT=${PORT:-8080}

# COMANDO FINAL: Engana o Hibernate para ele não travar e iniciar a aplicação limpa
CMD ["java", "-jar", "app.jar", "--spring.datasource.url=jdbc:postgresql://localhost:5432/fakedb", "--spring.datasource.username=postgres", "--spring.datasource.password=postgres", "--spring.jpa.hibernate.ddl-auto=none"]