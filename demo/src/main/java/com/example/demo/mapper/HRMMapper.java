package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.Domain.Employees;

@Mapper
public interface HRMMapper {

	// 전체 직원 조회
	@Select("SELECT * FROM employees WHERE is_active = 1")
	List<Employees> selectAllEmployees();

	// 단일 직원 조회
	@Select("SELECT * FROM employees WHERE id = #{id} AND is_active = 1")
	Employees selectEmployeeById(@Param("id") Long id);

	// 직원 등록
	@Insert("INSERT INTO employees (user_id, name, age, phone, position, contract_type, hourly_wage, monthly_salary, hire_date, resign_date, profile, bank_name, account_no, is_active) "
			+ "VALUES (#{userId}, #{name}, #{age}, #{phone}, #{position}, #{contractType}, #{hourlyWage}, #{monthlySalary}, #{hireDate}, #{resignDate}, #{profile}, #{bankName}, #{accountNo}, 1)")
	void insertEmployee(Employees employee);

	// 직원 정보 수정
	@Update("UPDATE employees SET " + "user_id = #{userId}, " + "name = #{name}, " + "age = #{age}, "
			+ "phone = #{phone}, " + "position = #{position}, " + "contract_type = #{contractType}, "
			+ "hourly_wage = #{hourlyWage}, " + "monthly_salary = #{monthlySalary}, " + "hire_date = #{hireDate}, "
			+ "resign_date = #{resignDate}, " + "profile = #{profile}, " + "bank_name = #{bankName}, "
			+ "account_no = #{accountNo} " + "WHERE id = #{id}")
	void updateEmployee(Employees employee);

	// 직원 삭제 (논리 삭제)
	@Update("UPDATE employees SET is_active = 0 WHERE id = #{id}")
	void deleteEmployee(@Param("id") Long id);
}