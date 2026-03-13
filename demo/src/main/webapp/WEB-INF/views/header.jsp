<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!--임시 변수-->
<%
String userName = "관리자";
String userId = "admin";
String userRank = "시스템관리자";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/header.css" />
</head>
<body>
<!-- 헤더 -->
<div class="header">
	<div class="header-left" onclick="location.href='MainPage.jsp'" style="cursor:pointer;">
		ERP CAFE SYSTEM
	</div>
	<div class="header-right">
		🔔
		<span id="clock"></span>
		👤 <%=userName%>
		<button class="logout-btn" onclick="location.href='logout'">로그아웃</button>
	</div>
</div>

<!-- 사이드 메뉴 -->
<div class="sidebar">

	<div class="menu-title">&lt;메뉴&gt;</div>

	<ul class="menu">
		<li onclick="selectMenu(this); location.href='product'">📦 제품관리</li>
		<li onclick="selectMenu(this); location.href='inventory'">📊 재고관리</li>
		<li onclick="selectMenu(this); location.href='hr'">👥 인사관리</li>
		<li onclick="selectMenu(this); location.href='order'">🧾 주문관리</li>
		<li onclick="selectMenu(this); location.href='finance'">💰 재무관리</li>
		<li onclick="selectMenu(this); location.href='analysis'">📈 데이터분석</li>
		<li onclick="selectMenu(this); location.href='notice'">📢 공지사항</li>
	</ul>

	<!-- 사이드바 하단 유저 정보 -->
	<div class="user-info">
		<div class="user-avatar"><%=userName.substring(0,1) %></div>
		<div class="user-details">
			<div class="user-name"><%=userName %></div>
			<div class="user-id">@<%=userId %></div>
			<div class="user-rank"><%=userRank %></div>
		</div>
	</div>

</div>
</body>

<script>
	/* 메뉴 선택 */
	function selectMenu(menu){
		let menus = document.querySelectorAll(".menu li");
		menus.forEach(m=>{
			m.classList.remove("active");
		});
		menu.classList.add("active");
	}
	/* 시계 */
	function updateClock(){
		let now = new Date();
		let time =
		now.getFullYear()+"-"+
		(now.getMonth()+1)+"-"+
		now.getDate()+" " +
		now.toLocaleTimeString();
		document.getElementById("clock").innerText=time;
	}
	setInterval(updateClock,1000);
</script>

</html>