package br.edu.atitus.apisample.dtos;

import java.math.BigDecimal;

public record PointDTO(double latitude, double longitude, String description) {
    public String getDescription() {
    }

    public Object getName() {
    }

    public BigDecimal getLatitude() {
    }

    public BigDecimal getLongitude() {
    }
}