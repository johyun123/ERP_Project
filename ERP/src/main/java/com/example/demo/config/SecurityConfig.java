package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.DisabledException;
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
                // ※ /ocr/** 는 영수증 분석 API — 인증 필요 시 이 줄 제거
                .requestMatchers("/login", "/regist", "/css/**", "/images/**", "/ocr/**").permitAll()
                .requestMatchers("/hr/users/**").hasAnyRole("MANAGER", "STAFF")
                .anyRequest().authenticated()
            )
            .formLogin(login -> login
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/MainPage", true)
                .failureHandler((request, response, exception) -> {
                    String errorMsg = exception instanceof DisabledException
                            ? "비활성화된 계정입니다."
                            : "아이디 또는 비밀번호 오류";
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