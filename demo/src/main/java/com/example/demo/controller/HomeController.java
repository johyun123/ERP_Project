package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Controller
public class HomeController {

    // 메인 로그인 페이지
    @GetMapping("/")
    public String home() {
        return "MainPage";
    }
    
    // 메인 페이지 테스트
    @GetMapping("/test")
    public String system() {
        return "NewFile";
    }
    
    // 제품관리 페이지
    @GetMapping("/product")
    public String product(){
        return "product";
    }
    
    // 제품등록 페이지
    @GetMapping("/productRegister")
    public String productRegister(){
        return "productRegister";
    }
}