package com.example.demo.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.Domain.Attendances;
import com.example.demo.Domain.Employees;

@Mapper
public interface HRMMapper {

	// HRMMapper.java (npm_num 기준으로 직원 가져오기)
	@Select("SELECT * FROM employees WHERE npm_num = #{npm_num}")
	Employees selectEmployeeByNpmNum(@Param("npm_num") String npm_num);

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

	// 달력 조회
	@Select("""
			    SELECT *
			    FROM attendances
			    WHERE work_date = #{date}
			""")
	List<Attendances> getAttendanceByDate(String date);

	// 달력 내에 츌근 인원 상호작용 추가 (attendance 용)
	@Select("""
			SELECT
			    work_date,
			    COUNT(*) AS count
			FROM attendances
			WHERE YEAR(work_date) = #{year}
			AND MONTH(work_date) = #{month}
			GROUP BY work_date
			""")
	List<Map<String, Object>> getAttendanceCountByMonth(@Param("year") int year, @Param("month") int month);

	// 상세 페이지용 직원 이름 별 데이터 내용 시사
	@Select("""
			SELECT
			    a.id,
			    a.employee_id,
			    e.name,
			    a.clock_in,
			    a.work_hours,
			    a.note
			FROM attendances a
			JOIN employees e
			ON a.employee_id = e.emp_num
			WHERE a.work_date = #{date}
			""")
	List<Map<String, Object>> getAttendanceDetail(String date);

	// 근태 상태 상세 페이지에 들어갈 데이터 추가
	@Select("""
			    SELECT
			        e.id AS employee_id,
			        e.emp_num,
			        e.name,
			        a.work_date,
			        a.clock_in,
			        a.clock_out,
			        a.work_hours,
			        a.note
			    FROM employees e
			    LEFT JOIN attendances a
			        ON e.id = a.employee_id
			        AND a.work_date = #{date}
			    WHERE e.is_active = 1
			""")
	List<Map<String, Object>> getAttendanceWithEmployees(String date);

	// 존재 여부 확인
	@Select("""
			    SELECT COUNT(*)
			    FROM attendances
			    WHERE employee_id = #{employee_id}
			    AND work_date = #{work_date}
			""")
	int existsAttendance(@Param("employee_id") int employee_id, @Param("work_date") LocalDate work_date);

	// INSERT
	@Insert("""
			    INSERT INTO attendances (employee_id, work_date, clock_in, clock_out, work_hours, note)
			    VALUES (#{employee_id}, #{work_date}, #{clock_in}, #{clock_out}, #{work_hours}, #{note})
			""")
	void insertAttendance(Attendances a);

	// UPDATE
	@Update("""
			    UPDATE attendances
			    SET clock_in = #{clock_in},
			        clock_out = #{clock_out},
			        note = #{note}
			    WHERE employee_id = #{employee_id}
			    AND work_date = #{work_date}
			""")
	void updateAttendance(Attendances a);

}