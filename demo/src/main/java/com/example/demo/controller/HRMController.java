package com.example.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Domain.Employees;
import com.example.demo.Service.HRMService;

@Controller
@RequestMapping("/hr")
public class HRMController {

	private final HRMService hrmService;

	// 생성자 주입
	public HRMController(HRMService hrmService) {
		this.hrmService = hrmService;
	}

//	@GetMapping("/employees") // 직원관리
//	public String employessPage(Model model) {
//		model.addAttribute("employees", hrmService.getAllEmployees());
//		return "hr/employees";
//	}

	@GetMapping("/employees") // 직원 관리 및 검사 필터
	public String listEmployees(@RequestParam(required = false, defaultValue = "all") String status,
			@RequestParam(required = false) String name, @RequestParam(required = false) String position, Model model) {

		// is_active 필터 결정
		Integer isActive = null;
		if ("active".equals(status))
			isActive = 1;
		if ("resigned".equals(status))
			isActive = 0;

		// HRMService에 searchEmployees(name, position, isActive) 메서드 필요
		List<Employees> employees = hrmService.searchEmployees(name, position, isActive);
		model.addAttribute("employees", employees);

		return "hr/employees"; // JSP
	}

	@GetMapping("/employees/register") // 직원 정보 / 등록
	public String registerPage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/employees/register";
	}

	@PostMapping("/employees/register")
	public String registerEmployee(Employees employee) {
		hrmService.addEmployee(employee); // HRMService에 등록 로직 있어야 함
		return "redirect:/hr/employees?status=all";
	}

	// 직원 수정 페이지 이동
//	@GetMapping("/employees/edit")
//	public String editEmployee(@RequestParam String emp_num, Model model) {
//
//		Employees employee = hrmService.getEmployeeById(emp_num);
//		model.addAttribute("employee", employee);
//
//		return "/hr/Employee/edit";
//	}

	@GetMapping("/employees/edit/{emp_num}")
	public String editEmployee(@PathVariable String emp_num, Model model) {
		Employees employee = hrmService.getEmployeeById(emp_num);
		model.addAttribute("employee", employee);

		// 앞에 '/' 제거하고 실제 폴더 구조 맞춤
		return "hr/employees/edit";
	}

	// 직원 수정 처리
	@PostMapping("/employees/update")
	public String updateEmployee(Employees employee) {

		hrmService.updateEmployee(employee);

		return "redirect:/hr/employees?status=all";
	}

	// 직원 삭제
	@PostMapping("/employees/delete")
	public String deleteEmployee(@RequestParam String emp_num) {

		hrmService.deleteEmployee(emp_num);

		return "redirect:/hr/employees?status=all";
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