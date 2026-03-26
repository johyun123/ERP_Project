package com.example.demo.mapper;

import com.example.demo.Domain.Ingredients;
import com.example.demo.Domain.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface IngredientsMapper {
    List<Ingredients> findAll();
    List<Ingredients> findByPage(PageRequest req);  // 페이지네이션
    int countAll(PageRequest req);                  // 전체 건수
    Ingredients findById(long id);
    void insert(Ingredients i);
    void update(Ingredients i);
    void delete(long id);
}