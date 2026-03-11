package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Service.LoginService;

import ch.qos.logback.core.model.Model;

@Controller
public class HomeController {

//    // 메인 로그인 페이지
//    @GetMapping("/")
//    public String home() {
//        return "MainPage";
//    }
//    
//    // 메인 페이지 테스트
//    @GetMapping("/test")
//    public String system() {
//        return "NewFile";
//    }

	@Autowired
	private LoginService loginService;

	@GetMapping("/")
	public String loginForm() {
		return "login"; // login.jsp
	}

	@PostMapping("/login")
	public String login(@RequestParam String username, @RequestParam String password, Model model) {

		if (loginService.login(username, password)) {
			model.addAttribute("username", username);
			return "home"; // home.jsp
		} else {
			model.addAttribute("error", "아이디 또는 비밀번호가 틀렸습니다.");
			return "login";
		}
	}
}