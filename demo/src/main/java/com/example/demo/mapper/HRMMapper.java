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
	@Select("SELECT * FROM employees")
	List<Employees> selectAllEmployees();

	// 단일 직원 조회
	@Select("SELECT * FROM employees WHERE emp_num = #{emp_num}")
	Employees selectEmployeeById(@Param("emp_num") String emp_num);

	// 재직자만 조회
	@Select("SELECT * FROM employees WHERE is_active >= 1")
	List<Employees> selectActiveEmployees();

	// 퇴사자만 조회
	@Select("SELECT * FROM employees WHERE is_active = 0")
	List<Employees> selectResignedEmployees();

	// 직원 검색
	@Select("<script>" + "SELECT * FROM employees" + " <where> "
			+ "   <if test='name != null and name != \"\"'> AND name LIKE CONCAT('%', #{name}, '%')</if>"
			+ "   <if test='position != null and position != \"\"'> AND position = #{position}</if>"
			+ "   <if test='is_active != null'> AND is_active = #{is_active}</if>" + " </where>" + "</script>")
	List<Employees> searchEmployees(@Param("name") String name, @Param("position") String position,
			@Param("is_active") Integer is_active);

	// 직원 등록
	@Insert("INSERT INTO employees (emp_num, name, age, phone, position, contract_type, hourly_wage, monthly_salary, hire_date, resign_date, profile, bank_name, account_no, is_active) "
			+ "VALUES (#{emp_num}, #{name}, #{age}, #{phone}, #{position}, #{contract_type}, #{hourly_wage}, #{monthly_salary}, #{hire_date}, #{resign_date}, #{profile}, #{bank_name}, #{account_no}, 1)")
	void insertEmployee(Employees employee);

	// 직원 정보 수정
	@Update("UPDATE employees SET " + "emp_num = #{emp_num}, " + "name = #{name}, " + "age = #{age}, "
			+ "phone = #{phone}, " + "position = #{position}, " + "contract_type = #{contract_type}, "
			+ "hourly_wage = #{hourly_wage}, " + "monthly_salary = #{monthly_salary}, " + "hire_date = #{hire_date}, "
			+ "resign_date = #{resign_date}, " + "profile = #{profile}, " + "bank_name = #{bank_name}, "
			+ "account_no = #{account_no}, " + "is_active = #{is_active} " + "WHERE emp_num = #{emp_num}")
	void updateEmployee(Employees employee);

	// 직원 삭제 (논리 삭제)
	@Update("UPDATE employees SET is_active = 0 WHERE emp_num = #{emp_num}")
	void deleteEmployee(@Param("emp_num") String emp_num);

}