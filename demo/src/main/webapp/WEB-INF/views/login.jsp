<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ taglib prefix="c" uri="jakarta.tags.core" %> --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>로그인</h2>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>


<form action="/login" method="post">
    아이디: <input type="text" name="username" autocomplete="username"><br>
    비밀번호: <input type="password" name="password" autocomplete="current-password"><br>
    <input type="submit" value="로그인">
</form>

<c:if test="${not empty sessionScope.loginError}">
    <div style="color:red;">
        ${sessionScope.loginError}
    </div>
    <c:remove var="loginError" scope="session"/>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>
<!-- 이밑으로 지금 회원가입창으로 갈 수 있도록 만들어 놨어요.  -->
<br>
<button onclick="location.href='/register'">회원가입</button>
</body>
</html>