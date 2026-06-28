package br.edu.atitus.apisample.dtos;

public record PointDTO(
        String name,
        String description,
        double latitude,
        double longitude
) {
    // Como é um record, o Java cria os métodos de leitura automaticamente!
}