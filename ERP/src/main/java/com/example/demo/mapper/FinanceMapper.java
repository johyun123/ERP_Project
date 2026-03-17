package com.example.demo.mapper;

//import com.example.demo.Domain.Employee;
import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.Payrolls;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface FinanceMapper {

    // ── Expense ──────────────────────────────────────
    int insertExpense(FinanceExpense expense);
    List<FinanceExpense> selectExpenseList();
    int updateExpense(FinanceExpense expense);
    int deleteExpense(Long id);

    // ── Payroll ───────────────────────────────────────
    List<Payrolls> selectPayrollList();
    int insertPayroll(Payrolls payroll);
    int updatePayroll(Payrolls payroll);
    int deletePayroll(Long id);

    // ── Employee (수동처리 드롭다운) ──────────────────
//    List<Employee> selectActiveEmployeeList();
}