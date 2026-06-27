package br.edu.atitus.apisample.controllers;

import br.edu.atitus.apisample.dtos.PointDTO;
import br.edu.atitus.apisample.entities.PointEntity;
import br.edu.atitus.apisample.entities.User;
import br.edu.atitus.apisample.services.PointService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/ws/point")
public class PointController {

    private final PointService pointService;

    public PointController(PointService pointService) {
        this.pointService = pointService;
    }

    @PostMapping
    public ResponseEntity<PointEntity> createPoint(@RequestBody PointDTO dto, @AuthenticationPrincipal User user) {
        PointEntity newPoint = pointService.save(dto, user);
        return ResponseEntity.status(201).body(newPoint);
    }

    // REQUISITO: Listar apenas pontos do usuário logado
    @GetMapping
    public ResponseEntity<List<PointEntity>> getPointsFromUser(@AuthenticationPrincipal User user) {
        List<PointEntity> points = pointService.findByConnectedUser(user);
        return ResponseEntity.ok(points);
    }


    @PutMapping("/{id}")
    public ResponseEntity<PointEntity> updatePoint(
            @PathVariable UUID id,
            @RequestBody PointDTO dto,
            @AuthenticationPrincipal User user) throws Exception {

        PointEntity updatedPoint = pointService.update(id, dto, user);
        return ResponseEntity.ok(updatedPoint);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleException(Exception ex) {
        return ResponseEntity.badRequest().body(ex.getMessage());
    }
}