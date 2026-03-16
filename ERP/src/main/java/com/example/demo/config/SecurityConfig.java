package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
   @Bean //Spring이 만든 객체
   public SecurityFilterChain filterChain(HttpSecurity http) {
      http
      .csrf(csrf -> csrf.disable()) // 위조 요청 방지
      
      .authorizeHttpRequests(auth -> auth
            .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
            .requestMatchers("/login","/regist","/css/**","/images/**").permitAll()
            .anyRequest().authenticated())
      
      .formLogin(login -> login
            .loginPage("/login")
            .loginProcessingUrl("/login")
            .defaultSuccessUrl("/MainPage",true)
            .permitAll()
            //.defaultSuccessUrl("로그인 성공 시 보여주는 URL")
            )
      .logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessUrl("/"));
      return http.build();
   }
   @Bean
   public PasswordEncoder passwordEncoder() {
      return new BCryptPasswordEncoder();
   }
}
