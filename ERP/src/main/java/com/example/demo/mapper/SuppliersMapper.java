package com.example.demo.mapper;

import com.example.demo.Domain.Suppliers;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface SuppliersMapper {
    List<Suppliers> findAll();
    Suppliers findById(long id);
    int insert(Suppliers suppliers);
    int update(Suppliers suppliers);
    int delete(long id);
}