package com.example.demo.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Domain.Attendances;
import com.example.demo.Domain.Employees;
import com.example.demo.Domain.User;
import com.example.demo.Service.HRMService;
import com.example.demo.Service.UserService;

@Controller
@RequestMapping("/hr")
public class HRMController {

	private final HRMService hrmService;
	private final UserService userService;

	// 생성자 주입
	public HRMController(HRMService hrmService, UserService userService) {
		this.hrmService = hrmService;
		this.userService = userService;
	}

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
	public String attendancePage(@RequestParam(required = false) Integer year,
			@RequestParam(required = false) Integer month, Model model) {

		if (year == null || month == null) {
			LocalDate now = LocalDate.now();
			year = now.getYear();
			month = now.getMonthValue();
		}

		List<Map<String, Object>> attendanceCount = hrmService.getAttendanceCountByMonth(year, month);

		model.addAttribute("attendanceCount", attendanceCount);

		return "hr/attendance";
	}

	@GetMapping("/attendanceIn") // 근태 관리 상새 페이지
	public String attendanceInPage(@RequestParam String date, Model model) {

		List<Map<String, Object>> attendance = hrmService.getAttendanceWithEmployees(date);

		model.addAttribute("attendance", attendance);
		model.addAttribute("date", date);

		return "hr/attendance/attendanceIn";
	}

	@PostMapping("/saveAttendance")
	public String saveAttendance(@RequestParam Map<String, String> param) {

		int i = 0;

		while (param.containsKey("list[" + i + "].employee_id")) {

			Attendances a = new Attendances();

			a.setEmployee_id(Integer.parseInt(param.get("list[" + i + "].employee_id")));

			// String → LocalDate/LocalTime/Double 변환
			String dateStr = param.get("list[" + i + "].work_date_str");
			if (dateStr != null && !dateStr.isEmpty()) {
				a.setWork_date(LocalDate.parse(dateStr));
			}

			String clockInStr = param.get("list[" + i + "].clock_in_str");
			if (clockInStr != null && !clockInStr.isEmpty()) {
				a.setClock_in(LocalTime.parse(clockInStr));
			}

			String clockOutStr = param.get("list[" + i + "].clock_out_str");
			if (clockOutStr != null && !clockOutStr.isEmpty()) {
				a.setClock_out(LocalTime.parse(clockOutStr));
			}

			a.setNote(param.get("list[" + i + "].note"));

			// 입력 안 한 경우 skip
			if (a.getClock_in() != null) {
				hrmService.saveOrUpdate(a);
			}

			i++;
		}

		return "redirect:/hr/attendanceIn?date=" + param.get("list[0].work_date_str");
	}

	@GetMapping("/users")
	public String usersPage(Model model) {
		List<Employees> employees = hrmService.getAllEmployees();
		List<User> users = userService.getAllUsers();

		// emp_num → Employee 매핑
		// 기존 (emp_num 기준 → 지금 구조랑 안 맞음)
//		Map<String, Employees> empMap = employees.stream().collect(Collectors.toMap(Employees::getEmp_num, e -> e));

		// 수정 (id 기준으로 매핑해야 함)
		Map<Long, Employees> empMapById = employees.stream().collect(Collectors.toMap(Employees::getId, e -> e));
		model.addAttribute("users", users);
		model.addAttribute("employees", employees);

		model.addAttribute("empMapById", empMapById);
//		model.addAttribute("empMap", empMap); // JSP에서 users.emp_num로 employee 정보 조회 가능
		return "hr/users";
	}

	// 컨트롤러에서 String(emp_num) → employees 조회 → users.id(Long) →
	// toggleUserActive(Long)
	@PostMapping("/users/toggle")
	public String toggleUserActive(@RequestParam String emp_num) {
		// 1️. emp_num → 직원 조회
		Employees emp = hrmService.getEmployeeById(emp_num);
		if (emp != null) {
			// 2️. 직원 id(Long) → toggleUserActive 호출
			userService.toggleUserActive(emp.getId());
		}

		return "redirect:/hr/users";
	}

	@GetMapping("/users/register") // 회원가입 페이지
	public String registerForm(Model model) {
		List<Employees> employees = hrmService.getAllEmployees();
		model.addAttribute("employees", employees);
		return "hr/users/register";
	}

	@PostMapping("/users/register") // 회원가입 처리
	public String registerUser(@RequestParam String emp_num, @RequestParam String user_pw, Model model) { // 🔥 position
																											// 제거 (요청에서
																											// 안 받음)

		Employees emp = hrmService.getEmployeeById(emp_num);

		if (emp == null) {
			model.addAttribute("error", "존재하지 않는 직원입니다.");
			return "hr/users/register";
		}

		if (emp.getIs_active() == 0) {
			model.addAttribute("error", "퇴사자는 계정 생성 불가");
			return "hr/users/register";
		}

		if (userService.existsByUserId(emp_num)) {
			model.addAttribute("error", "이미 계정이 존재하는 직원입니다.");
			return "hr/users/register";
		}

//		// 핵심: DB에서 position 가져오기
//		String position = emp.getPosition(); // ← 여기서 가져옴
//
//		// 기존 position 대신 DB값 사용
//		userService.registerByEmployee(emp_num, user_pw, emp.getName(), position);

		model.addAttribute("message", "회원가입 완료!");
		return "redirect:/hr/users";
	}

}