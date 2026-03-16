package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProductController {
	
    // 제품관리 페이지
    @GetMapping("/product")
    public String product(){
        return "Product/product";
    }
    
    // 제품등록 페이지
    @GetMapping("/productRegister")
    public String productRegister(){
        return "Product/productRegister";
    }
}
