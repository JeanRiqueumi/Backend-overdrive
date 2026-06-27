package br.edu.atitus.apisample.repositories;

import br.edu.atitus.apisample.entities.PointEntity;
import br.edu.atitus.apisample.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PointRepository extends JpaRepository<PointEntity, UUID> {
    // Método necessário para buscar registros isolados por usuário
    List<PointEntity> findByUser(User user);
}

