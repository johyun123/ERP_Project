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
import com.example.demo.Domain.PageRequest;

@Controller
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    // ============================================================
    // 주문 목록 — 페이징 + 검색/상태/날짜 필터
    // ============================================================
    @GetMapping("/order")
    public String orderPage(
            @RequestParam(defaultValue = "1")  int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false)    String keyword,
            @RequestParam(required = false)    String status,
            @RequestParam(required = false)    String dateFrom,
            @RequestParam(required = false)    String dateTo,
            Model model) {

        PageRequest req = new PageRequest(page, size);
        req.setKeyword(keyword);
        req.setCategory(status);   // status 필터는 category 필드 재사용
        req.setDateFrom(dateFrom);
        req.setDateTo(dateTo);

        model.addAttribute("result",   orderService.getOrderByPage(req));
        model.addAttribute("menuList", orderService.getMenuList());
        model.addAttribute("keyword",  keyword);
        model.addAttribute("status",   status);
        model.addAttribute("dateFrom", dateFrom);
        model.addAttribute("dateTo",   dateTo);
        model.addAttribute("size",     size);
        return "Order/OrderDetail";
    }

    // ============================================================
    // 주문 등록
    // ============================================================
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

    // ============================================================
    // 상태 변경
    // ============================================================
    @PostMapping("/orderStatus")
    public String updateStatus(@RequestParam Long   id,
                               @RequestParam String status) {
        orderService.updateOrderStatus(id, status);
        return "redirect:/order";
    }

    // ============================================================
    // 주문 삭제
    // ============================================================
    @PostMapping("/orderDelete")
    public String deleteOrder(@RequestParam Long id) {
        orderService.deleteOrder(id);
        return "redirect:/order";
    }
}