<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 관리</title>

<link rel="stylesheet" href="/css/header.css"/>
<link rel="stylesheet" href="/css/MainPage.css"/>
<link rel="stylesheet" href="/css/Employee/employee.css"/>

</head>

<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

<div class="page-title">직원 관리</div>

<div class="top-bar">
<button onclick="location.href='/hr/employees/register'">
직원 등록
</button>
</div>

<div class="table-wrapper">

<table class="employee-table">

<thead>
<tr>
<th>이름</th>
<th>나이</th>
<th>연락처</th>
<th>직책</th>
<th>입사일</th>
<th>퇴사일</th>
<th>시급</th>
<th>월급</th>
<th>풀/파트</th>
<th>은행</th>
<th>계좌번호</th>
<th>재직여부</th>
<th>관리</th>
</tr>
</thead>

<tbody>

<c:forEach var="emp" items="${employees}">

<tr>

<td>${emp.name}</td>
<td>${emp.age}</td>
<td>${emp.phone}</td>
<td>${emp.position}</td>
<td>${emp.hire_date}</td>
<td>${emp.resign_date}</td>
<td>${emp.hourly_wage}</td>
<td>${emp.monthly_salary}</td>
<td>${emp.contract_type}</td>
<td>${emp.bank_name}</td>
<td>${emp.account_no}</td>
<td>${emp.is_active}</td>

<td>

<%-- <button class="edit-btn"
onclick="location.href='/hr/employees/edit?emp_num=${emp.emp_num}'">
수정
</button>
 --%>
 
 <button class="edit-btn"
onclick="location.href='/hr/employees/edit/${emp.emp_num}'">
수정
</button>
 
<form action="/hr/employees/delete" method="post" style="display:inline;">
    <input type="hidden" name="emp_num" value="${emp.emp_num}">
    <!-- CSRF 토큰 -->
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <button type="submit" class="delete-btn" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
</form>

</td>

</tr>

</c:forEach>

</tbody>

</table>

</div>

</div>

</body>
</html>