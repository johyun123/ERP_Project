package com.example.demo.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.Domain.Attendances;
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

//	@GetMapping("/attendance") // 근태 관리
//	public String attendancePage(Model model) {
//		model.addAttribute("employees", hrmService.getAllEmployees());
//		return "hr/attendance";
//	}

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

//	@GetMapping("/attendanceIn") // 근태 관리 상세 페이지
//	public String attendanceInPage(Model model) {
//		model.addAttribute("employees", hrmService.getAllEmployees());
//		return "hr/attendance/attendanceIn";
//	}

//	@GetMapping("/attendanceIn") // 근태 관리 상새 페이지
//	public String attendanceInPage(@RequestParam String date, Model model) {
//
//		List<Attendances> attendance = hrmService.getAttendanceByDate(date);
//
//		model.addAttribute("attendance", attendance);
//		model.addAttribute("date", date);
//
//		return "hr/attendance/attendanceIn";
//	}

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

//			String workHoursStr = param.get("list[" + i + "].work_hours_str");
//			if (workHoursStr != null && !workHoursStr.isEmpty()) {
//				a.setWork_hours(Double.valueOf(workHoursStr));
//			}

			a.setNote(param.get("list[" + i + "].note"));

			// 입력 안 한 경우 skip
			if (a.getClock_in() != null) {
				hrmService.saveOrUpdate(a);
			}

			i++;
		}

		return "redirect:/hr/attendanceIn?date=" + param.get("list[0].work_date_str");
	}

	@GetMapping("/users") // ERP 사용자 관리
	public String usersPage(Model model) {
		model.addAttribute("employees", hrmService.getAllEmployees());
		return "hr/users";
	}

}