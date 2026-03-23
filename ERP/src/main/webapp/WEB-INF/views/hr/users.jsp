<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ERP 사용자 관리 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Common.css" />
    <link rel="stylesheet" href="/css/users/user-management.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp" />

<%-- 등록된 id 목록 문자열 생성 (,1,3,7, 형태) --%>
<c:set var="userIdSet" value="," />
<c:forEach var="u" items="${users}">
    <c:set var="userIdSet" value="${userIdSet}${u.id}," />
</c:forEach>

<div class="content">

    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">&#128272;</span>
            <div>
                <h1 class="page-title">ERP 사용자 관리</h1>
                <p class="page-sub">인사관리 &gt; ERP 사용자 관리</p>
            </div>
        </div>
        <button class="btn-register" onclick="openAuthModal('register')">
            + 새 계정 등록
        </button>
    </div>

    <c:if test="${param.msg == 'registered'}">
        <div class="alert-success">계정이 등록되었습니다.</div>
    </c:if>
    <c:if test="${param.msg == 'pw_changed'}">
        <div class="alert-success">비밀번호가 변경되었습니다.</div>
    </c:if>
    <c:if test="${param.msg == 'pw_error'}">
        <div class="alert-error-bar">비밀번호 변경 중 오류가 발생했습니다.</div>
    </c:if>
    <c:if test="${param.msg == 'del_done'}">
        <div class="alert-success">계정이 삭제되었습니다.</div>
    </c:if>
    <c:if test="${param.msg == 'del_error'}">
        <div class="alert-error-bar">계정 삭제 중 오류가 발생했습니다.</div>
    </c:if>

    <!-- 등록된 계정 목록 -->
    <div class="section-header">
        <span class="section-title">&#128101; 등록된 계정 목록</span>
    </div>

    <div class="table-card" style="margin-bottom:36px; overflow-x:auto;">
        <table class="user-table" style="min-width:820px;">
            <thead>
                <tr>
                    <th>사원번호</th>
                    <th>이름</th>
                    <th>직위</th>
                    <th>고용형태</th>
                    <th>입사일</th>
                    <th>재직상태</th>
                    <th>활성여부</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty users}">
                        <tr><td colspan="8" class="empty-row">등록된 계정이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="u" items="${users}">
                        <c:set var="emp" value="${empMapById[u.id]}" />
                        <tr>
                            <td class="td-empnum">${emp.emp_num}</td>
                            <td class="td-name">${emp.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.position == '점장'}"><span class="pos-badge pos-a">점장</span></c:when>
                                    <c:when test="${emp.position == '매니저'}"><span class="pos-badge pos-b">매니저</span></c:when>
                                    <c:otherwise><span class="pos-badge pos-c">${emp.position}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.contract_type == '풀'}"><span class="contract-badge full">정규직</span></c:when>
                                    <c:otherwise><span class="contract-badge part">파트타임</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="td-date">${emp.hire_date}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.is_active == 1}"><span class="status-badge active">재직</span></c:when>
                                    <c:when test="${emp.is_active == 2}"><span class="status-badge leave">휴직</span></c:when>
                                    <c:otherwise><span class="status-badge resigned">퇴사</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.is_active == 1}"><span class="active-badge on">활성</span></c:when>
                                    <c:otherwise><span class="active-badge off">비활성</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-cell">
                                    <c:choose>
                                        <c:when test="${emp.name == '하하하'}">
                                            <span class="btn-locked">보호된 계정</span>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="/hr/users/toggle" method="post" style="display:inline;">
                                                <input type="hidden" name="emp_num" value="${emp.emp_num}" />
                                                <button type="submit"
                                                        class="${u.is_active == 1 ? 'btn-deactivate' : 'btn-activate'}">
                                                    <c:choose>
                                                        <c:when test="${u.is_active == 1}">비활성화</c:when>
                                                        <c:otherwise>활성화</c:otherwise>
                                                    </c:choose>
                                                </button>
                                            </form>
                                            <button class="btn-pw"
                                                    onclick="openAuthModal('pwchange','${emp.emp_num}','${emp.name}')">
                                                비밀번호 변경
                                            </button>
                                            <button class="btn-del-user"
                                                    onclick="openAuthModal('deleteuser','${emp.emp_num}','${emp.name}')">
                                                계정 삭제
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 전체 직원 목록 -->
    <div class="section-header">
        <span class="section-title">&#128100; 전체 직원 목록</span>
    </div>

    <div class="table-card" style="overflow-x:auto;">
        <table class="user-table" style="min-width:920px;">
            <thead>
                <tr>
                    <th>사원번호</th><th>이름</th><th>나이</th><th>연락처</th>
                    <th>직위</th><th>고용형태</th><th>시급</th><th>월급</th>
                    <th>입사일</th><th>은행</th><th>계좌번호</th><th>재직상태</th><th>ERP계정</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="emp" items="${employees}">
                <tr>
                    <td class="td-empnum">${emp.emp_num}</td>
                    <td class="td-name">${emp.name}</td>
                    <td>${emp.age}</td>
                    <td class="td-phone">${emp.phone}</td>
                    <td>
                        <c:choose>
                            <c:when test="${emp.position == '점장'}"><span class="pos-badge pos-a">점장</span></c:when>
                            <c:when test="${emp.position == '매니저'}"><span class="pos-badge pos-b">매니저</span></c:when>
                            <c:otherwise><span class="pos-badge pos-c">${emp.position}</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${emp.contract_type == '풀'}"><span class="contract-badge full">정규직</span></c:when>
                            <c:otherwise><span class="contract-badge part">파트타임</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td class="td-money">
                        <c:choose>
                            <c:when test="${emp.hourly_wage > 0}"><fmt:formatNumber value="${emp.hourly_wage}" pattern="#,###"/>원</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="td-money">
                        <c:choose>
                            <c:when test="${emp.monthly_salary > 0}"><fmt:formatNumber value="${emp.monthly_salary}" pattern="#,###"/>원</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="td-date">${emp.hire_date}</td>
                    <td>${emp.bank_name}</td>
                    <td class="td-account">${emp.account_no}</td>
                    <td>
                        <c:choose>
                            <c:when test="${emp.is_active == 1}"><span class="status-badge active">재직</span></c:when>
                            <c:when test="${emp.is_active == 2}"><span class="status-badge leave">휴직</span></c:when>
                            <c:otherwise><span class="status-badge resigned">퇴사</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${fn:contains(userIdSet, ','.concat(emp.id).concat(','))}">
                                <span class="acct-badge has">등록됨</span>
                            </c:when>
                            <c:otherwise>
                                <span class="acct-badge none">미등록</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div>

<!-- ===== 관리자 인증 모달 ===== -->
<div class="modal-overlay" id="authModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">&#128274; 관리자 인증</span>
            <button class="modal-close" onclick="closeAuthModal()">&#10005;</button>
        </div>
        <div class="modal-body">
            <p class="auth-desc" id="authDesc">이 작업은 관리자 인증이 필요합니다.</p>
            <div class="form-group" style="margin-bottom:14px;">
                <label class="form-label required">사원번호 (아이디)</label>
                <input type="text" class="form-input" id="authId" placeholder="사원번호 입력" />
            </div>
            <div class="form-group" style="margin-bottom:6px;">
                <label class="form-label required">비밀번호</label>
                <input type="password" class="form-input" id="authPw" placeholder="비밀번호 입력"
                       onkeydown="if(event.key==='Enter') submitAuth()" />
            </div>
            <p class="auth-error" id="authError"></p>
            <div class="modal-actions">
                <button class="btn-cancel" onclick="closeAuthModal()">취소</button>
                <button class="btn-submit" onclick="submitAuth()">인증</button>
            </div>
        </div>
    </div>
</div>

<!-- 비밀번호 변경용 hidden form -->
<form id="pwChangeForm" action="/hr/users/pw-change" method="post" style="display:none;">
    <input type="hidden" id="pwEmpNum"  name="emp_num" />
    <input type="hidden" id="pwNewPass" name="new_pw" />
</form>

<!-- 계정 삭제용 hidden form -->
<form id="delUserForm" action="/hr/users/delete" method="post" style="display:none;">
    <input type="hidden" id="delEmpNum" name="emp_num" />
</form>

<script>
/* ===== 모달 상태 ===== */
var _pendingAction = null;   // 'register' | 'pwchange'
var _pendingEmpNum = null;
var _pendingName   = null;

function openAuthModal(action, empNum, name) {
    _pendingAction = action;
    _pendingEmpNum = empNum || null;
    _pendingName   = name   || null;

    document.getElementById('authId').value = '';
    document.getElementById('authPw').value = '';
    document.getElementById('authError').innerText = '';

    var desc = document.getElementById('authDesc');
    if (action === 'pwchange') {
        desc.innerText = name + ' 직원의 비밀번호를 변경하려면 관리자 인증이 필요합니다.';
    } else {
        desc.innerText = '새 계정 등록을 위해 관리자 인증이 필요합니다.';
    }

    document.getElementById('authModal').classList.add('active');
    setTimeout(function() { document.getElementById('authId').focus(); }, 200);
}

function closeAuthModal() {
    document.getElementById('authModal').classList.remove('active');
}

/* 모달 바깥 클릭 시 닫기 */
document.getElementById('authModal').addEventListener('click', function(e) {
    if (e.target === this) closeAuthModal();
});

/* ===== 인증 요청 ===== */
function submitAuth() {
    var uid = document.getElementById('authId').value.trim();
    var upw = document.getElementById('authPw').value.trim();
    if (!uid || !upw) {
        document.getElementById('authError').innerText = '아이디와 비밀번호를 입력해주세요.';
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/hr/users/auth', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (xhr.responseText.trim() === 'ok') {
            closeAuthModal();
            if (_pendingAction === 'register') {
                location.href = '/hr/users/register';
            } else if (_pendingAction === 'pwchange') {
                openPwChangePrompt(_pendingEmpNum, _pendingName);
            } else if (_pendingAction === 'deleteuser') {
                execDeleteUser(_pendingEmpNum, _pendingName);
            }
        } else {
            document.getElementById('authError').innerText = '아이디 또는 비밀번호가 올바르지 않습니다.';
        }
    };
    xhr.send('userId=' + encodeURIComponent(uid) + '&userPw=' + encodeURIComponent(upw));
}

/* ===== 계정 삭제 ===== */
function execDeleteUser(empNum, name) {
    if (!confirm(name + ' 직원의 ERP 계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
    document.getElementById('delEmpNum').value = empNum;
    document.getElementById('delUserForm').submit();
}

/* ===== 비밀번호 변경 프롬프트 ===== */
function openPwChangePrompt(empNum, name) {
    var pw1 = prompt(name + ' 직원의 새 비밀번호를 입력하세요 (4자 이상):');
    if (pw1 === null) return;
    if (pw1.length < 4) { alert('비밀번호는 4자 이상이어야 합니다.'); return; }

    var pw2 = prompt('비밀번호를 한 번 더 입력하세요:');
    if (pw2 === null) return;
    if (pw1 !== pw2) { alert('비밀번호가 일치하지 않습니다.'); return; }

    document.getElementById('pwEmpNum').value  = empNum;
    document.getElementById('pwNewPass').value = pw1;
    document.getElementById('pwChangeForm').submit();
}
</script>

</body>
</html>
