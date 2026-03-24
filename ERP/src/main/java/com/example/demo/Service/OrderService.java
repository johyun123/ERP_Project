package com.example.demo.Service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.mapper.OrderMapper;
import com.example.demo.Domain.Menu;
import com.example.demo.Domain.Order;
import com.example.demo.Domain.OrderItem;
import com.example.demo.Domain.OrderPageRequest;
import com.example.demo.Domain.PageResult;

@Service
public class OrderService {

    private final OrderMapper orderMapper;

    OrderService(OrderMapper orderMapper) {
        this.orderMapper = orderMapper;
    }

    public List<Order> getOrderList() {
        return orderMapper.selectOrderList();
    }

    public PageResult<Order> getByPage(OrderPageRequest req) {
        List<Order> list  = orderMapper.findByPage(req);
        int         total = orderMapper.countAll(req);
        // OrderPageRequest가 PageRequest를 상속하므로 바로 넘길 수 있음
        return new PageResult<>(list, total, req);
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