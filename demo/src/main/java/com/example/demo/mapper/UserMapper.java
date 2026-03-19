package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.Domain.User;

@Mapper
public interface UserMapper {

	// 로그인 및 회원 가입

	// PK 기준 사용자 조회
	User findById(@Param("id") Long id);

	// emp_num 기준 단일 조회용 (참조용)
	User findByEmpNum(@Param("emp_num") String emp_num);

	// 전체 조회
	List<User> findAll();

	// 활성/비활성 토글
	int updateUserActive(@Param("id") Long id, @Param("is_active") int is_active);

	// 신규 사용자 저장 (pw + is_active만)
	void save(User user);

}
