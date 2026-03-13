package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FinanceController {
	
	@GetMapping("/f_register")
	public String finance(){
		return "Finance/F_register";
	}
}
