package br.edu.atitus.apisample.services;

import br.edu.atitus.apisample.entities.PointEntity;
import br.edu.atitus.apisample.entities.User;
import br.edu.atitus.apisample.repositories.PointRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
public class PointService {

    private final PointRepository pointRepository;

    // Injeção via construtor (Requisito 2)
    public PointService(PointRepository pointRepository) {
        this.pointRepository = pointRepository;
    }

    @Transactional
    public PointEntity save(PointEntity point) throws Exception {
        // Validações (Requisito 3)
        // Validações (Requisito 3)
        if (point == null) throw new Exception("Objeto nulo");
        if (point.getDescription() == null || point.getDescription().isEmpty())
            throw new Exception("Descrição obrigatória");

// Validação de latitude (-90 a 90)
        if (point.getLatitude().compareTo(new BigDecimal("-90")) < 0 ||
                point.getLatitude().compareTo(new BigDecimal("90")) > 0)
            throw new Exception("Latitude inválida");

// Validação de longitude (-180 a 180)
        if (point.getLongitude().compareTo(new BigDecimal("-180")) < 0 ||
                point.getLongitude().compareTo(new BigDecimal("180")) > 0)
            throw new Exception("Longitude inválida");

        // Associa ao usuário autenticado (Requisito 3 e 7)
        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        point.setUser(user);

        return pointRepository.save(point);
    }

    public List<PointEntity> findAll() {
        return pointRepository.findAll();
    }

    @Transactional
    public void deleteById(UUID id) throws Exception {
        PointEntity point = pointRepository.findById(id)
                .orElseThrow(() -> new Exception("Ponto não encontrado"));

        // Verifica se o ponto pertence ao usuário logado
        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (!point.getUser().getId().equals(user.getId())) {
            throw new Exception("Você não tem permissão para excluir este ponto");
        }

        pointRepository.deleteById(id);
    }
}