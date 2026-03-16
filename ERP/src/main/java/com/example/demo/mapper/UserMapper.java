package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.Domain.User;

@Mapper
public interface UserMapper {	
	void save(User user);
	User findById(String user_id);

}
