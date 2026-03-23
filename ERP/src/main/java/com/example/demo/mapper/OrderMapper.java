package com.example.demo.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.demo.Domain.Menu;
import com.example.demo.Domain.Order;
import com.example.demo.Domain.OrderItem;
import com.example.demo.Domain.PageRequest;

@Mapper
public interface OrderMapper {
    List<Order> selectOrderList();
    List<Order> selectOrderByPage(PageRequest req);
    int countOrder(PageRequest req);
    void insertOrder(Order order);
    void insertOrderItem(OrderItem item);
    List<Menu> selectMenuList();
    void updateOrderStatus(Order order);
    void deleteOrder(Long id);
}