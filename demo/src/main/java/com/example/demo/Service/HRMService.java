package com.example.demo.Service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.demo.Domain.Attendances;
import com.example.demo.Domain.Employees;
import com.example.demo.mapper.HRMMapper;

@Service
public class HRMService {

	private final HRMMapper hrmMapper;

	// 생성자 주입
	public HRMService(HRMMapper hrmMapper) {
		this.hrmMapper = hrmMapper;
	}

	// 전체 직원 조회
	public List<Employees> getAllEmployees() {
		return hrmMapper.selectAllEmployees();
	}

	// 단일 직원 조회
	public Employees getEmployeeById(String emp_num) {
		return hrmMapper.selectEmployeeById(emp_num);
	}

	// 검색 기능 추가
	public List<Employees> searchEmployees(String name, String position, Integer isActive) {
		return hrmMapper.searchEmployees(name, position, isActive);
	}

	// 달력 생성
	public List<Attendances> getAttendanceByDate(String date) {
		return hrmMapper.getAttendanceByDate(date);
	}

	// 달력 기능 추가
	public List<Map<String, Object>> getAttendanceCountByMonth(int year, int month) {
		return hrmMapper.getAttendanceCountByMonth(year, month);
	}

	// 직원 등록
	public void addEmployee(Employees employee) {
		hrmMapper.insertEmployee(employee);
	}

	// 직원 정보 수정
	public void updateEmployee(Employees employee) {
		hrmMapper.updateEmployee(employee);
	}

	// 직원 삭제 (논리 삭제)
	public void deleteEmployee(String emp_num) {
		hrmMapper.deleteEmployee(emp_num);
	}

	// 기존꺼 대신 이거 사용
	public List<Map<String, Object>> getAttendanceWithEmployees(String date) {
		return hrmMapper.getAttendanceWithEmployees(date);
	}

	// 저장 로직
	public void saveOrUpdate(Attendances a) {

		int count = hrmMapper.existsAttendance(a.getEmployee_id(), a.getWork_date());

		if (count == 0) {
			hrmMapper.insertAttendance(a);
		} else {
			hrmMapper.updateAttendance(a);
		}
	}

}