package com.example.demo.controller;

import com.example.demo.Service.FinanceService;
import com.example.demo.Service.UserService;
import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.Payrolls;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class FinanceController {

    private final FinanceService financeService;
    private final UserService userService;
    
    public FinanceController(FinanceService financeService, 
    							UserService userService) {
        this.financeService = financeService;
        this.userService = userService;
    }

    @GetMapping("/f_register")
    public String financeForm() {
        return "Finance/F_register";
    }

    @PostMapping("/f_register")
    public String registerExpense(
            @RequestParam String expenseType,
            @RequestParam int    amount,
            @RequestParam String expenseDate,
            @RequestParam(required = false) String description) {

        FinanceExpense expense = new FinanceExpense();
        expense.setExpenseType(expenseType);
        expense.setAmount(amount);
        expense.setExpenseDate(expenseDate);
        expense.setDescription(description);
        // expense.setRegisteredBy(세션에서 유저 id 꺼내서 넣기 — 추후 구현)

        financeService.registerExpense(expense);
        return "redirect:/f_register";
    }
    
    @GetMapping("/f_list")
    public String financeList(Model model) {
        model.addAttribute("expenseList", financeService.getExpenseList());
        return "Finance/F_list";
    }

    @PostMapping("/f_update")
    public String updateExpense(
            @RequestParam Long   id,
            @RequestParam String expenseType,
            @RequestParam int    amount,
            @RequestParam String expenseDate,
            @RequestParam(required = false) String description) {

        FinanceExpense expense = new FinanceExpense();
        expense.setId(id);
        expense.setExpenseType(expenseType);
        expense.setAmount(amount);
        expense.setExpenseDate(expenseDate);
        expense.setDescription(description);

        financeService.updateExpense(expense);
        return "redirect:/f_list";
    }

    @PostMapping("/f_delete")
    public String deleteExpense(@RequestParam Long id) {
        financeService.deleteExpense(id);
        return "redirect:/f_list";
    }
  
    
    /* ===== 급여 내역 목록 ===== */
    @GetMapping("/f_payrolls")
    public String payrollList(Model model) {
        model.addAttribute("payrollList", financeService.getPayrollList());
        // 직원 도메인 생기면 활성화
        //model.addAttribute("employeeList",  financeService.getActiveEmployeeList());
        return "Finance/F_payrolls";
    }

    /* ===== 관리자 인증 (수정/삭제/수동처리 공통) ===== */
    @PostMapping("/payroll/auth")
    @ResponseBody
    public String adminAuth(@RequestParam String userId,
                            @RequestParam String userPw) {
        boolean valid = userService.authenticate(userId, userPw);
        return valid ? "ok" : "fail";
    }

    /* ===== 수정 ===== */
    @PostMapping("/payroll/update")
    public String updatePayroll(@RequestParam Long   id,
                                @RequestParam Long   employeeId,
                                @RequestParam int    payYear,
                                @RequestParam int    payMonth,
                                @RequestParam double workHours,
                                @RequestParam int    basePay,
                                @RequestParam int    deduction,
                                @RequestParam int    netPay,
                                @RequestParam(required = false) String paidAt,
                                @RequestParam(required = false) String note,
                                RedirectAttributes ra) {
        Payrolls p = new Payrolls();
        p.setId(id);
        p.setEmployeeId(employeeId);
        p.setPayYear(payYear);
        p.setPayMonth(payMonth);
        p.setWorkHours(workHours);
        p.setBasePay(basePay);
        p.setDeduction(deduction);
        p.setNetPay(netPay);
        p.setPaidAt(paidAt);
        p.setNote(note);
        financeService.updatePayroll(p);
        ra.addFlashAttribute("msg", "수정되었습니다.");
        return "redirect:/f_payrolls";
    }

    /* ===== 삭제 ===== */
    @PostMapping("/payroll/delete")
    public String deletePayroll(@RequestParam Long id, RedirectAttributes ra) {
    	financeService.deletePayroll(id);
        ra.addFlashAttribute("msg", "삭제되었습니다.");
        return "redirect:/f_payrolls";
    }

    /* ===== 급여 수동처리 ===== */
    @PostMapping("/payroll/manual")
    public String manualPayroll(@RequestParam Long   employeeId,
                                @RequestParam int    payYear,
                                @RequestParam int    payMonth,
                                @RequestParam double workHours,
                                @RequestParam int    basePay,
                                @RequestParam int    deduction,
                                @RequestParam int    netPay,
                                @RequestParam(required = false) String paidAt,
                                @RequestParam(required = false) String note,
                                RedirectAttributes ra) {
    	Payrolls p = new Payrolls();
        p.setEmployeeId(employeeId);
        p.setPayYear(payYear);
        p.setPayMonth(payMonth);
        p.setWorkHours(workHours);
        p.setBasePay(basePay);
        p.setDeduction(deduction);
        p.setNetPay(netPay);
        p.setPaidAt(paidAt);
        p.setNote(note);
        financeService.registerPayroll(p);
        ra.addFlashAttribute("msg", "급여가 수동 처리되었습니다.");
        return "redirect:/f_payrolls";
    
    
}

    
}