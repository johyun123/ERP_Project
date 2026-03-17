<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 수정</title>

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

.form-row input, .form-row select{
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

<h2>직원 수정</h2>

<form action="/hr/employees/update" method="post">

<div class="form-row">
    <label>직원 번호 :</label>
    <input type="text" name="emp_num" value="${employee.emp_num}" readonly>
</div>

<div class="form-row">
<label>이름 :</label>
<input type="text" name="name" value="${employee.name}">
</div>

<div class="form-row">
<label>나이 :</label>
<input type="number" name="age" value="${employee.age}">
</div>

<div class="form-row">
<label>연락처 :</label>
<input type="text" name="phone" value="${employee.phone}">
</div>

<div class="form-row">
<label>직책 :</label>
<select name="position">
<option value="">선택</option>
<option value="점장" ${employee.position=='점장'?'selected':''}>점장</option>
<option value="매니저" ${employee.position=='매니저'?'selected':''}>매니저</option>
<option value="스탭" ${employee.position=='스탭'?'selected':''}>스탭</option>
</select>
</div>

<div class="form-row">
<label>입사일 :</label>
<input type="date" name="hire_date" value="${employee.hire_date}">
</div>

<div class="form-row">
<label>퇴사일 :</label>
<input type="date" name="resign_date" value="${employee.resign_date}">
</div>

<div class="form-row">
<label>시급 :</label>
<input type="number" name="hourly_wage" value="${employee.hourly_wage}">
</div>

<div class="form-row">
<label>월급 :</label>
<input type="number" name="monthly_salary" value="${employee.monthly_salary}">
</div>

<div class="form-row">
<label>풀타임/파트타임 :</label>
<select name="contract_type">
<option value="">선택</option>
<option value="풀" ${employee.contract_type=='풀'?'selected':''}>풀타임</option>
<option value="파트" ${employee.contract_type=='파트'?'selected':''}>파트타임</option>
</select>
</div>

<div class="form-row">
<label>은행명 :</label>
<input type="text" name="bank_name" value="${employee.bank_name}">
</div>

<div class="form-row">
<label>계좌번호 :</label>
<input type="text" name="account_no" value="${employee.account_no}">
</div>

<div class="form-row">
<label>재직 여부 :</label>
<select name="is_active">
<option value="1" ${employee.is_active == 1 ? 'selected' : ''}>재직</option>
<option value="2" ${employee.is_active == 2 ? 'selected' : ''}>휴직</option>
<option value="0" ${employee.is_active == 0 ? 'selected' : ''}>퇴사</option>
</select>
</div>

<button type="submit" class="save-btn">수정</button>
<button type="button" class="save-btn" onclick="location.href='/hr/employees'">
취소</button>


</form>

</div>

</div>

</body>
</html>