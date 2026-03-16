package com.example.demo.Service;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.demo.Domain.User;
import com.example.demo.mapper.UserMapper;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
	 private final UserMapper userMapper;
	    
	 UserDetailsServiceImpl(UserMapper userMapper){
		 this.userMapper = userMapper;
	 }
	 
	    @Override
	    public UserDetails loadUserByUsername(String user_id) {
	        User user = userMapper.findById(user_id);
	        if (user == null) throw new UsernameNotFoundException("없는 사용자");
	        
	        return org.springframework.security.core.userdetails.User
	                .withUsername(user.getUser_id())
	                .password(user.getUser_pw())
	                .roles("USER")
	                .build();
	    }
}
