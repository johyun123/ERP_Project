package com.example.demo.Service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.mapper.OrderMapper;
import com.example.demo.Domain.Menu;
import com.example.demo.Domain.Order;
import com.example.demo.Domain.OrderItem;

@Service
public class OrderService {

    private final OrderMapper orderMapper;

    OrderService(OrderMapper orderMapper) {
        this.orderMapper = orderMapper;
    }

    public List<Order> getOrderList() {
        return orderMapper.selectOrderList();
    }

    public List<Menu> getMenuList() {
        return orderMapper.selectMenuList();
    }

    @Transactional
    public void insertOrder(Order order) {
        orderMapper.insertOrder(order);
        if (order.getItems() != null) {
            for (OrderItem item : order.getItems()) {
                item.setOrderId(order.getId());
                orderMapper.insertOrderItem(item);
            }
        }
    }

    // 상태 변경
    public void updateOrderStatus(Long id, String status) {
        Order order = new Order();
        order.setId(id);
        order.setStatus(status);
        orderMapper.updateOrderStatus(order);
    }

    public void deleteOrder(Long id) {
        orderMapper.deleteOrder(id);
    }
}