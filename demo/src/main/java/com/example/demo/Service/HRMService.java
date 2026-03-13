package com.example.demo.Service;

import java.util.List;

import org.springframework.stereotype.Service;

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
	public Employees getEmployeeById(Long id) {
		return hrmMapper.selectEmployeeById(id);
	}

	// 직원 등록
	public void addEmployee(Employees employee) {
		hrmMapper.insertEmployee(employee);
	}

	// 직원 정보 수정
	public void updateEmployee(Employees employee) {
		hrmMapper.updateEmployee(employee);
	}

	// 직원 삭제 (논리 삭제 or 실제 삭제)
	public void deleteEmployee(Long id) {
		hrmMapper.deleteEmployee(id);
	}
}