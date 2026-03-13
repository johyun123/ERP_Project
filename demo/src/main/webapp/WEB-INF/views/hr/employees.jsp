<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<%
String userName = "관리자";
String userId = "admin";
String userRank = "시스템관리자";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ERP CAFE SYSTEM</title>


<link rel="stylesheet" href="/css/header.css" />
<link rel="stylesheet" href="/css/MainPage.css" />
<link rel="stylesheet" href="/css/Employee/employee.css" />

</head>

<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<!-- 컨텐츠 -->

<div class="content">

	<div class="dashboard">
	
	<!-- 제목 -->
        <div class="page-title">
            직원 관리
        </div>

        <!-- 직원 등록 버튼 -->
        <div class="top-bar">
            <button onclick="location.href='/hr/employees/register'">직원 등록</button>
        </div>

        <!-- 직원 목록 테이블 -->
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
                    <th>은행명</th>
                    <th>계좌번호</th>
                    <th>재직여부</th>
                    <th>정규?</th>
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
    				<td>${emp.bankName}</td>
    				<td>${emp.accountNo}</td>
    				<td>${emp.is_account_no}</td>   
    				              
                    <td>
                        <button onclick="location.href='/hr/employees/register'">수정</button>
                        <button class="delete-btn">삭제</button>
                    </td>
                </tr>
				</c:forEach>
            </tbody>

        </table>
	
	
	
	</div>


</div>



</body>
</html>