<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자 관리</title>


<link rel="stylesheet" href="/css/header.css" />
<link rel="stylesheet" href="/css/MainPage.css" />
<link rel="stylesheet" href="/css/users/user-management.css" />

</head>
<body>


	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="content">
		<h2 class="page-title">ERP 사용자 관리</h2>

		<!-- 새 사용자 등록 버튼 -->
		<div class="top-bar">
			<a href="/hr/users/register"><button class="btn">새 계정 등록</button></a>
		</div>

		<div class="table-container">
			<!-- 사용자 목록 테이블 -->
			<h3 class="section-title">등록된 사용자 목록</h3>

			<table class="custom-table">
				<tr>
					<th>사원번호</th>
					<th>이름</th>
					<th>직위</th>
					<th>활성 여부</th>
					<!-- 필요하면 삭제 버튼도 추가 -->
					<th>관리</th>
				</tr>
				<c:forEach var="users" items="${users}">
					<tr>
						<td>${empMapById[users.id].emp_num}</td>
						<td>${empMapById[users.id].name}</td>
						<td>${empMapById[users.id].position}</td>



						<td><c:choose>
								<c:when test="${users.is_active eq 1}">활성</c:when>
								<c:otherwise>비활성</c:otherwise>
							</c:choose></td>
						<td>
							<!-- 예시: 계정 비활성화/삭제 버튼 -->

							<form action="/hr/users/toggle" method="post"
								style="display: inline">



								<!-- 이건 그대로 유지 가능 (emp_num → controller에서 employees 조회용) -->
								<input type="hidden" name="emp_num"
									value="${empMapById[users.id].emp_num}">
								<button type="submit" class="btn">
									<c:choose>
										<c:when test="${users.is_active eq 1}">비활성화</c:when>
										<c:otherwise>활성화</c:otherwise>
									</c:choose>
								</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</table>

			<!-- 직원 목록 참고 (선택적으로 계정 생성 시 사용) -->
			<h3 class="section-title">직원 목록</h3>
			<table class="custom-table">
				<tr>
					<th>사원번호</th>
					<th>이름</th>
					<th>직위</th>
					<th>재직 상태</th>
				</tr>
				<c:forEach var="emp" items="${employees}">
					<tr>
						<td>${emp.emp_num}</td>
						<td>${emp.name}</td>
						<td>${emp.position}</td>
						<td><c:choose>
								<c:when test="${emp.is_active eq 1}">재직</c:when>
								<c:when test="${emp.is_active eq 2}">휴직</c:when>
								<c:otherwise>퇴사</c:otherwise>
							</c:choose></td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
</html>