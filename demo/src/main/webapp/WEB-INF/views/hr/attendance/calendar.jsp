<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>



<link rel="stylesheet" href="/css/attendance/calendar.css"/>
</head>
<body>


<div class="header">
<button onclick="prevMonth()">◀</button>
<h3 id="calendarTitle" onclick="showYearSelector()" style="cursor:pointer;"></h3>
<button onclick="nextMonth()">▶</button>
</div>

<div id="yearSelector" class="selector"></div>
<div id="monthSelector" class="selector"></div>

<table class="calendar">
<thead>
<tr>
<th>일</th><th>월</th><th>화</th><th>수</th>
<th>목</th><th>금</th><th>토</th>
</tr>
</thead>
<tbody id="calendarBody"></tbody>
</table>

<script>

let attendanceData = {};
let attendanceNames = {};

<%
List<Map<String,Object>> countList =
    (List<Map<String,Object>>)request.getAttribute("attendanceCount");

if(countList != null){
    for(Map<String,Object> row : countList){
%>
attendanceData["<%=row.get("work_date")%>"] = <%=row.get("count")%>;
<%
    }
}

List<Map<String,Object>> nameList =
    (List<Map<String,Object>>)request.getAttribute("attendanceNames");

if(nameList != null){
    for(Map<String,Object> row : nameList){
%>
if(!attendanceNames["<%=row.get("work_date")%>"]){
    attendanceNames["<%=row.get("work_date")%>"] = [];
}
attendanceNames["<%=row.get("work_date")%>"].push("<%=row.get("name")%>");
<%
    }
}
%>

let today = new Date();
let currentYear = today.getFullYear();
let currentMonth = today.getMonth();

function renderCalendar(){

    document.getElementById("yearSelector").style.display="none";
    document.getElementById("monthSelector").style.display="none";

    let firstDay = new Date(currentYear, currentMonth, 1).getDay();
    let lastDate = new Date(currentYear, currentMonth + 1, 0).getDate();

    document.getElementById("calendarTitle").innerText =
        currentYear + "년 " + (currentMonth + 1) + "월";

    let body = document.getElementById("calendarBody");
    body.innerHTML = "";

    let row = "<tr>";

    for(let i=0;i<firstDay;i++){
        row += "<td></td>";
    }

    for(let day=1; day<=lastDate; day++){

        let date =
            currentYear + "-" +
            String(currentMonth+1).padStart(2,'0') + "-" +
            String(day).padStart(2,'0');

        let count = attendanceData[date] || 0;
        let countText = count > 0 ? "출근 " + count + "명" : "";

        let names = attendanceNames[date] || [];
        let nameText = names.join("\n");

        row += "<td onclick=\"moveDate('"+date+"')\">" +
               "<div class='day'>" + day + "</div>" +
               "<div style='color:green;font-size:12px'>" + countText + "</div>" +
               "<div class='tooltip'>" + nameText + "</div>" +
               "</td>";

        if((firstDay + day) % 7 === 0){
            row += "</tr><tr>";
        }
    }

    row += "</tr>";
    body.innerHTML = row;
}

/* function showYearSelector(){

    let box = document.getElementById("yearSelector");
    box.style.display = "block";

    let html = "<table>";

    let start = currentYear - 4;

    for(let i=0;i<3;i++){
        html += "<tr>";
        for(let j=0;j<3;j++){
            let y = start + (i*3+j);
            html += "<td onclick='selectYear("+y+")'>" + y + "년</td>";
        }
        html += "</tr>";
    }

    html += "</table>";
    box.innerHTML = html;
} */

function showYearSelector(){

    let box = document.getElementById("yearSelector");
    box.style.display = "block";

    let startYear = currentYear - 100;
    let endYear = currentYear + 10;

    let html = "<div style='height:200px; overflow-y:auto;'>";

    for(let y = startYear; y <= endYear; y++){
        html += "<div style='padding:8px; cursor:pointer;' onclick='selectYear("+y+")'>" 
              + y + "년</div>";
    }

    html += "</div>";

    box.innerHTML = html;
}

function selectYear(year){

    currentYear = year;
    document.getElementById("yearSelector").style.display = "none";

    let box = document.getElementById("monthSelector");
    box.style.display = "block";

    let html = "<table>";

    for(let i=0;i<3;i++){
        html += "<tr>";
        for(let j=1;j<=4;j++){
            let m = i*4 + j;
            html += "<td onclick='selectMonth("+m+")'>" + m + "월</td>";
        }
        html += "</tr>";
    }

    html += "</table>";
    box.innerHTML = html;
}

function selectMonth(month){
    currentMonth = month - 1;
    document.getElementById("monthSelector").style.display = "none";
    renderCalendar();
}

function prevMonth(){
    currentMonth--;
    if(currentMonth < 0){
        currentMonth = 11;
        currentYear--;
    }
    renderCalendar();
}

function nextMonth(){
    currentMonth++;
    if(currentMonth > 11){
        currentMonth = 0;
        currentYear++;
    }
    renderCalendar();
}

function moveDate(date){
    location.href="/hr/attendanceIn?date="+date;
}

renderCalendar();

</script>

</body>
</html>