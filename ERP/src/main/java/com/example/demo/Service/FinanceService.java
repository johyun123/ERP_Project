package com.example.demo.Service;

import com.example.demo.mapper.FinanceMapper;
import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.PageRequest;
import com.example.demo.Domain.PageResult;
import com.example.demo.Domain.Payrolls;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class FinanceService {

    private final FinanceMapper financeMapper;

    public FinanceService(FinanceMapper financeMapper) {
        this.financeMapper = financeMapper;
    }

    // ── Expense ──────────────────────────────────────

    public void registerExpense(FinanceExpense expense) {
        financeMapper.insertExpense(expense);
    }

    public List<FinanceExpense> getExpenseList() {
        return financeMapper.selectExpenseList();
    }

    public PageResult<FinanceExpense> getExpenseByPage(PageRequest req) {
        return new PageResult<>(financeMapper.selectExpenseByPage(req),
                                financeMapper.countExpense(req), req);
    }

    public void updateExpense(FinanceExpense expense) {
        financeMapper.updateExpense(expense);
    }

    public void deleteExpense(Long id) {
        financeMapper.deleteExpense(id);
    }

    // ── Payroll ───────────────────────────────────────

    public List<Payrolls> getPayrollList() {
        return financeMapper.selectPayrollList();
    }

    public PageResult<Payrolls> getPayrollByPage(PageRequest req) {
        return new PageResult<>(financeMapper.selectPayrollByPage(req),
                                financeMapper.countPayroll(req), req);
    }

    public void registerPayroll(Payrolls payroll) {
        financeMapper.insertPayroll(payroll);
    }

    public void updatePayroll(Payrolls payroll) {
        financeMapper.updatePayroll(payroll);
    }

    public void deletePayroll(Long id) {
        financeMapper.deletePayroll(id);
    }
}