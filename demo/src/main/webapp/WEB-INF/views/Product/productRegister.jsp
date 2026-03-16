<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제품 등록</title>

<link rel="stylesheet" href="/css/Product/productRegister.css" />
</head>

<body>

<div class="title">
제품 등록
</div>

<div class="register-box">

<form action="productInsert" method="post">

	<div class="input-box">
		<label>제품명</label>
		<input type="text" name="productName">
	</div>

	<div class="input-box">
		<label>가격</label>
		<input type="number" name="price">
	</div>

	<button class="btn">
	등록
	</button>

</form>

</div>

</body>
</html>