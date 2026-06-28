package br.edu.atitus.apisample.services;

import br.edu.atitus.apisample.dtos.PointDTO;
import br.edu.atitus.apisample.entities.PointEntity;
import br.edu.atitus.apisample.entities.User;
import br.edu.atitus.apisample.repositories.PointRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
public class PointService {

    private final PointRepository pointRepository;

    public PointService(PointRepository pointRepository) {
        this.pointRepository = pointRepository;
    }

    // Cria um novo ponto e vincula ao usuário logado
    public PointEntity save(PointDTO dto, User user) {
        PointEntity point = new PointEntity();
        point.setName(dto.name());
        point.setDescription(dto.description());
        point.setLatitude(BigDecimal.valueOf(dto.latitude()));
        point.setLongitude(BigDecimal.valueOf(dto.longitude()));
        point.setUser(user);
        return pointRepository.save(point);
    }

    // REQUISITO: Listar apenas pontos do usuário autenticado
    public List<PointEntity> findByConnectedUser(User user) {
        return pointRepository.findByUser(user);
    }

    // REQUISITO: Atualização de Pontos (PUT) com regras obrigatórias
    public PointEntity update(UUID id, PointDTO dto, User user) throws Exception {
        // 1. Verificar se o ponto existe
        PointEntity point = pointRepository.findById(id)
                .orElseThrow(() -> new Exception("Ponto não encontrado com o ID fornecido."));

        // 2. Verificar se o ponto pertence ao usuário logado
        if (!point.getUser().getId().equals(user.getId())) {
            throw new Exception("Acesso negado: Este ponto não pertence ao seu usuário.");
        }

        // 3. Atualiza os dados usando as propriedades corretas do record
        point.setName(dto.name());
        point.setDescription(dto.description());
        point.setLatitude(BigDecimal.valueOf(dto.latitude()));
        point.setLongitude(BigDecimal.valueOf(dto.longitude()));

        return pointRepository.save(point);
    }
}