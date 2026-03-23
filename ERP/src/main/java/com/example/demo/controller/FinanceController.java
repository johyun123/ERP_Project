package com.example.demo.controller;

import com.example.demo.Service.FinanceService;
import com.example.demo.Service.HRMService;
import com.example.demo.Service.UserService;
import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.PageRequest;
import com.example.demo.Domain.Payrolls;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.util.UUID;

@Controller
public class FinanceController {
	
	private final HRMService hrmService;
    private final FinanceService financeService;
    private final UserService    userService;

    public FinanceController(FinanceService financeService, 
    							UserService userService,
    							HRMService hrmService) {
        this.financeService = financeService;
        this.userService    = userService;
        this.hrmService 	= hrmService;
    }

    // ============================================================
    // 지출 등록 폼 — 팝업화로 인해 GET은 redirect로만 사용
    // ============================================================
    @GetMapping("/f_register")
    public String financeForm() {
        return "redirect:/f_list";
    }

    // ============================================================
    // 지출 등록 처리
    // ============================================================
    @PostMapping("/f_register")
    public String registerExpense(
            @RequestParam String    expenseType,
            @RequestParam int       amount,
            @RequestParam String    expenseDate,
            @RequestParam(required = false) String        description,
            @RequestParam(required = false) MultipartFile receiptFile,
            HttpSession        session,
            RedirectAttributes ra) {

        Long userId = (Long) session.getAttribute("loginUserId");

        FinanceExpense expense = new FinanceExpense();
        expense.setExpenseType(expenseType);
        expense.setAmount(amount);
        expense.setExpenseDate(expenseDate);
        expense.setDescription(description);
        expense.setReceiptPath(saveReceiptFile(receiptFile));
        expense.setRegisteredBy(userId);

        financeService.registerExpense(expense);
        ra.addFlashAttribute("msg", "지출이 등록되었습니다.");
        return "redirect:/f_list";
    }

    // ============================================================
    // 지출 목록 — 페이징 + 유형/비고/날짜 필터
    // ============================================================
    @GetMapping("/f_list")
    public String financeList(
            @RequestParam(defaultValue = "1")  int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false)    String keyword,
            @RequestParam(required = false)    String category,
            @RequestParam(required = false)    String dateFrom,
            @RequestParam(required = false)    String dateTo,
            Model model) {

        PageRequest req = new PageRequest(page, size);
        req.setKeyword(keyword);
        req.setCategory(category);
        req.setDateFrom(dateFrom);
        req.setDateTo(dateTo);

        model.addAttribute("result",   financeService.getExpenseByPage(req));
        model.addAttribute("keyword",  keyword);
        model.addAttribute("category", category);
        model.addAttribute("dateFrom", dateFrom);
        model.addAttribute("dateTo",   dateTo);
        model.addAttribute("size",     size);
        return "Finance/F_list";
    }

    // ============================================================
    // 지출 수정
    // ============================================================
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

    // ============================================================
    // 지출 삭제
    // ============================================================
    @PostMapping("/f_delete")
    public String deleteExpense(@RequestParam Long id) {
        financeService.deleteExpense(id);
        return "redirect:/f_list";
    }

    // ============================================================
    // 급여 내역 — 페이징 + 직원명 검색
    // ============================================================
    @GetMapping("/f_payrolls")
    public String payrollList(
            @RequestParam(defaultValue = "1")  int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false)    String keyword,
            Model model) {

        PageRequest req = new PageRequest(page, size);
        req.setKeyword(keyword);

        model.addAttribute("result",  financeService.getPayrollByPage(req));
        model.addAttribute("keyword", keyword);
        model.addAttribute("size",    size);

        // 수동처리 모달용 직원 목록
        model.addAttribute("employeeList", hrmService.getAllEmployees());
        return "Finance/F_payrolls";
    }

    // ============================================================
    // 관리자 인증
    // ============================================================
    @PostMapping("/payroll/auth")
    @ResponseBody
    public String adminAuth(@RequestParam String userId,
                            @RequestParam String userPw) {
        return userService.login(userId, userPw) ? "ok" : "fail";
    }

    // ============================================================
    // 급여 수정
    // ============================================================
    @PostMapping("/payroll/update")
    public String updatePayroll(
            @RequestParam Long   id,
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

        Payrolls p = buildPayroll(null, employeeId, payYear, payMonth,
                                  workHours, basePay, deduction, netPay, paidAt, note);
        p.setId(id);
        financeService.updatePayroll(p);
        ra.addFlashAttribute("msg", "수정되었습니다.");
        return "redirect:/f_payrolls";
    }

    // ============================================================
    // 급여 삭제
    // ============================================================
    @PostMapping("/payroll/delete")
    public String deletePayroll(@RequestParam Long id, RedirectAttributes ra) {
        financeService.deletePayroll(id);
        ra.addFlashAttribute("msg", "삭제되었습니다.");
        return "redirect:/f_payrolls";
    }

    // ============================================================
    // 급여 수동처리
    // ============================================================
    @PostMapping("/payroll/manual")
    public String manualPayroll(
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

        financeService.registerPayroll(
                buildPayroll(null, employeeId, payYear, payMonth,
                             workHours, basePay, deduction, netPay, paidAt, note));
        ra.addFlashAttribute("msg", "급여가 수동 처리되었습니다.");
        return "redirect:/f_payrolls";
    }

    // ── private 헬퍼 ──────────────────────────────────────────

    private Payrolls buildPayroll(Long id, Long employeeId,
                                  int payYear, int payMonth,
                                  double workHours, int basePay,
                                  int deduction, int netPay,
                                  String paidAt, String note) {
        Payrolls p = new Payrolls();
        if (id != null) p.setId(id);
        p.setEmployeeId(employeeId);
        p.setPayYear(payYear);
        p.setPayMonth(payMonth);
        p.setWorkHours(workHours);
        p.setBasePay(basePay);
        p.setDeduction(deduction);
        p.setNetPay(netPay);
        p.setPaidAt(paidAt);
        p.setNote(note);
        return p;
    }

    private String saveReceiptFile(MultipartFile file) {
        if (file == null || file.isEmpty()) return null;
        try {
            String uploadDir = System.getProperty("user.dir") + "/uploads/receipts/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            String original = file.getOriginalFilename();
            String ext = (original != null && original.contains("."))
                    ? original.substring(original.lastIndexOf('.')) : ".jpg";
            String savedName = UUID.randomUUID() + ext;
            file.transferTo(new File(uploadDir + savedName));
            return "/uploads/receipts/" + savedName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}