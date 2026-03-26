package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Service.OrderService;
import com.example.demo.Domain.Order;
import com.example.demo.Domain.OrderItem;

@Controller
public class OrderController {

    private final OrderService orderService;

    OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    // 주문 목록 페이지
    @GetMapping("/order")
    public String orderPage(Model model) {
        model.addAttribute("orderList", orderService.getOrderList());
        model.addAttribute("menuList",  orderService.getMenuList());
        return "Order/OrderDetail";
    }

    // 주문 등록
    @PostMapping("/orderAdd")
    public String addOrder(
            @RequestParam String  orderNo,
            @RequestParam int     totalAmount,
            @RequestParam int     discountAmount,
            @RequestParam int     finalAmount,
            @RequestParam String  paymentType,
            @RequestParam(required = false) String note,
            @RequestParam(value = "menuId",    required = false) List<Long>    menuIds,
            @RequestParam(value = "qty",       required = false) List<Integer> qtys,
            @RequestParam(value = "unitPrice", required = false) List<Integer> unitPrices) {

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setTotalAmount(totalAmount);
        order.setDiscountAmount(discountAmount);
        order.setFinalAmount(finalAmount);
        order.setPaymentType(paymentType);
        order.setStatus("대기");
        order.setNote(note);

        List<OrderItem> items = new ArrayList<>();
        if (menuIds != null) {
            for (int i = 0; i < menuIds.size(); i++) {
                OrderItem item = new OrderItem();
                item.setMenuId(menuIds.get(i));
                item.setQty(qtys.get(i));
                item.setUnitPrice(unitPrices.get(i));
                item.setSubtotal(qtys.get(i) * unitPrices.get(i));
                items.add(item);
            }
        }
        order.setItems(items);

        orderService.insertOrder(order);
        return "redirect:/order";
    }

    // 상태 변경
    @PostMapping("/orderStatus")
    public String updateStatus(
            @RequestParam Long   id,
            @RequestParam String status) {
        orderService.updateOrderStatus(id, status);
        return "redirect:/order";
    }

    // 주문 취소
    @PostMapping("/orderDelete")
    public String deleteOrder(@RequestParam Long id) {
        orderService.deleteOrder(id);
        return "redirect:/order";
    }
    
}