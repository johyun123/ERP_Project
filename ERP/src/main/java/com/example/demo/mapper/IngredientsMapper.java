package com.example.demo.mapper;

import com.example.demo.Domain.Ingredients;
import com.example.demo.Domain.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface IngredientsMapper {
    List<Ingredients> findAll();
    List<Ingredients> findByPage(PageRequest req);
    int countAll(PageRequest req);
    Ingredients findById(long id);
    void insert(Ingredients i);
    void update(Ingredients i);
    void delete(long id);

    // [버그수정 2] 발주 이력 체크 — purchase_items 참조 건수 조회
    int countPurchaseItemsByIngredientId(long id);
}