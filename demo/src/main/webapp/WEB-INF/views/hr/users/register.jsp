<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" href="/css/users/user-register.css" />
<link rel="stylesheet" href="/css/header.css" />
<link rel="stylesheet" href="/css/MainPage.css" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/header.jsp" />


	<h2 class="page-title">회원가입</h2>
	<div class="form-container">
		<form action="/hr/users/register" method="post">


			<div class="form-group">
				<label>직원 선택</label> <select name="emp_num" id="empSelect">
					<c:forEach var="emp" items="${employees}">
						<option value="${emp.emp_num}" data-position="${emp.position}">
							${emp.name} (${emp.emp_num}) - ${emp.position}</option>
					</c:forEach>
				</select>
			</div>


			<div class="form-group">
				<label>비밀번호</label> <input type="password" name="user_pw"
					placeholder="비밀번호" required />
			</div>

			<div class="form-group">
				<button type="submit">회원가입</button>
			</div>

			<div class="top-bar">
				<button type="button" onclick="location.href='/hr/users'">뒤로가기</button>
			</div>

			<c:if test="${not empty error}">
				<p style="color: red">${error}</p>
			</c:if>

		</form>

	</div>
</body>
</html>