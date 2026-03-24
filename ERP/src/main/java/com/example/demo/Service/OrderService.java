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
        return new PageResult<>(list, total, toPageRequest(req));
    }

    // OrderPageRequest → PageRequest 변환 (PageResult 재사용)
    private com.example.demo.Domain.PageRequest toPageRequest(OrderPageRequest req) {
        com.example.demo.Domain.PageRequest pr = new com.example.demo.Domain.PageRequest();
        pr.setPage(req.getPage());
        pr.setSize(req.getSize());
        return pr;
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
