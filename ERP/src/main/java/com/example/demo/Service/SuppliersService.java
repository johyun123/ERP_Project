package com.example.demo.Service;

import com.example.demo.Domain.Ingredients;
import com.example.demo.Domain.Suppliers;
import com.example.demo.mapper.SuppliersMapper;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SuppliersService {

    private final SuppliersMapper mapper;

    public SuppliersService(SuppliersMapper mapper) {
        this.mapper = mapper;
    }

    public List<Suppliers> getAll() {
        return mapper.findAll();
    }

    public Suppliers getById(Long id) {
        return mapper.findById(id);
    }

    // 거래처별 담당 원재료 목록
    public List<Ingredients> getIngredientsBySupplier(Long supplierId) {
        return mapper.findIngredientsBySupplierId(supplierId);
    }

    public void register(Suppliers s) {
        mapper.insert(s);
    }

    public void modify(Suppliers s) {
        mapper.update(s);
    }

    public void remove(Long id) {
        mapper.delete(id);
    }
}
