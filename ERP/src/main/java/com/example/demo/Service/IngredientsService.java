package com.example.demo.Service;

import com.example.demo.Domain.Ingredients;
import com.example.demo.Domain.PageRequest;
import com.example.demo.Domain.PageResult;
import com.example.demo.mapper.IngredientsMapper;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class IngredientsService {

    private final IngredientsMapper mapper;

    public IngredientsService(IngredientsMapper mapper) {
        this.mapper = mapper;
    }

    public List<Ingredients> getAll() {
        return mapper.findAll();
    }

    public PageResult<Ingredients> getByPage(PageRequest req) {
        List<Ingredients> list  = mapper.findByPage(req);
        int               total = mapper.countAll(req);
        return new PageResult<>(list, total, req);
    }

    public Ingredients getById(long id) {
        return mapper.findById(id);
    }

    public List<Ingredients> getBySupplierId(Long supplierId) {
        return mapper.findBySupplierId(supplierId);
    }

    public void register(Ingredients i) {
        mapper.insert(i);
    }

    public void modify(Ingredients i) {
        mapper.update(i);
    }

    public void remove(long id) {
        mapper.delete(id);
    }
}
