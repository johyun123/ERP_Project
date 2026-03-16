package com.example.demo.Service;

import com.example.demo.mapper.FinanceMapper;
import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.Payrolls;

import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class FinanceService {

    private final FinanceMapper financeMapper;

    public FinanceService(FinanceMapper financeMapper) {
        this.financeMapper = financeMapper;
    }

    public void registerExpense(FinanceExpense expense) {
        financeMapper.insertExpense(expense);
    }

    public List<FinanceExpense> getExpenseList() {
        return financeMapper.selectExpenseList();
    }

    public void updateExpense(FinanceExpense expense) {
        financeMapper.updateExpense(expense);
    }

    public void deleteExpense(Long id) {
        financeMapper.deleteExpense(id);
    }
 
    public List<Payrolls> getPayrollList() {
        return financeMapper.selectPayrollList();
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
    
    //직원 도메인 생기면 활성화
//    public List<Employee> getActiveEmployeeList() {
//        return financeMapper.selectActiveEmployeeList();
//    }
    
}