<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<html>

<%
String userName = "관리자";
String userId = "admin";
String userRank = "시스템관리자";
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>
<title>근태 관리</title>

<link rel="stylesheet" href="/css/header.css"/>
<link rel="stylesheet" href="/css/MainPage.css"/>
</head>

<body>



<h2>근태 관리</h2>


<jsp:include page="/WEB-INF/views/header.jsp"/>
<div class="content">
<jsp:include page="attendance/calendar.jsp" />

</div>
</body>
</html>

