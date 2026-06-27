package br.edu.atitus.apisample.controllers;

import br.edu.atitus.apisample.dtos.PointDTO;
import br.edu.atitus.apisample.entities.PointEntity;
import br.edu.atitus.apisample.services.PointService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.UUID;

// Define o caminho base e o mapeamento como REST
@RestController
@RequestMapping("/ws/point")
@CrossOrigin(origins = "*")
public class PointController {

    private final PointService pointService;

    public PointController(PointService pointService) {
        this.pointService = pointService;
    }

    // 1. GET /ws/point - Retorna todos os pontos
    @GetMapping
    public ResponseEntity<Object> findAll() {
        return ResponseEntity.ok(pointService.findAll());
    }

    // 2. POST /ws/point - Salva um novo ponto
    // 2. POST /ws/point - Salva um novo ponto
    @PostMapping
    public ResponseEntity<Object> save(@RequestBody PointDTO dto) {
        PointEntity point = new PointEntity();

        // Conversão manual de double (do DTO) para BigDecimal (da Entity)
        point.setLatitude(BigDecimal.valueOf(dto.latitude()));
        point.setLongitude(BigDecimal.valueOf(dto.longitude()));
        point.setDescription(dto.description());

        try {
            return ResponseEntity.ok(pointService.save(point));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // 3. DELETE /ws/point/{id} - Remove um ponto
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(@PathVariable UUID id) {
        try {
            pointService.deleteById(id);
            return ResponseEntity.ok("Ponto removido com sucesso");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}