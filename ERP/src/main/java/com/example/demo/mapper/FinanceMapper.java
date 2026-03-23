package com.example.demo.mapper;

import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.PageRequest;
import com.example.demo.Domain.Payrolls;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface FinanceMapper {

    // ── Expense ──────────────────────────────────────
    int insertExpense(FinanceExpense expense);
    List<FinanceExpense> selectExpenseList();
    List<FinanceExpense> selectExpenseByPage(PageRequest req);
    int countExpense(PageRequest req);
    int updateExpense(FinanceExpense expense);
    int deleteExpense(Long id);

    // ── Payroll ───────────────────────────────────────
    List<Payrolls> selectPayrollList();
    List<Payrolls> selectPayrollByPage(PageRequest req);
    int countPayroll(PageRequest req);
    int insertPayroll(Payrolls payroll);
    int updatePayroll(Payrolls payroll);
    int deletePayroll(Long id);
}