package com.example.demo.Service;

import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.demo.Domain.User;
import com.example.demo.mapper.UserMapper;

// 사용자 입력(emp_num) → Employees 테이블에서 조회 → Users.id로 계정 조회 → 비밀번호/권한 리턴

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

	private final UserMapper userMapper;
	private final HRMService hrmService;

	public UserDetailsServiceImpl(UserMapper userMapper, HRMService hrmService) {
		this.userMapper = userMapper;
		this.hrmService = hrmService;
	}

	@Override
	public UserDetails loadUserByUsername(String emp_num) throws UsernameNotFoundException {
		// 1️. emp_num 기준으로 직원 조회
		var emp = hrmService.getEmployeeById(emp_num);
		if (emp == null) {
			throw new UsernameNotFoundException("존재하지 않는 직원");
		}

		// 2️. 직원 id(Long)로 Users 조회
		User user = userMapper.findById(emp.getId());
		if (user == null) {
			throw new UsernameNotFoundException("계정이 없는 직원");
		}

		// 3. 비활성 계정 차단
		if (user.getIs_active() != 1) {
			throw new DisabledException("비활성 계정");
		}

		// 4. UserDetails 생성
		return org.springframework.security.core.userdetails.User.withUsername(emp.getEmp_num()) // 로그인 시 입력한 emp_num 반환
				.password(user.getUser_pw()) // DB에서 가져온 암호화 비밀번호
				.roles("USER") // 역할 설정
				.build();
	}
}