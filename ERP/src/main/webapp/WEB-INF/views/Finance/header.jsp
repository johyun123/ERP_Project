<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 임시 변수 (추후 세션으로 교체) --%>
<%
String userName = "관리자";
String userId   = "admin";
String userRank = "시스템관리자";
%>

<link rel="stylesheet" href="/css/header.css" />

<!-- ===== 헤더 ===== -->
<div class="header">
    <div class="header-left" onclick="location.href='/MainPage'">ERP CAFE SYSTEM</div>
    <div class="header-right">
        🔔
        <span id="clock"></span>
        👤 <%=userName%>
        <button class="logout-btn" onclick="location.href='/logout'">로그아웃</button>
    </div>
</div>

<!-- ===== 사이드바 ===== -->
<div class="sidebar">

    <div class="menu-title">&lt;메뉴&gt;</div>

    <ul class="menu">

        <li class="has-submenu" onclick="toggleSubmenu(this)">📦 제품관리
            <ul class="submenu">
                <li onclick="event.stopPropagation(); location.href='/product/menu'">메뉴 관리</li>
                <li onclick="event.stopPropagation(); location.href='/product/recipe'">레시피 관리</li>
            </ul>
        </li>

        <li class="has-submenu" onclick="toggleSubmenu(this)">📊 재고관리
            <ul class="submenu">
                <li onclick="event.stopPropagation(); location.href='/inventory'">재고 현황</li>
                <li onclick="event.stopPropagation(); location.href='/inventory/vendor/register'">거래처 등록</li>
                <li onclick="event.stopPropagation(); location.href='/inventory/vendor'">거래처 관리</li>
                <li onclick="event.stopPropagation(); location.href='/inventory/order/history'">발주 내역</li>
                <li onclick="event.stopPropagation(); location.href='/inventory/order'">발주</li>
            </ul>
        </li>

        <li class="has-submenu" onclick="toggleSubmenu(this)">👥 인사관리
            <ul class="submenu">
                <li onclick="event.stopPropagation(); location.href='/hr/attendance'">근태 관리</li>
                <li onclick="event.stopPropagation(); location.href='/hr/employees/register'">직원 등록</li>
                <li onclick="event.stopPropagation(); location.href='/hr/employees'">직원 관리</li>
                <li onclick="event.stopPropagation(); location.href='/hr/users'">사용자 관리</li>
            </ul>
        </li>

        <li class="has-submenu" onclick="toggleSubmenu(this)">🧾 주문관리
            <ul class="submenu">
                <li onclick="event.stopPropagation(); location.href='/order'">주문 내역</li>
            </ul>
        </li>

        <li class="has-submenu" onclick="toggleSubmenu(this)">💰 재무관리
            <ul class="submenu">
                <li onclick="event.stopPropagation(); location.href='/f_register'">지출 등록</li>
                <li onclick="event.stopPropagation(); location.href='/f_list'">지출 내역</li>
                <li onclick="event.stopPropagation(); location.href='/f_payrolls'">급여 내역</li>
            </ul>
        </li>

        <li class="has-submenu" onclick="toggleSubmenu(this)">📈 데이터분석
            <ul class="submenu">
                <li onclick="event.stopPropagation(); location.href='/analysis/statement'">재무제표 조회</li>
                <li onclick="event.stopPropagation(); location.href='/analysis/check'">재무점검</li>
            </ul>
        </li>

    </ul>

    <!-- 사이드바 하단 유저 정보 -->
    <div class="user-info">
        <div class="user-avatar"><%=userName.substring(0,1)%></div>
        <div class="user-details">
            <div class="user-name"><%=userName%></div>
            <div class="user-id">@<%=userId%></div>
            <div class="user-rank"><%=userRank%></div>
        </div>
    </div>

</div>

<script>
    /* 시계 */
    function updateClock() {
        const now = new Date();
        const time = now.getFullYear() + "-" +
                     (now.getMonth() + 1) + "-" +
                     now.getDate() + " " +
                     now.toLocaleTimeString();
        document.getElementById("clock").innerText = time;
    }
    setInterval(updateClock, 1000);
    updateClock();

    /* 서브메뉴 토글 (한 번에 하나만 열림) */
    function toggleSubmenu(menu) {
        const isOpen = menu.classList.contains('open');
        document.querySelectorAll('.has-submenu').forEach(m => m.classList.remove('open'));
        if (!isOpen) menu.classList.add('open');
    }

    /* 현재 URL로 메뉴 자동 활성화 */
    function setActiveMenu() {
	    const path = location.pathname;
	    document.querySelectorAll('.menu > li').forEach(li => {
	        li.querySelectorAll('.submenu li').forEach(sub => {
	            const href = sub.getAttribute('onclick')?.match(/location\.href='([^']+)'/)?.[1];
	            if (href && path === href) {
	                li.classList.add('open');
	                sub.classList.add('active');
	            }
	        });
	    });
	}
    setActiveMenu();
</script>
