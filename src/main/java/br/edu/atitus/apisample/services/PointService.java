package br.edu.atitus.apisample.services;

import br.edu.atitus.apisample.dtos.PointDTO;
import br.edu.atitus.apisample.entities.PointEntity;
import br.edu.atitus.apisample.entities.User;
import br.edu.atitus.apisample.repositories.PointRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class PointService {

    private final PointRepository pointRepository;

    public PointService(PointRepository pointRepository) {
        this.pointRepository = pointRepository;
    }

    // Regra: Salvar um novo ponto atrelando ao usuário logado
    public PointEntity save(PointDTO dto, User user) {
        PointEntity point = new PointEntity();
        point.setName(dto.getName());
        point.setDescription(dto.getDescription());
        point.setLatitude(dto.getLatitude());
        point.setLongitude(dto.getLongitude());
        point.setUser(user); // Vincula o usuário logado
        return pointRepository.save(point);
    }

    // Regra obrigatória: Listar apenas pontos do usuário logado
    public List<PointEntity> findByConnectedUser(User user) {
        return pointRepository.findByUser(user);
    }

    // Regra obrigatória: Atualização de Pontos (PUT) com validações
    public PointEntity update(UUID id, PointDTO dto, User user) throws Exception {
        // 1. Verificar se o ponto existe
        PointEntity point = pointRepository.findById(id)
                .orElseThrow(() -> new Exception("Ponto não encontrado com o ID fornecido."));

        // 2. Verificar se o ponto pertence ao usuário logado
        if (!point.getUser().getId().equals(user.getId())) {
            throw new Exception("Acesso negado: Este ponto não pertence ao seu usuário.");
        }

        // 3. Atualiza os dados com o mesmo DTO da criação
        point.setName(dto.getName());
        point.setDescription(dto.getDescription());
        point.setLatitude(dto.getLatitude());
        point.setLongitude(dto.getLongitude());

        return pointRepository.save(point);
    }
}