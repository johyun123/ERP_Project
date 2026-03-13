package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.Service.HRMService;

@Controller
@RequestMapping("/hr")
public class HRMController {

	private final HRMService hrmService;

	// 생성자 주입
	public HRMController(HRMService hrmService) {
		this.hrmService = hrmService;
	}

	@GetMapping("/employees") // 직원관리
	public String employessPage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/employees";
	}

	@GetMapping("/employees/register") // 직원 정보 / 등록
	public String registerPage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/employees/register";
	}

	@GetMapping("/attendance") // 근태 관리
	public String attendancePage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/attendance";
	}

	@GetMapping("/attendanceIn") // 근태 관리 상세 페이지
	public String attendanceInPage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/attendance/attendanceIn";
	}

	@GetMapping("/users") // ERP 사용자 관리
	public String usersPage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/users";
	}

}