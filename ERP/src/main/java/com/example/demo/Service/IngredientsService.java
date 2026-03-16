package com.example.demo.Service;

import com.example.demo.Domain.Ingredients;
import com.example.demo.mapper.IngredientsMapper;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class IngredientsService {

    private final IngredientsMapper ingredientsMapper;

    // 생성자 주입
    public IngredientsService(IngredientsMapper ingredientsMapper) {
        this.ingredientsMapper = ingredientsMapper;
    }

    public List<Ingredients> getAll() {
        return ingredientsMapper.findAll();
    }

    public Ingredients getById(long id) {
        return ingredientsMapper.findById(id);
    }

    public void register(Ingredients ingredients) {
        ingredientsMapper.insert(ingredients);
    }

    public void modify(Ingredients ingredients) {
        ingredientsMapper.update(ingredients);
    }

    public void remove(long id) {
        ingredientsMapper.delete(id);
    }
}