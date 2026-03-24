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
            <button class="tab-btn ${empty param.status || param.status == 'all'      ? 'active' : ''}"
                    onclick="goFilter('all')">전체</button>
            <button class="tab-btn ${param.status == 'active'   ? 'active' : ''}"
                    onclick="goFilter('active')">재직</button>
            <button class="tab-btn ${param.status == 'leave'    ? 'active' : ''}"
                    onclick="goFilter('leave')">휴직</button>
            <button class="tab-btn ${param.status == 'resigned' ? 'active' : ''}"
                    onclick="goFilter('resigned')">퇴사</button>
        </div>
        <div class="search-form">
            <div class="search-wrap">
                <span class="search-icon">&#128269;</span>
                <input type="text" class="search-input" id="searchName"
                       placeholder="이름 검색..."
                       value="${param.name}"
                       onkeydown="if(event.key==='Enter') doSearch()" />
            </div>
            <div class="search-wrap">
                <input type="text" class="search-input" id="searchPosition"
                       placeholder="직책 검색..."
                       value="${param.position}"
                       onkeydown="if(event.key==='Enter') doSearch()" />
            </div>
            <button type="button" class="btn-search" onclick="doSearch()">&#128269; 검색</button>
            <button type="button" class="btn-reset"  onclick="resetFilter()">초기화</button>
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
                                    <c:when test="${emp.emp_num == '222'}">
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
                                    <c:when test="${emp.position == '점장'}">
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


        <!-- ===== 페이지네이션 ===== -->
        <div class="pagination">

            <div class="page-size-select">
                <select onchange="changeSize(this.value)">
                    <option value="10"  ${size == 10  ? 'selected' : ''}>10개씩</option>
                    <option value="20"  ${size == 20  ? 'selected' : ''}>20개씩</option>
                    <option value="50"  ${size == 50  ? 'selected' : ''}>50개씩</option>
                </select>
            </div>

            <div class="page-nav">
                <c:if test="${currentPage > 1}">
                    <button class="page-btn" onclick="goPage(${currentPage - 1})">&#8249;</button>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <button class="page-btn ${i == currentPage ? 'active' : ''}"
                            onclick="goPage(${i})">${i}</button>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <button class="page-btn" onclick="goPage(${currentPage + 1})">&#8250;</button>
                </c:if>
            </div>

            <div class="page-total">총 ${totalCount}명</div>
        </div>

    </div><!-- /content -->


<form id="deleteForm" action="/hr/employees/delete" method="post" style="display:none;">
    <input type="hidden" id="deleteEmpNum" name="emp_num" />
</form>

<script>
/* ================================================================
   서버사이드 페이징 + 필터 네비게이션
================================================================ */
var _currentStatus = '${empty param.status ? "all" : param.status}';
var _currentSize   = ${empty size ? 10 : size};

function buildUrl(page, status, name, position, size) {
    var s   = status   || _currentStatus;
    var n   = name     !== undefined ? name     : document.getElementById('searchName').value.trim();
    var pos = position !== undefined ? position : document.getElementById('searchPosition').value.trim();
    var sz  = size     || _currentSize;
    var url = '/hr/employees?page=' + page + '&size=' + sz + '&status=' + encodeURIComponent(s);
    if (n)   url += '&name='     + encodeURIComponent(n);
    if (pos) url += '&position=' + encodeURIComponent(pos);
    return url;
}

/* 탭 클릭 → 서버 요청 (page=1 리셋) */
function goFilter(status) {
    location.href = buildUrl(1, status);
}

/* 검색 버튼 / Enter */
function doSearch() {
    location.href = buildUrl(1, _currentStatus);
}

/* 페이지 번호 클릭 */
function goPage(p) {
    location.href = buildUrl(p);
}

/* 페이지당 개수 변경 */
function changeSize(s) {
    _currentSize = s;
    location.href = buildUrl(1, _currentStatus,
        document.getElementById('searchName').value.trim(),
        document.getElementById('searchPosition').value.trim(),
        s);
}

/* 필터 초기화 */
function resetFilter() {
    location.href = '/hr/employees?page=1&size=' + _currentSize + '&status=all';
}

/* 직원 삭제 확인 */
function confirmDelete(empNum, name) {
    if (!confirm(name + ' 직원을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
    document.getElementById('deleteEmpNum').value = empNum;
    document.getElementById('deleteForm').submit();
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

/* ===== 페이지네이션 ===== */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-top: 1.5px solid var(--border-light, #e8eaf6);
  flex-wrap: wrap;
  gap: 10px;
}

.page-size-select select {
  padding: 6px 10px;
  border: 1.5px solid var(--border, #dde1f8);
  border-radius: 6px;
  font-size: 0.82rem;
  color: var(--text-secondary, #555);
  font-family: 'Noto Sans KR', sans-serif;
  outline: none;
  cursor: pointer;
  background: #fff;
}

.page-nav {
  display: flex;
  align-items: center;
  gap: 4px;
}

.page-btn {
  min-width: 34px;
  height: 34px;
  padding: 0 8px;
  border: 1.5px solid var(--border, #dde1f8);
  border-radius: 6px;
  background: #fff;
  color: var(--text-secondary, #555);
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.18s;
  font-family: 'Outfit', sans-serif;
}

.page-btn:hover {
  border-color: var(--primary, #5b6ef5);
  color: var(--primary, #5b6ef5);
  background: var(--primary-light, #eef0fe);
}

.page-btn.active {
  background: var(--primary-gradient, linear-gradient(135deg,#5b6ef5,#7c8ff7));
  color: #fff;
  border-color: transparent;
  box-shadow: 0 2px 8px rgba(91,110,245,0.3);
}

.page-total {
  font-size: 0.8rem;
  color: var(--text-muted, #9ca3af);
}

/* 검색 버튼 */
.btn-search {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 0.88rem;
  font-weight: 600;
  font-family: 'Noto Sans KR', sans-serif;
  cursor: pointer;
  border: none;
  background: var(--primary-gradient, linear-gradient(135deg,#5b6ef5,#7c8ff7));
  color: #fff;
  transition: all 0.18s;
  box-shadow: 0 2px 8px rgba(91,110,245,0.25);
}

.btn-search:hover { opacity: 0.88; transform: translateY(-1px); }
</style>
</body>
</html>