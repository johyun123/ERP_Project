package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.Service.UserService;

@Controller
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    /* ===== 로그인 폼 ===== */
    @GetMapping({"/", "/login"})
    public String loginForm() {
        return "login";
    }

    /* ===== 메인 페이지 ===== */
    @GetMapping("/MainPage")
    public String mainPage() {
        return "MainPage";
    }

    // ※ /logout 은 SecurityConfig 에서 Spring Security가 처리
    //   (GET /logout → 수동 session.invalidate() 방식 제거)
}