package com.example.ERP.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    // 메인
    @GetMapping("/")
    public String home() {
        return "Cafe ERP Main Page";
    }

    // 1 시스템 관리
    @GetMapping("/system")
    public String system() {
        return "System Management Page";
    }

    // 2 재무 & 회계
    @GetMapping("/finance")
    public String finance() {
        return "Finance & Accounting Page";
    }

    // 3 생산 관리
    @GetMapping("/production")
    public String production() {
        return "Production Management Page";
    }

    // 4 재고 & 자재 관리
    @GetMapping("/inventory")
    public String inventory() {
        return "Inventory & Material Management Page";
    }

    // 5 구매 & 영업
    @GetMapping("/sales")
    public String sales() {
        return "Purchase & Sales Page";
    }

    // 6 경영 대시보드
    @GetMapping("/dashboard")
    public String dashboard() {
        return "Management Dashboard Page";
    }
}