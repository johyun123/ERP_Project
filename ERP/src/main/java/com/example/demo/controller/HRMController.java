package com.example.demo.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.Domain.Attendances;
import com.example.demo.Domain.Employees;
import com.example.demo.Domain.User;
import com.example.demo.Service.HRMService;
import com.example.demo.Service.UserService;

@Controller
@RequestMapping("/hr")
public class HRMController {

    private final HRMService  hrmService;
    private final UserService userService;

    public HRMController(HRMService hrmService, UserService userService) {
        this.hrmService  = hrmService;
        this.userService = userService;
    }

    /* ===== 직원 목록 ===== */
    @GetMapping("/employees")
    public String listEmployees(
            @RequestParam(required = false, defaultValue = "all") String status,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String position,
            Model model) {

        // status → isActive 변환
        Map<String, Integer> statusMap = Map.of("active", 1, "leave", 2, "resigned", 0);
        Integer isActive = statusMap.get(status); // "all"이면 null → 전체 조회

        model.addAttribute("employees", hrmService.searchEmployees(name, position, isActive));
        return "hr/employees";
    }

    /* ===== 직원 등록 폼 ===== */
    @GetMapping("/employees/register")
    public String registerPage(Model model) {
        model.addAttribute("employees", hrmService.getAllEmployees());
        return "hr/employees/register";
    }

    /* ===== 직원 등록 처리 ===== */
    @PostMapping("/employees/register")
    public String registerEmployee(Employees employee) {
        hrmService.addEmployee(employee);
        return "redirect:/hr/employees?status=all";
    }

    /* ===== 직원 수정 폼 ===== */
    @GetMapping("/employees/edit/{emp_num}")
    public String editEmployee(@PathVariable String emp_num, Model model) {
        model.addAttribute("employee", hrmService.getEmployeeById(emp_num));
        return "hr/employees/edit";
    }

    /* ===== 직원 수정 처리 ===== */
    @PostMapping("/employees/update")
    public String updateEmployee(Employees employee) {
        hrmService.updateEmployee(employee);
        return "redirect:/hr/employees?status=all";
    }

    /* ===== 직원 삭제 ===== */
    @PostMapping("/employees/delete")
    public String deleteEmployee(@RequestParam String emp_num) {
        hrmService.deleteEmployee(emp_num);
        return "redirect:/hr/employees?status=all";
    }

    /* ===== 근태 관리 ===== */
    @GetMapping("/attendance")
    public String attendancePage(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            Model model) {
        if (year == null || month == null) {
            LocalDate now = LocalDate.now();
            year  = now.getYear();
            month = now.getMonthValue();
        }
        model.addAttribute("attendanceCount", hrmService.getAttendanceCountByMonth(year, month));
        return "hr/attendance";
    }

    /* ===== 근태 상세 ===== */
    @GetMapping("/attendanceIn")
    public String attendanceInPage(@RequestParam String date, Model model) {
        model.addAttribute("attendance", hrmService.getAttendanceWithEmployees(date));
        model.addAttribute("date", date);
        return "hr/attendance/attendanceIn";
    }

    /* ===== 근태 저장 ===== */
    @PostMapping("/saveAttendance")
    public String saveAttendance(@RequestParam Map<String, String> param) {
        int i = 0;
        while (param.containsKey("list[" + i + "].employee_id")) {
            Attendances a = new Attendances();
            a.setEmployee_id(Integer.parseInt(param.get("list[" + i + "].employee_id")));

            String dateStr     = param.get("list[" + i + "].work_date_str");
            String clockInStr  = param.get("list[" + i + "].clock_in_str");
            String clockOutStr = param.get("list[" + i + "].clock_out_str");

            if (dateStr     != null && !dateStr.isEmpty())     a.setWork_date(LocalDate.parse(dateStr));
            if (clockInStr  != null && !clockInStr.isEmpty())  a.setClock_in(LocalTime.parse(clockInStr));
            if (clockOutStr != null && !clockOutStr.isEmpty()) a.setClock_out(LocalTime.parse(clockOutStr));
            a.setNote(param.get("list[" + i + "].note"));

            if (a.getClock_in() != null) hrmService.saveOrUpdate(a);
            i++;
        }
        return "redirect:/hr/attendanceIn?date=" + param.get("list[0].work_date_str");
    }

    /* ===== ERP 사용자 관리 목록 ===== */
    @GetMapping("/users")
    public String usersPage(Model model) {
        List<Employees> employees = hrmService.getAllEmployees();
        List<User>      users     = userService.getAllUsers();
        Map<Long, Employees> empMapById = employees.stream()
                .collect(Collectors.toMap(Employees::getId, e -> e));
        model.addAttribute("users",      users);
        model.addAttribute("employees",  employees);
        model.addAttribute("empMapById", empMapById);
        return "hr/users";
    }

    /* ===== 사용자 활성/비활성 토글 ===== */
    @PostMapping("/users/toggle")
    public String toggleUserActive(@RequestParam String emp_num) {
        Employees emp = hrmService.getEmployeeById(emp_num);
        if (emp != null) userService.toggleUserActive(emp.getId());
        return "redirect:/hr/users";
    }

    /* ===== ERP 계정 등록 폼 ===== */
    @GetMapping("/users/register")
    public String registerForm(Model model) {
        List<Employees> employees = hrmService.getAllEmployees();
        Set<Long> registeredIds = userService.getAllUsers().stream()
                .map(User::getId)
                .collect(Collectors.toSet());
        model.addAttribute("employees",     employees);
        model.addAttribute("registeredIds", registeredIds);
        return "hr/users/users_register";
    }

    /* ===== ERP 계정 등록 처리 ===== */
    @PostMapping("/users/register")
    public String registerUser(@RequestParam String emp_num,
                               @RequestParam String user_pw,
                               Model model) {
        // 직원 조회는 한 번만
        Employees emp = hrmService.getEmployeeById(emp_num);

        if (emp == null) {
            return registerFormWithError(model, "존재하지 않는 직원입니다.");
        }
        if (emp.getIs_active() == 0) {
            return registerFormWithError(model, "퇴사자는 계정 생성 불가합니다.");
        }
        if (userService.existsByUserId(emp_num)) {
            return registerFormWithError(model, "이미 계정이 존재하는 직원입니다.");
        }
        userService.registerByEmployee(emp_num, user_pw);
        return "redirect:/hr/users?msg=registered";
    }

    /* ===== 비밀번호 변경 처리 ===== */
    @PostMapping("/users/pw-change")
    public String pwChange(@RequestParam String emp_num,
                           @RequestParam String new_pw) {
        try {
            userService.changePassword(emp_num, new_pw);
            return "redirect:/hr/users?msg=pw_changed";
        } catch (Exception e) {
            return "redirect:/hr/users?msg=pw_error";
        }
    }

    /* ===== ERP 계정 삭제 처리 ===== */
    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam String emp_num) {
        try {
            userService.deleteUserAccount(emp_num);
            return "redirect:/hr/users?msg=del_done";
        } catch (Exception e) {
            return "redirect:/hr/users?msg=del_error";
        }
    }

    /* ===== 관리자 인증 (users 전용 AJAX) ===== */
    @PostMapping("/users/auth")
    @ResponseBody
    public ResponseEntity<String> usersAuth(@RequestParam String userId,
                                            @RequestParam String userPw) {
        return ResponseEntity.ok(userService.authenticate(userId, userPw) ? "ok" : "fail");
    }

    // ── private 헬퍼 ──────────────────────────────────────────

    /** 등록 폼에 에러 메시지 담아 반환 */
    private String registerFormWithError(Model model, String errorMsg) {
        model.addAttribute("error",     errorMsg);
        model.addAttribute("employees", hrmService.getAllEmployees());
        return "hr/users/users_register";
    }
}