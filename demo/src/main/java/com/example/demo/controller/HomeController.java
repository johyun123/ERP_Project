package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Service.UserService;

@Controller
public class HomeController {

//	// 메인 로그인 페이지
//	@GetMapping("/")
//	public String home() {
//		return "MainPage";
//	}
//
//	// 메인 페이지 테스트
//	@GetMapping("/test")
//	public String system() {
//		return "NewFile";
//	}

	@Autowired
	private UserService userService; // 타입도 LoginService -> UserService

	@GetMapping("/")
	public String loginForm() {
		return "login"; // login.jsp
	}

	@PostMapping("/login")
	public String login(@RequestParam String user_id, @RequestParam String user_pw, Model model) {

		if (userService.login(user_id, user_pw)) { // userService 사용
			model.addAttribute("user_id", user_id);
			return "home"; // home.jsp
		} else {
			model.addAttribute("error", "아이디 또는 비밀번호가 틀렸습니다.");
			return "login";
		}
	}

}