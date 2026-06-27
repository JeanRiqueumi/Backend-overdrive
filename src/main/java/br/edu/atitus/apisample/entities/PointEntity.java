package br.edu.atitus.apisample.entities;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "tb_point") // Requisito 2: Nome da tabela
public class PointEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID) // Requisito 3: UUID gerado automaticamente
    private UUID id;

    // Requisito 3: Precisão para coordenadas reais com BigDecimal
    @Column(precision = 17, scale = 14, nullable = false)
    private BigDecimal latitude;

    @Column(precision = 17, scale = 14, nullable = false)
    private BigDecimal longitude;

    // Requisito 3: Descrição obrigatória com máximo de 250 caracteres
    @Column(nullable = false, length = 250)
    private String description;

    // Requisito 4: Relacionamento muitos-para-um com User
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Construtores
    public PointEntity() {}

    // Getters e Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }

    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}