<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>ERP CAFE SYSTEM</title>
	<link rel="stylesheet" href="/css/header.css" />
	<link rel="stylesheet" href="/css/MainPage.css" />
</head>

<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<!-- 컨텐츠 -->
	<div class="content">
		<div class="dashboard">
			<div class="card">
				<div class="card-title">오늘 주문</div>
				<div class="card-value">12</div>
			</div>
			<div class="card">
				<div class="card-title">재고 상태</div>
				<div class="card-value">정상</div>
			</div>
			<div class="card">
				<div class="card-title">오늘 매출</div>
				<div class="card-value">₩245,000</div>
			</div>
		</div>
		<div class="chart-box">
			<canvas id="salesChart"></canvas>
		</div>
	</div>
	
<script>
const ctx = document.getElementById('salesChart');
new Chart(ctx, {
	type: 'bar',
	data: {
		labels: ['월','화','수','목','금','토','일'],
		datasets: [{
			label: '주간 매출',
			data: [120,190,300,250,220,400,350],
			backgroundColor: '#6c8cff'
		}]
	},
	options: {
		responsive:true
	}
});
</script>

</body>
</html>