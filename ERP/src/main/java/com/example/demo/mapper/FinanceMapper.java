package com.example.demo.mapper;

import com.example.demo.Domain.FinanceExpense;
import com.example.demo.Domain.Payrolls;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
//import com.example.demo.Domain.Employee; // 직원 도메인 생기면 활성

@Mapper
public interface FinanceMapper {
    int insertExpense(FinanceExpense expense);
    List<FinanceExpense> selectExpenseList();
    int updateExpense(FinanceExpense expense);
    int deleteExpense(Long id);
    
    List<Payrolls> selectPayrollList();
    int insertPayroll(Payrolls payroll);
    int updatePayroll(Payrolls payroll);
    int deletePayroll(Long id);
    
    // 직원 도메인 생기면 활성화
//    List<Employee> selectActiveEmployeeList();
}