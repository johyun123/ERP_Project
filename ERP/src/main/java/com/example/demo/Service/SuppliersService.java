package com.example.demo.Service;

import com.example.demo.Domain.Suppliers;
import com.example.demo.mapper.SuppliersMapper;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SuppliersService {

    private final SuppliersMapper suppliersMapper;

    public SuppliersService(SuppliersMapper suppliersMapper) {
        this.suppliersMapper = suppliersMapper;
    }

    public List<Suppliers> getAll() { return suppliersMapper.findAll(); }
    public Suppliers getById(long id) { return suppliersMapper.findById(id); }
    public void register(Suppliers suppliers) { suppliersMapper.insert(suppliers); }
    public void modify(Suppliers suppliers) { suppliersMapper.update(suppliers); }
    public void remove(long id) { suppliersMapper.delete(id); }
}