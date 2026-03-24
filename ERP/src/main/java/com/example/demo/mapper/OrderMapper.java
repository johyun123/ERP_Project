package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.Domain.Menu;
import com.example.demo.Domain.Order;
import com.example.demo.Domain.OrderItem;
import com.example.demo.Domain.OrderPageRequest;

@Mapper
public interface OrderMapper {
    List<Order>    selectOrderList();
    List<Order>    findByPage(OrderPageRequest req);   // 페이지네이션
    int            countAll(OrderPageRequest req);     // 전체 건수
    void           insertOrder(Order order);
    void           insertOrderItem(OrderItem item);
    List<Menu>     selectMenuList();
    void           updateOrderStatus(Order order);
    void           deleteOrder(Long id);
}