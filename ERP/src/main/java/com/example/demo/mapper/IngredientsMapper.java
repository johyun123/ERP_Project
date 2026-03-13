package com.example.demo.mapper;

import com.example.demo.Domain.Ingredients;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface IngredientsMapper {

    // 전체 목록 조회
    List<Ingredients> findAll();

    // 단건 조회
    Ingredients findById(long id);

    // 등록
    int insert(Ingredients ingredients);

    // 수정
    int update(Ingredients ingredients);

    // 삭제
    int delete(long id);
}
