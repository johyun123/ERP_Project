//package com.example.demo.Domain;
//
//public class User {
//	private Long id; // PK
//	private String user_id; // DB 컬럼명과 일치
//	private String user_pw; // DB 컬럼명과 일치
//
//	// getter / setter
//	public Long getId() {
//		return id;
//	}
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public String getUser_id() {
//		return user_id;
//	}
//
//	public void setUser_id(String user_id) {
//		this.user_id = user_id;
//	}
//
//	public String getUser_pw() {
//		return user_pw;
//	}
//
//	public void setUser_pw(String user_pw) {
//		this.user_pw = user_pw;
//	}
//}

//package com.example.demo.Domain;
//
//public class User {
//	private Long id;
//	private String user_id;
//	private String user_pw;
//
//	// getter / setter
//	public Long getId() {
//		return id;
//	}
//
//	public void setId(Long id) {
//		this.id = id;
//	}
//
//	public String getUser_id() {
//		return user_id;
//	}
//
//	public void setUser_id(String user_id) {
//		this.user_id = user_id;
//	}
//
//	public String getUser_pw() {
//		return user_pw;
//	}
//
//	public void setUser_pw(String user_pw) {
//		this.user_pw = user_pw;
//	}
//}

package com.example.demo.Domain;

public class User {

	private String user_id;
	private String user_pw;
	private String user_name;

	// getter / setter
	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getUser_pw() {
		return user_pw;
	}

	public void setUser_pw(String user_pw) {
		this.user_pw = user_pw;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

}
