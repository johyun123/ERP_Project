package com.example.demo;

import org.springframework.security.crypto.bcrypt.BCrypt;

public class TestBCrypt {
	public static void main(String[] args) {
		String rawPassword = "222"; // 사용자가 입력한 비밀번호
		String hashedPassword = "$2a$10$Y4teSKbO4pYpW3T5cmPsc..Gl0WLjHRruat5f4hImiutH3LvEWojm"; // DB에 저장된 암호화 비밀번호

		boolean match = BCrypt.checkpw(rawPassword, hashedPassword);

		if (match) {
			System.out.println("비밀번호 일치 ✅");
		} else {
			System.out.println("비밀번호 불일치 ❌");
		}
	}
}