package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.Domain.Menu;
import com.example.demo.Domain.Order;
import com.example.demo.Domain.OrderItem;

@Mapper
public interface OrderMapper {
    List<Order> selectOrderList();
    void insertOrder(Order order);
    void insertOrderItem(OrderItem item);
    List<Menu> selectMenuList();

    // 상태 변경
    void updateOrderStatus(Order order);
    void deleteOrder(Long id);
    
}