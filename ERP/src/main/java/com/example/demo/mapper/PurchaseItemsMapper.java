package com.example.demo.mapper;

import com.example.demo.Domain.PurchaseItems;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface PurchaseItemsMapper {
    void insert(PurchaseItems item);
    List<Map<String, Object>> findByPurchaseId(long purchaseId);
}
