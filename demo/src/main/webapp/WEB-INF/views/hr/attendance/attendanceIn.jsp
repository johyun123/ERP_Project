<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>

<head>

<title>근태 상세</title>

<link rel="stylesheet" href="/css/header.css" />
<link rel="stylesheet" href="/css/MainPage.css" />

<style>
table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: center;
}

th {
	background: #f2f2f2;
}

input {
	width: 100%;
	border: none;
	text-align: center;
}
</style>

</head>

<body>

	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="content">

		<h2>${date}근태 현황</h2>

		<form action="/hr/saveAttendance" method="post">

			<table>

				<tr>
					<th>직원ID</th>
					<th>직원이름</th>
					<th>근무날짜</th>
					<th>출근시간</th>
					<th>근무시간</th>
					<th>퇴근시간</th>
					<th>특이사항</th>
				</tr>

				<c:forEach var="a" items="${attendance}" varStatus="s">

					<tr>

						<!-- 직원 ID -->
						<td><input type="text" name="list[${s.index}].employee_id"
							value="${a.employee_id}" readonly></td>

						<!-- 이름 -->
						<td>${a.name}</td>

						<!-- 날짜 -->
						<td><input type="text" name="list[${s.index}].work_date_str"
							value="${date}" readonly></td>

						<!-- 출근시간 -->
						<td><input type="time" name="list[${s.index}].clock_in_str"
							value="${a.clock_in}"></td>

						<!-- 근무시간 (자동 계산, 입력 불가) -->
						<td><input type="text" name="list[${s.index}].work_hours_str"
							value="${a.work_hours}" readonly></td>

						<!-- 퇴근시간 -->
						<td><input type="time" name="list[${s.index}].clock_out_str"
							value="${a.clock_out}"></td>

						<!-- 특이사항 -->
						<td><input type="text" name="list[${s.index}].note"
							value="${a.note}"></td>

					</tr>

				</c:forEach>

			</table>

			<br>

			<button type="submit">저장</button>

		</form>

		<br> <a href="/hr/attendance">← 달력으로 돌아가기</a>

	</div>

	<!-- ===== JS: 근무시간 자동 계산, 점심시간 제외, 입력 방지 ===== -->
	<script>
function calcWorkHours(row){
    let clockIn = row.querySelector("[name*='clock_in']").value;
    let clockOut = row.querySelector("[name*='clock_out']").value;
    let workHoursInput = row.querySelector("[name*='work_hours']");

    if(clockIn && clockOut){
        let inTime = new Date("2000-01-01T" + clockIn);
        let outTime = new Date("2000-01-01T" + clockOut);

        let diff = (outTime - inTime) / 1000 / 60 / 60; // 시간 단위

        if(diff < 0){
            alert("퇴근시간이 출근시간보다 빠릅니다");
            workHoursInput.value = "";
            return;
        }

        // 점심시간 1시간 제외 (근무 6시간 이상)
        if(diff >= 6){
            diff -= 1;
        }

        workHoursInput.value = diff.toFixed(1);
    }
}

document.addEventListener("DOMContentLoaded", function(){
    let rows = document.querySelectorAll("table tr");

    rows.forEach(function(row){
        let inInput = row.querySelector("[name*='clock_in']");
        let outInput = row.querySelector("[name*='clock_out']");

        if(inInput && outInput){
            inInput.addEventListener("change", function(){
                calcWorkHours(row);
            });
            outInput.addEventListener("change", function(){
                calcWorkHours(row);
            });
        }
    });
});
</script>

</body>
</html>