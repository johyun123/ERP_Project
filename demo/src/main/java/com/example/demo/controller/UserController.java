package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Service.UserService;

@Controller
public class UserController {
	private final UserService userService;
	
	UserController(UserService userService){
		this.userService = userService;
	}
	
	@GetMapping("/login")
	public String loginForm() {
		return "login";
	}

	@GetMapping("/logout")
	public String logout() {
		return "";
	}
    
	@GetMapping("/MainPage")
	public String Main() {
		return "MainPage";
	}
	
	// 회원가입 폼
	@GetMapping("/register")
	public String registerForm() {
		return "register"; // register.jsp
	}

	// 회원가입 처리
	@PostMapping("/register")
	public String register(@RequestParam String user_id, @RequestParam String user_pw, @RequestParam String user_name,
			Model model) {
		userService.register(user_id, user_pw, user_name);
		model.addAttribute("message", "회원가입 완료! 로그인 해주세요.");
		return "login";
	}

}