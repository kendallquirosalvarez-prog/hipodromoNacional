package com.example.hipodromo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.hipodromo.model.Barrio;

@Repository
public interface BarrioRepository extends JpaRepository<Barrio, Integer> {
}