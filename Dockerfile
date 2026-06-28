# Estágio 1: Compilação
FROM ubuntu:24.04 AS build
WORKDIR /app


RUN apt-get update && apt-get install -y wget gnupg \
    && wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/24.04/prod noble main" | tee /etc/apt/sources.list.p/microsoft-prod.list \
    && apt-get update && apt-get install -y msopenjdk-25 maven


COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução
FROM ubuntu:24.04
WORKDIR /app


RUN apt-get update && apt-get install -y wget gnupg \
    && wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/24.04/prod noble main" | tee /etc/apt/sources.list.p/microsoft-prod.list \
    && apt-get update && apt-get install -y msopenjdk-25

# Copia o jar final gerado
COPY --from=build /app/target/api-sample-0.0.1-SNAPSHOT.jar app.jar

# Define a porta dinâmica que o Render exige
ENV SERVER_PORT=${PORT:-8080}

ENTRYPOINT ["java", "-jar", "app.jar"]