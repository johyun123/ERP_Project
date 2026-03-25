package com.example.demo.mapper;

import com.example.demo.Domain.Ingredients;
import com.example.demo.Domain.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface IngredientsMapper {
    List<Ingredients> findAll();
    List<Ingredients> findByPage(PageRequest req);
    int               countAll(PageRequest req);
    Ingredients       findById(long id);
    List<Ingredients> findBySupplierId(@Param("supplierId") Long supplierId); // 거래처별 원재료
    void              insert(Ingredients i);
    void              update(Ingredients i);
    void              unlinkFromPurchaseItems(long id);
    void              delete(long id);
}
