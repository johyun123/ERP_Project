<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ERP 계정 등록 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/common.css" />
    <link rel="stylesheet" href="/css/users/user-management.css" />
    <link rel="stylesheet" href="/css/users/user-register.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp" />

<!-- 직원 데이터를 JS 배열로 주입 (퇴사자 + 이미 계정 있는 직원 제외) -->
<script>
var EMP_DATA = [
    <c:forEach var="emp" items="${employees}">
        <c:if test="${emp.is_active != 0 and !registeredIds.contains(emp.id)}">
        {
            emp_num  : "${emp.emp_num}",
            name     : "${emp.name}",
            age      : "${emp.age}",
            phone    : "${emp.phone}",
            position : "${emp.position}",
            contract : "${emp.contract_type}",
            hourly   : ${emp.hourly_wage},
            salary   : ${emp.monthly_salary},
            hire     : "${emp.hire_date}",
            bank     : "${emp.bank_name}",
            account  : "${emp.account_no}",
            status   : ${emp.is_active}
        },
        </c:if>
    </c:forEach>
];
</script>

<div class="content">

    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">&#128272;</span>
            <div>
                <h1 class="page-title">ERP 계정 등록</h1>
                <p class="page-sub">인사관리 &gt; ERP 사용자 관리 &gt; 계정 등록</p>
            </div>
        </div>
        <a href="/hr/users" class="btn-back">&#8592; 목록으로</a>
    </div>

    <div class="reg-card" style="max-width:860px;">

        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <form action="/hr/users/register" method="post" id="regForm">
            <input type="hidden" name="emp_num" id="hiddenEmpNum" />

            <!-- 직원 선택 -->
            <p class="reg-section-title">&#128100; 직원 선택</p>

            <!-- 검색 + 직급 필터 -->
            <div class="emp-filter-bar">
                <div class="search-wrap">
                    <span class="search-icon">&#128269;</span>
                    <input type="text" class="search-input" id="searchName"
                           placeholder="이름 검색..." oninput="applyFilter()" />
                </div>
                <div class="pos-filter-tabs">
                    <button type="button" class="pos-tab active" id="pos-all"    onclick="setPos('all')">전체</button>
                    <button type="button" class="pos-tab"        id="pos-점장"   onclick="setPos('점장')">점장</button>
                    <button type="button" class="pos-tab"        id="pos-매니저" onclick="setPos('매니저')">매니저</button>
                    <button type="button" class="pos-tab"        id="pos-스탭"   onclick="setPos('스탭')">스탭</button>
                </div>
                <span class="filter-count" id="filterCount"></span>
            </div>

            <!-- 직원 테이블 -->
            <div class="emp-table-wrap">
                <table class="emp-pick-table">
                    <thead>
                        <tr>
                            <th>선택</th><th>사원번호</th><th>이름</th>
                            <th>직위</th><th>고용형태</th><th>재직상태</th>
                        </tr>
                    </thead>
                    <tbody id="empPickBody"></tbody>
                </table>
            </div>
            <div class="pick-paging" id="pickPaging"></div>

            <!-- 선택된 직원 정보 -->
            <div class="emp-info-box" id="empInfoBox" style="display:none;">
                <p class="info-box-title">&#128100; 선택된 직원 정보</p>
                <div class="info-grid">
                    <div class="info-item"><span class="info-label">사원번호</span><span class="info-value" id="dispEmpNum">-</span></div>
                    <div class="info-item"><span class="info-label">이름</span><span class="info-value" id="dispName">-</span></div>
                    <div class="info-item"><span class="info-label">나이</span><span class="info-value" id="dispAge">-</span></div>
                    <div class="info-item"><span class="info-label">연락처</span><span class="info-value" id="dispPhone">-</span></div>
                    <div class="info-item"><span class="info-label">직위</span><span class="info-value" id="dispPosition">-</span></div>
                    <div class="info-item"><span class="info-label">고용형태</span><span class="info-value" id="dispContract">-</span></div>
                    <div class="info-item"><span class="info-label">시급</span><span class="info-value" id="dispHourly">-</span></div>
                    <div class="info-item"><span class="info-label">월급</span><span class="info-value" id="dispSalary">-</span></div>
                    <div class="info-item"><span class="info-label">입사일</span><span class="info-value" id="dispHire">-</span></div>
                    <div class="info-item"><span class="info-label">은행</span><span class="info-value" id="dispBank">-</span></div>
                    <div class="info-item"><span class="info-label">계좌번호</span><span class="info-value" id="dispAccount">-</span></div>
                </div>
            </div>

            <!-- 비밀번호 -->
            <p class="reg-section-title" style="margin-top:28px;">&#128274; 비밀번호 설정</p>
            <div class="pw-section">
                <div class="form-group pw-group">
                    <label class="form-label required">비밀번호</label>
                    <input type="password" class="form-input" name="user_pw"
                           id="userPw" placeholder="비밀번호를 입력하세요" />
                </div>
                <div class="form-group pw-group">
                    <label class="form-label required">비밀번호 확인</label>
                    <input type="password" class="form-input" id="userPwConfirm"
                           placeholder="비밀번호를 다시 입력하세요" oninput="checkPw()" />
                    <span class="pw-hint" id="pwHint"></span>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="location.href='/hr/users'">취소</button>
                <button type="button" class="btn-submit" onclick="submitReg()">등록</button>
            </div>
        </form>
    </div>
</div>

<script>
/* ===== 상태 ===== */
var PAGE_SIZE    = 5;
var currentPage  = 1;
var currentPos   = 'all';
var currentName  = '';
var selectedEmp  = null;
var filteredData = [];

function applyFilter() {
    currentName = document.getElementById('searchName').value.trim().toLowerCase();
    currentPage = 1;
    runFilter();
}

function setPos(pos) {
    currentPos  = pos;
    currentPage = 1;
    document.querySelectorAll('.pos-tab').forEach(function(b) { b.classList.remove('active'); });
    document.getElementById('pos-' + pos).classList.add('active');
    runFilter();
}

function runFilter() {
    filteredData = EMP_DATA.filter(function(e) {
        var nameMatch = currentName === '' || e.name.toLowerCase().includes(currentName);
        var posMatch  = currentPos  === 'all' || e.position === currentPos;
        return nameMatch && posMatch;
    });
    document.getElementById('filterCount').textContent   = filteredData.length + '명';
    document.getElementById('filterCount').style.display = 'inline';
    renderTable();
    renderPaging();
}

function renderTable() {
    var tbody = document.getElementById('empPickBody');
    var start = (currentPage - 1) * PAGE_SIZE;
    var end   = Math.min(start + PAGE_SIZE, filteredData.length);
    var html  = '';

    if (filteredData.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="empty-row">계정 미등록 직원이 없습니다.</td></tr>';
        return;
    }

    for (var i = start; i < end; i++) {
        var e      = filteredData[i];
        var isSel  = selectedEmp && selectedEmp.emp_num === e.emp_num;
        var posCls = e.position === '점장' ? 'pos-a' : e.position === '매니저' ? 'pos-b' : 'pos-c';
        var conLbl = e.contract === '풀'
            ? '<span class="contract-badge full">정규직</span>'
            : '<span class="contract-badge part">파트타임</span>';
        var stLbl  = e.status === 2
            ? '<span class="status-badge leave">휴직</span>'
            : '<span class="status-badge active">재직</span>';

        html += '<tr class="pick-row' + (isSel ? ' selected' : '') + '" onclick="selectEmp(' + i + ')">'
              + '<td><span class="pick-radio' + (isSel ? ' checked' : '') + '"></span></td>'
              + '<td class="td-empnum">' + e.emp_num   + '</td>'
              + '<td class="td-name">'   + e.name      + '</td>'
              + '<td><span class="pos-badge ' + posCls + '">' + e.position + '</span></td>'
              + '<td>' + conLbl + '</td>'
              + '<td>' + stLbl  + '</td>'
              + '</tr>';
    }
    tbody.innerHTML = html;
}

function renderPaging() {
    var total    = Math.ceil(filteredData.length / PAGE_SIZE);
    var pagingEl = document.getElementById('pickPaging');
    if (total <= 1) { pagingEl.innerHTML = ''; return; }

    var html = '';
    html += '<button type="button" class="page-btn" onclick="goPage(' + (currentPage - 1) + ')"'
          + (currentPage === 1 ? ' disabled' : '') + '>&#8249;</button>';
    for (var p = 1; p <= total; p++) {
        html += '<button type="button" class="page-btn' + (p === currentPage ? ' active' : '')
              + '" onclick="goPage(' + p + ')">' + p + '</button>';
    }
    html += '<button type="button" class="page-btn" onclick="goPage(' + (currentPage + 1) + ')"'
          + (currentPage === total ? ' disabled' : '') + '>&#8250;</button>';
    pagingEl.innerHTML = html;
}

function goPage(p) {
    var total = Math.ceil(filteredData.length / PAGE_SIZE);
    if (p < 1 || p > total) return;
    currentPage = p;
    renderTable();
    renderPaging();
}

function selectEmp(filteredIdx) {
    selectedEmp = filteredData[filteredIdx];
    document.getElementById('hiddenEmpNum').value = selectedEmp.emp_num;

    document.getElementById('dispEmpNum').textContent   = selectedEmp.emp_num;
    document.getElementById('dispName').textContent     = selectedEmp.name;
    document.getElementById('dispAge').textContent      = selectedEmp.age      || '-';
    document.getElementById('dispPhone').textContent    = selectedEmp.phone    || '-';
    document.getElementById('dispPosition').textContent = selectedEmp.position;
    document.getElementById('dispContract').textContent = selectedEmp.contract === '풀' ? '정규직' : '파트타임';
    document.getElementById('dispHourly').textContent   = selectedEmp.hourly > 0 ? selectedEmp.hourly.toLocaleString() + '원/h' : '-';
    document.getElementById('dispSalary').textContent   = selectedEmp.salary > 0 ? selectedEmp.salary.toLocaleString() + '원'   : '-';
    document.getElementById('dispHire').textContent     = selectedEmp.hire    || '-';
    document.getElementById('dispBank').textContent     = selectedEmp.bank    || '-';
    document.getElementById('dispAccount').textContent  = selectedEmp.account || '-';

    document.getElementById('empInfoBox').style.display = 'block';
    renderTable();
}

function checkPw() {
    var pw   = document.getElementById('userPw').value;
    var conf = document.getElementById('userPwConfirm').value;
    var hint = document.getElementById('pwHint');
    if (!conf) { hint.textContent = ''; return; }
    if (pw === conf) {
        hint.textContent = '✓ 비밀번호가 일치합니다.';
        hint.style.color = '#16a34a';
    } else {
        hint.textContent = '✗ 비밀번호가 일치하지 않습니다.';
        hint.style.color = '#dc2626';
    }
}

function submitReg() {
    var empNum = document.getElementById('hiddenEmpNum').value;
    var pw     = document.getElementById('userPw').value;
    var conf   = document.getElementById('userPwConfirm').value;
    if (!empNum)       { alert('직원을 선택해주세요.'); return; }
    if (!pw)           { alert('비밀번호를 입력해주세요.'); return; }
    if (pw.length < 4) { alert('비밀번호는 4자 이상이어야 합니다.'); return; }
    if (pw !== conf)   { alert('비밀번호가 일치하지 않습니다.'); return; }
    document.getElementById('regForm').submit();
}

/* 초기 렌더링 */
runFilter();
</script>

</body>
</html>