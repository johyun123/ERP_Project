package com.example.demo.mapper;

import com.example.demo.Domain.Purchases;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface PurchasesMapper {
    List<Purchases> findAll();
    Purchases findById(long id);
    int insert(Purchases purchases);
    int update(Purchases purchases);
    int cancel(long id);
}
