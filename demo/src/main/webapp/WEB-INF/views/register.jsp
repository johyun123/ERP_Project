<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>회원가입</h2>
<form action="/register" method="post">
    <input type="text" name="user_id" placeholder="아이디" required>
    <input type="password" name="user_pw" placeholder="비밀번호" required>
    <input type="text" name="user_name" placeholder="성함" required>
    <button type="submit">회원가입</button>
</form>
</body>
</html>