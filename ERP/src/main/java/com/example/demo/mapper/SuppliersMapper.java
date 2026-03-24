package com.example.demo.mapper;

import com.example.demo.Domain.Suppliers;
import com.example.demo.Domain.Ingredients;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface SuppliersMapper {
    List<Suppliers>    findAll();
    Suppliers          findById(@Param("id") Long id);
    List<Ingredients>  findIngredientsBySupplierId(@Param("supplierId") Long supplierId);
    void               insert(Suppliers s);
    void               update(Suppliers s);
    void               delete(@Param("id") Long id);
}
