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

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                .requestMatchers("/login", "/regist", "/css/**", "/images/**", "/ocr/**").permitAll()
                // ERP 사용자 관리 — 점장(MANAGER), 스탭(STAFF)만 접근
                // UserDetailsServiceImpl에서 roles("MANAGER") / roles("STAFF") 로 세팅 필요
                .requestMatchers("/hr/users/**").hasAnyRole("MANAGER", "STAFF")
                .anyRequest().authenticated()
            )
            .formLogin(login -> login
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/MainPage", true)
                .failureHandler((request, response, exception) -> {
                    String errorMsg = "아이디 또는 비밀번호 오류";
                    if (exception instanceof org.springframework.security.authentication.DisabledException) {
                        errorMsg = "비활성화된 계정입니다.";
                    }
                    request.getSession().setAttribute("loginError", errorMsg);
                    response.sendRedirect("/login");
                })
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
            );
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}