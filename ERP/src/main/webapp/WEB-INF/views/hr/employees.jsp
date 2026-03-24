<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원 관리 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Employee/employee.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="content">

    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">&#128100;</span>
            <div>
                <h1 class="page-title">직원 관리</h1>
                <p class="page-sub">인사관리 &gt; 직원 관리</p>
            </div>
        </div>
        <button class="btn-register" onclick="location.href='/hr/employees/register'">
            + 직원 등록
        </button>
    </div>

    <!-- 필터 + 검색 바 -->
    <div class="filter-bar">
        <div class="status-tabs">
            <button class="tab-btn active" id="tab-all"      onclick="setTab('all')">전체</button>
            <button class="tab-btn"        id="tab-active"   onclick="setTab('active')">재직</button>
            <button class="tab-btn"        id="tab-leave"    onclick="setTab('leave')">휴직</button>
            <button class="tab-btn"        id="tab-resigned" onclick="setTab('resigned')">퇴사</button>
        </div>
        <div class="search-form">
            <div class="search-wrap">
                <span class="search-icon">&#128269;</span>
                <input type="text" class="search-input" id="searchName"
                       placeholder="이름 검색..." oninput="applyFilter()" />
            </div>
            <div class="search-wrap">
                <input type="text" class="search-input" id="searchPosition"
                       placeholder="직책 검색..." oninput="applyFilter()" />
            </div>
            <button type="button" class="btn-reset" onclick="resetFilter()">초기화</button>
            <span class="filter-count" id="filterCount"></span>
        </div>
    </div>

    <!-- 테이블 -->
    <div class="table-card">
        <table class="emp-table">
            <thead>
                <tr>
                    <th>사원번호</th>
                    <th>이름</th>
                    <th>연락처</th>
                    <th>나이</th>
                    <th>직책</th>
                    <th>입사일</th>
                    <th>퇴사일</th>
                    <th>시급</th>
                    <th>월급</th>
                    <th>풀/파트</th>
                    <th>은행</th>
                    <th>계좌번호</th>
                    <th>재직여부</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody id="empTableBody">
                <c:choose>
                    <c:when test="${empty employees}">
                        <tr><td colspan="14" class="empty-row">등록된 직원이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="emp" items="${employees}">
                        <tr class="emp-row"
                            data-name="${emp.name}"
                            data-position="${emp.position}"
                            data-status="${emp.is_active}">

                            <td class="td-empnum">${emp.emp_num}</td>
                            <td class="td-name">${emp.name}</td>
                            <td class="td-phone">${emp.phone}</td>
                            <td>${emp.age}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.position == '점장'}">
                                        <span class="position-badge pos-a">점장</span>
                                    </c:when>
                                    <c:when test="${emp.position == '매니저'}">
                                        <span class="position-badge pos-b">매니저</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="position-badge pos-c">${emp.position}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="td-date">${emp.hire_date}</td>
                            <td class="td-date">
                                <c:choose>
                                    <c:when test="${empty emp.resign_date}">-</c:when>
                                    <c:otherwise>${emp.resign_date}</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="td-money">
                                <c:choose>
                                    <c:when test="${emp.hourly_wage > 0}">
                                        <fmt:formatNumber value="${emp.hourly_wage}" pattern="#,###"/>원
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="td-money">
                                <c:choose>
                                    <c:when test="${emp.monthly_salary > 0}">
                                        <fmt:formatNumber value="${emp.monthly_salary}" pattern="#,###"/>원
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.contract_type == '풀'}">
                                        <span class="contract-badge full">정규직</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="contract-badge part">파트타임</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${emp.bank_name}</td>
                            <td class="td-account">${emp.account_no}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.is_active == 1}">
                                        <span class="active-badge active">재직</span>
                                    </c:when>
                                    <c:when test="${emp.is_active == 2}">
                                        <span class="active-badge leave">휴직</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="active-badge resigned">퇴사</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="td-actions">
                                <c:choose>
                                    <c:when test="${emp.name == '하하하'}">
                                        <span class="btn-locked" title="보호된 계정입니다">수정 불가</span>
                                        <span class="btn-locked" title="보호된 계정입니다">삭제 불가</span>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-edit"
                                                onclick="location.href='/hr/employees/edit/${emp.emp_num}'">
                                            수정
                                        </button>
                                        <button class="btn-delete"
                                                onclick="confirmDelete('${emp.emp_num}','${emp.name}')">
                                            삭제
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</div>

<form id="deleteForm" action="/hr/employees/delete" method="post" style="display:none;">
    <input type="hidden" id="deleteEmpNum" name="emp_num" />
</form>

<script>
function confirmDelete(empNum, name) {
    if (!confirm(name + ' 직원을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
    document.getElementById('deleteEmpNum').value = empNum;
    document.getElementById('deleteForm').submit();
}

var currentTab = 'all';

function setTab(tab) {
    currentTab = tab;
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    document.getElementById('tab-' + tab).classList.add('active');
    applyFilter();
}

function applyFilter() {
    var name     = document.getElementById('searchName').value.trim().toLowerCase();
    var position = document.getElementById('searchPosition').value.trim().toLowerCase();
    var rows     = document.querySelectorAll('.emp-row');
    var visible  = 0;

    rows.forEach(function(row) {
        var rName     = (row.getAttribute('data-name')     || '').toLowerCase();
        var rPosition = (row.getAttribute('data-position') || '').toLowerCase();
        var rStatus   = row.getAttribute('data-status');

        var nameMatch     = name === ''     || rName.includes(name);
        var positionMatch = position === '' || rPosition.includes(position);
        var tabMatch      = false;

        if      (currentTab === 'all')      tabMatch = true;
        else if (currentTab === 'active')   tabMatch = rStatus === '1';
        else if (currentTab === 'leave')    tabMatch = rStatus === '2';
        else if (currentTab === 'resigned') tabMatch = rStatus === '0';

        var show = nameMatch && positionMatch && tabMatch;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    var countEl = document.getElementById('filterCount');
    if (name || position || currentTab !== 'all') {
        countEl.textContent   = visible + ' / ' + rows.length + '명';
        countEl.style.display = 'inline';
    } else {
        countEl.style.display = 'none';
    }

    var noResult = document.getElementById('noEmpResult');
    if (visible === 0 && rows.length > 0) {
        if (!noResult) {
            var tr = document.createElement('tr');
            tr.id  = 'noEmpResult';
            tr.innerHTML = '<td colspan="14" class="empty-row">조건에 맞는 직원이 없습니다.</td>';
            document.getElementById('empTableBody').appendChild(tr);
        }
    } else {
        if (noResult) noResult.remove();
    }
}

function resetFilter() {
    document.getElementById('searchName').value     = '';
    document.getElementById('searchPosition').value = '';
    currentTab = 'all';
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    document.getElementById('tab-all').classList.add('active');
    applyFilter();
}
</script>

<style>
.btn-locked {
  display: inline-block;
  padding: 5px 10px;
  background: #f1f5f9;
  color: #94a3b8;
  border: 1.5px solid #e2e8f0;
  border-radius: var(--radius-sm, 6px);
  font-size: 0.78rem;
  font-weight: 600;
  font-family: 'Noto Sans KR', sans-serif;
  cursor: not-allowed;
  margin-right: 4px;
}
</style>
</body>
</html>