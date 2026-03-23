<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 등록</title>

<link rel="stylesheet" href="/css/header.css" />
<link rel="stylesheet" href="/css/MainPage.css" />
<link rel="stylesheet" href="/css/Employee/employee.css" />

<style>

.employee-register{
    width:700px;
    margin:40px auto;
    background:#3f3b3b;
    padding:40px;
    color:white;
}

.employee-register h2{
    text-align:center;
    margin-bottom:30px;
}

.form-row{
    display:flex;
    margin-bottom:12px;
}

.form-row label{
    width:150px;
}

.form-row input{
    flex:1;
}

.save-btn{
    margin-top:20px;
    float:right;
}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

<div class="employee-register">

<h2>직원 등록</h2>

<form action="/hr/employees/register" method="post">

<div class="form-row">
    <label>직원 번호 :</label>
    <input type="text" name="emp_num">
</div>

<div class="form-row">
<label>이름 :</label>
<input type="text" name="name">
</div>

<div class="form-row">
<label>나이 :</label>
<input type="number" name="age">
</div>

<div class="form-row">
<label>연락처 :</label>
<input type="text" name="phone">
</div>

<div class="form-row">
<label>직책 :</label>
<select name="position">
<option value="">선택</option>
<option value="점장">점장</option>
<option value="매니저">매니저</option>
<option value="스탭">스탭</option>
</select>
</div>

<div class="form-row">
<label>입사일 :</label>
<input type="date" name="hire_date">
</div>

<div class="form-row">
<label>퇴사일 :</label>
<input type="date" name="resign_date">
</div>

<div class="form-row">
<label>시급 :</label>
<input type="number" name="hourly_wage">
</div>

<div class="form-row">
<label>월급 :</label>
<input type="number" name="monthly_salary">
</div>

<div class="form-row">
<label>풀타임/파트타임 :</label>
<select name="contract_type">
<option value="">선택</option>
<option value="풀">풀타임</option>
<option value="파트">파트타임</option>
</select>
</div>

<div class="form-row">
<label>은행명 :</label>
<input type="text" name="bank_name">
</div>

<div class="form-row">
<label>계좌번호 :</label>
<input type="text" name="account_no">
</div>


<button type="submit" class="save-btn">등록</button>
<button type="button" class="save-btn" onclick="location.href='/hr/employees'">
취소</button>

</form>

</div>

</div>

</body>
</html>