<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>급여 내역 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Finance/F_payrolls.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <!-- 페이지 헤더 -->
    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">💵</span>
            <div>
                <h1 class="page-title">급여 내역</h1>
                <p class="page-sub">재무관리 &gt; 급여 내역</p>
            </div>
        </div>
        <button class="btn btn-primary" onclick="openAuthModal('manual')">+ 급여 수동처리</button>
    </div>

    <!-- 알림 메시지 -->
    <c:if test="${not empty msg}">
        <div class="alert-box">${msg}</div>
    </c:if>

    <!-- 필터 바 -->
    <div class="filter-bar">
        <select class="filter-input" id="filterYear" onchange="applyFilter()">
            <option value="">전체 연도</option>
            <option value="2025">2025</option>
            <option value="2026">2026</option>
        </select>
        <select class="filter-input" id="filterMonth" onchange="applyFilter()">
            <option value="">전체 월</option>
            <c:forEach begin="1" end="12" var="m">
                <option value="${m}">${m}월</option>
            </c:forEach>
        </select>
        <button class="btn btn-reset" onclick="resetFilter()">초기화</button>
    </div>

    <!-- 테이블 -->
    <div class="table-card">
        <table class="payroll-table">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>직원명</th>
                    <th>사원번호</th>
                    <th>지급연월</th>
                    <th>근무시간</th>
                    <th>기본급</th>
                    <th>공제액</th>
                    <th>실수령액</th>
                    <th>지급일</th>
                    <th>메모</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <c:choose>
                    <c:when test="${empty payrollList}">
                        <tr><td colspan="11" class="empty-row">등록된 급여 내역이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${payrollList}" varStatus="s">
                        <tr class="payroll-row"
                            data-year="${p.payYear}"
                            data-month="${p.payMonth}">
                            <td class="td-no">${s.count}</td>
                            <td class="td-name">${empty p.employeeName ? '-' : p.employeeName}</td>
                            <td class="td-empid">${p.employeeId}</td>
                            <td>${p.payYear}년 ${p.payMonth}월</td>
                            <td>${p.workHours}h</td>
                            <td class="td-money"><fmt:formatNumber value="${p.basePay}" pattern="#,###"/>원</td>
                            <td class="td-deduct"><fmt:formatNumber value="${p.deduction}" pattern="#,###"/>원</td>
                            <td class="td-net"><fmt:formatNumber value="${p.netPay}" pattern="#,###"/>원</td>
                            <td class="td-date">${empty p.paidAt ? '-' : p.paidAt}</td>
                            <td class="td-note">${empty p.note ? '-' : p.note}</td>
                            <td class="td-actions">
                                <button class="btn-icon btn-edit"
                                    onclick="openAuthModal('edit',
                                        ${p.id}, ${p.employeeId}, ${p.payYear}, ${p.payMonth},
                                        ${p.workHours}, ${p.basePay}, ${p.deduction}, ${p.netPay},
                                        '${empty p.paidAt ? "" : p.paidAt}',
                                        '${empty p.note ? "" : p.note}')">&#9999;&#65039;</button>
                                <button class="btn-icon btn-delete"
                                    onclick="openAuthModal('delete', ${p.id})">&#128465;&#65039;</button>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</div>

<!-- ===== 관리자 인증 모달 ===== -->
<div class="modal-overlay" id="authModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">&#128272; 관리자 인증</span>
            <button class="modal-close" onclick="closeModal('authModal')">&#10005;</button>
        </div>
        <div class="modal-body">
            <p class="auth-desc">이 작업은 관리자 인증이 필요합니다.</p>
            <div class="form-group">
                <label class="form-label required">사원번호 (아이디)</label>
                <input type="text" class="form-input" id="authId" placeholder="사원번호 입력" />
            </div>
            <div class="form-group">
                <label class="form-label required">비밀번호</label>
                <input type="password" class="form-input" id="authPw" placeholder="비밀번호 입력"
                       onkeydown="if(event.key==='Enter') submitAuth()" />
            </div>
            <p class="auth-error" id="authError"></p>
            <div class="modal-actions">
                <button class="btn btn-cancel" onclick="closeModal('authModal')">취소</button>
                <button class="btn btn-primary" onclick="submitAuth()">인증</button>
            </div>
        </div>
    </div>
</div>

<!-- ===== 수정 모달 ===== -->
<div class="modal-overlay" id="editModal">
    <div class="modal modal-wide">
        <div class="modal-header">
            <span class="modal-title">급여 수정</span>
            <button class="modal-close" onclick="closeModal('editModal')">&#10005;</button>
        </div>
        <div class="modal-body">
            <form id="editForm" action="/payroll/update" method="post">
                <input type="hidden" id="editId"         name="id" />
                <input type="hidden" id="editEmployeeId" name="employeeId" />
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label required">지급 연도</label>
                        <input type="number" class="form-input" id="editYear" name="payYear" min="2020" max="2099" />
                    </div>
                    <div class="form-group">
                        <label class="form-label required">지급 월</label>
                        <input type="number" class="form-input" id="editMonth" name="payMonth" min="1" max="12" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">근무시간</label>
                        <input type="number" class="form-input" id="editWorkHours" name="workHours" step="0.1" />
                    </div>
                    <div class="form-group">
                        <label class="form-label required">기본급</label>
                        <div class="input-wrap">
                            <input type="text" class="form-input input-with-unit" id="editBasePayDisp" oninput="formatAmount(this)" />
                            <input type="hidden" id="editBasePay" name="basePay" />
                            <span class="input-unit">원</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">공제액</label>
                        <div class="input-wrap">
                            <input type="text" class="form-input input-with-unit" id="editDeductionDisp" oninput="formatAmount(this)" />
                            <input type="hidden" id="editDeduction" name="deduction" />
                            <span class="input-unit">원</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label required">실수령액</label>
                        <div class="input-wrap">
                            <input type="text" class="form-input input-with-unit" id="editNetPayDisp" oninput="formatAmount(this)" />
                            <input type="hidden" id="editNetPay" name="netPay" />
                            <span class="input-unit">원</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">지급일</label>
                        <input type="date" class="form-input" id="editPaidAt" name="paidAt" />
                    </div>
                    <div class="form-group form-group-full">
                        <label class="form-label">메모</label>
                        <textarea class="form-input form-textarea" id="editNote" name="note"></textarea>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitEdit()">저장</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===== 급여 수동처리 모달 ===== -->
<div class="modal-overlay" id="manualModal">
    <div class="modal modal-wide">
        <div class="modal-header">
            <span class="modal-title">&#128181; 급여 수동처리</span>
            <button class="modal-close" onclick="closeModal('manualModal')">&#10005;</button>
        </div>
        <div class="modal-body">
            <form id="manualForm" action="/payroll/manual" method="post">
                <input type="hidden" name="employeeId" id="manualEmpId" />

                <!-- 직원 선택 드롭다운 -->
                <div class="form-group form-group-full manual-select-wrap">
                    <label class="form-label required">직원 선택</label>
                    <select class="form-input" id="manualEmpSelect" onchange="onEmpSelect(this)">
                        <option value="">-- 직원을 선택하세요 --</option>
                        <c:forEach var="e" items="${employeeList}">
                            <option value="${e.id}"
                                    data-empnum="${e.empNum}"
                                    data-name="${e.name}"
                                    data-type="${e.contractType}"
                                    data-wage="${e.hourlyWage}"
                                    data-salary="${e.monthlySalary}">
                                [${e.empNum}] ${e.name} (${e.position} / ${e.contractType})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-grid">

                    <!-- 직원명 (고정) -->
                    <div class="form-group">
                        <label class="form-label">직원명 <span class="lock-badge">&#128274;</span></label>
                        <input type="text" class="form-input field-locked" id="manualName"
                               readonly placeholder="직원 선택 시 자동입력" />
                    </div>

                    <!-- 사원번호 (고정) -->
                    <div class="form-group">
                        <label class="form-label">사원번호 <span class="lock-badge">&#128274;</span></label>
                        <input type="text" class="form-input field-locked" id="manualEmpNum"
                               readonly placeholder="직원 선택 시 자동입력" />
                    </div>

                    <!-- 지급 연도 -->
                    <div class="form-group">
                        <label class="form-label required">지급 연도</label>
                        <input type="number" class="form-input" name="payYear" id="manualYear"
                               min="2020" max="2099" />
                    </div>

                    <!-- 지급 월 -->
                    <div class="form-group">
                        <label class="form-label required">지급 월</label>
                        <input type="number" class="form-input" name="payMonth" id="manualMonth"
                               min="1" max="12" />
                    </div>

                    <!-- 근무시간 -->
                    <div class="form-group">
                        <label class="form-label" id="workHoursLabel">근무시간</label>
                        <div class="input-wrap">
                            <input type="number" class="form-input input-with-unit"
                                   name="workHours" id="manualWorkHours"
                                   step="0.1" value="0" min="0"
                                   oninput="onWorkHoursInput()" />
                            <span class="input-unit">h</span>
                        </div>
                        <span class="field-hint" id="workHoursHint"></span>
                    </div>

                    <!-- 기본급 (고정) -->
                    <div class="form-group">
                        <label class="form-label">기본급 <span class="lock-badge">&#128274;</span></label>
                        <div class="input-wrap">
                            <input type="text" class="form-input input-with-unit field-locked"
                                   id="manualBaseDisp" readonly placeholder="직원 선택 후 자동계산" />
                            <input type="hidden" name="basePay" id="manualBasePay" />
                            <span class="input-unit">원</span>
                        </div>
                        <span class="field-hint" id="basePayHint"></span>
                    </div>

                    <!-- 공제액 (고정 — 자동계산) -->
                    <div class="form-group">
                        <label class="form-label">공제액 <span class="calc-badge">자동 9.4%</span></label>
                        <div class="input-wrap">
                            <input type="text" class="form-input input-with-unit field-locked"
                                   id="manualDeductDisp" readonly />
                            <input type="hidden" name="deduction" id="manualDeduction" />
                            <span class="input-unit">원</span>
                        </div>
                        <span class="field-hint">4대보험 기준 자동계산</span>
                    </div>

                    <!-- 실수령액 (수정 가능) -->
                    <div class="form-group">
                        <label class="form-label required">실수령액</label>
                        <div class="input-wrap">
                            <input type="text" class="form-input input-with-unit"
                                   id="manualNetDisp"
                                   oninput="formatAmountInput(this, 'manualNetPay')"
                                   placeholder="자동계산 또는 직접 수정" />
                            <input type="hidden" name="netPay" id="manualNetPay" />
                            <span class="input-unit">원</span>
                        </div>
                    </div>

                    <!-- 지급일 -->
                    <div class="form-group">
                        <label class="form-label">지급일</label>
                        <input type="date" class="form-input" name="paidAt" id="manualPaidAt" />
                    </div>

                    <!-- 메모 -->
                    <div class="form-group form-group-full">
                        <label class="form-label">메모</label>
                        <textarea class="form-input form-textarea" name="note"></textarea>
                    </div>

                </div>

                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('manualModal')">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitManual()">처리</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 삭제용 hidden form -->
<form id="deleteForm" action="/payroll/delete" method="post" style="display:none;">
    <input type="hidden" id="deleteId" name="id" />
</form>

<script>
    /* ===== 필터 ===== */
    function applyFilter() {
        var year  = document.getElementById('filterYear').value;
        var month = document.getElementById('filterMonth').value;
        document.querySelectorAll('.payroll-row').forEach(function(row) {
            var ry = row.getAttribute('data-year');
            var rm = row.getAttribute('data-month');
            var ok = (!year || ry === year) && (!month || rm === month);
            row.style.display = ok ? '' : 'none';
        });
    }

    function resetFilter() {
        document.getElementById('filterYear').value  = '';
        document.getElementById('filterMonth').value = '';
        document.querySelectorAll('.payroll-row').forEach(function(r) { r.style.display = ''; });
    }

    /* ===== 모달 ===== */
    function openModal(id)  { document.getElementById(id).classList.add('active'); }
    function closeModal(id) { document.getElementById(id).classList.remove('active'); }

    document.querySelectorAll('.modal-overlay').forEach(function(o) {
        o.addEventListener('click', function(e) { if (e.target === o) closeModal(o.id); });
    });

    /* ===== 관리자 인증 ===== */
    var _pendingAction = null;
    var _pendingArgs   = [];

    function openAuthModal(action) {
        _pendingAction = action;
        _pendingArgs   = Array.prototype.slice.call(arguments, 1);
        document.getElementById('authId').value        = '';
        document.getElementById('authPw').value        = '';
        document.getElementById('authError').innerText = '';
        openModal('authModal');
        setTimeout(function() { document.getElementById('authId').focus(); }, 200);
    }

    function submitAuth() {
        var uid = document.getElementById('authId').value.trim();
        var upw = document.getElementById('authPw').value.trim();
        if (!uid || !upw) {
            document.getElementById('authError').innerText = '아이디와 비밀번호를 입력해주세요.';
            return;
        }
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/payroll/auth', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            if (xhr.responseText === 'ok') {
                closeModal('authModal');
                if      (_pendingAction === 'edit')   { openEditModal.apply(null, _pendingArgs); }
                else if (_pendingAction === 'delete') { execDelete(_pendingArgs[0]); }
                else if (_pendingAction === 'manual') { openManualModal(); }
            } else {
                document.getElementById('authError').innerText = '아이디 또는 비밀번호가 올바르지 않습니다.';
            }
        };
        xhr.send('userId=' + encodeURIComponent(uid) + '&userPw=' + encodeURIComponent(upw));
    }

    /* ===== 수정 모달 ===== */
    function openEditModal(id, empId, year, month, workHours, basePay, deduction, netPay, paidAt, note) {
        document.getElementById('editId').value             = id;
        document.getElementById('editEmployeeId').value     = empId;
        document.getElementById('editYear').value           = year;
        document.getElementById('editMonth').value          = month;
        document.getElementById('editWorkHours').value      = workHours;
        document.getElementById('editBasePayDisp').value    = Number(basePay).toLocaleString();
        document.getElementById('editBasePay').value        = basePay;
        document.getElementById('editDeductionDisp').value  = Number(deduction).toLocaleString();
        document.getElementById('editDeduction').value      = deduction;
        document.getElementById('editNetPayDisp').value     = Number(netPay).toLocaleString();
        document.getElementById('editNetPay').value         = netPay;
        document.getElementById('editPaidAt').value         = paidAt;
        document.getElementById('editNote').value           = note;
        openModal('editModal');
    }

    function formatAmount(input) {
        var val = input.value.replace(/[^0-9]/g, '');
        input.value = val ? Number(val).toLocaleString() : '';
    }

    function submitEdit() {
        document.getElementById('editBasePay').value   = document.getElementById('editBasePayDisp').value.replace(/,/g,'');
        document.getElementById('editDeduction').value = document.getElementById('editDeductionDisp').value.replace(/,/g,'');
        document.getElementById('editNetPay').value    = document.getElementById('editNetPayDisp').value.replace(/,/g,'');
        document.getElementById('editForm').submit();
    }

    /* ===== 삭제 ===== */
    function execDelete(id) {
        if (!confirm('해당 급여 내역을 삭제하시겠습니까?')) return;
        document.getElementById('deleteId').value = id;
        document.getElementById('deleteForm').submit();
    }

    /* ===== 수동처리 모달 열기 (초기화) ===== */
    var _contractType = '';
    var _hourlyWage   = 0;

    function openManualModal() {
        document.getElementById('manualEmpSelect').value   = '';
        document.getElementById('manualEmpId').value       = '';
        document.getElementById('manualName').value        = '';
        document.getElementById('manualEmpNum').value      = '';
        document.getElementById('manualWorkHours').value   = '0';
        document.getElementById('manualBaseDisp').value    = '';
        document.getElementById('manualBasePay').value     = '';
        document.getElementById('manualDeductDisp').value  = '';
        document.getElementById('manualDeduction').value   = '';
        document.getElementById('manualNetDisp').value     = '';
        document.getElementById('manualNetPay').value      = '';
        document.getElementById('manualPaidAt').value      = '';
        document.getElementById('basePayHint').innerText   = '';
        document.getElementById('workHoursHint').innerText = '';
        document.getElementById('workHoursLabel').innerText = '근무시간';
        _contractType = '';
        _hourlyWage   = 0;
        openModal('manualModal');
    }

    /* ===== 직원 선택 ===== */
    function onEmpSelect(select) {
        var opt = select.options[select.selectedIndex];

        if (!opt.value) {
            document.getElementById('manualEmpId').value       = '';
            document.getElementById('manualName').value        = '';
            document.getElementById('manualEmpNum').value      = '';
            document.getElementById('manualBaseDisp').value    = '';
            document.getElementById('manualBasePay').value     = '';
            document.getElementById('manualDeductDisp').value  = '';
            document.getElementById('manualDeduction').value   = '';
            document.getElementById('manualNetDisp').value     = '';
            document.getElementById('manualNetPay').value      = '';
            document.getElementById('basePayHint').innerText   = '';
            document.getElementById('workHoursHint').innerText = '';
            document.getElementById('workHoursLabel').innerText = '근무시간';
            _contractType = '';
            _hourlyWage   = 0;
            return;
        }

        _contractType = opt.getAttribute('data-type');
        _hourlyWage   = parseInt(opt.getAttribute('data-wage')   || '0');
        var salary    = parseInt(opt.getAttribute('data-salary') || '0');

        document.getElementById('manualEmpId').value  = opt.value;
        document.getElementById('manualName').value   = opt.getAttribute('data-name');
        document.getElementById('manualEmpNum').value = opt.getAttribute('data-empnum');

        if (_contractType === '풀') {
            document.getElementById('workHoursLabel').innerText  = '근무시간';
            document.getElementById('workHoursHint').innerText   = '정규직은 기록용 (기본급에 영향 없음)';
            document.getElementById('basePayHint').innerText     = '정규직 월급 고정';
            calcAndSetPay(salary);
        } else {
            document.getElementById('workHoursLabel').innerText  = '근무시간 (입력 필수)';
            document.getElementById('workHoursHint').innerText   = '시급 ' + _hourlyWage.toLocaleString() + '원/h — 시간 입력 시 기본급 자동계산';
            document.getElementById('basePayHint').innerText     = '시급 x 근무시간 자동계산';
            var hours = parseFloat(document.getElementById('manualWorkHours').value) || 0;
            calcAndSetPay(Math.round(_hourlyWage * hours));
        }
    }

    /* ===== 근무시간 입력 → 파트타임 기본급 실시간 반영 ===== */
    function onWorkHoursInput() {
        if (_contractType !== '파트') return;
        var hours = parseFloat(document.getElementById('manualWorkHours').value) || 0;
        calcAndSetPay(Math.round(_hourlyWage * hours));
    }

    /* ===== 기본급 기준으로 공제액·실수령액 자동계산 ===== */
    function calcAndSetPay(basePay) {
        var deduction = Math.round(basePay * 0.094);
        var netPay    = basePay - deduction;

        document.getElementById('manualBaseDisp').value   = basePay.toLocaleString();
        document.getElementById('manualBasePay').value    = basePay;
        document.getElementById('manualDeductDisp').value = deduction.toLocaleString();
        document.getElementById('manualDeduction').value  = deduction;
        document.getElementById('manualNetDisp').value    = netPay.toLocaleString();
        document.getElementById('manualNetPay').value     = netPay;
    }

    /* ===== 실수령액 직접 수정 시 콤마 포맷 ===== */
    function formatAmountInput(dispInput, hiddenId) {
        var val = dispInput.value.replace(/[^0-9]/g, '');
        dispInput.value = val ? Number(val).toLocaleString() : '';
        document.getElementById(hiddenId).value = val || '0';
    }

    /* ===== 수동처리 제출 유효성 검사 ===== */
    function submitManual() {
        if (!document.getElementById('manualEmpId').value) {
            alert('직원을 선택해주세요.');
            return;
        }
        if (!document.getElementById('manualYear').value || !document.getElementById('manualMonth').value) {
            alert('지급 연월을 입력해주세요.');
            return;
        }
        if (!document.getElementById('manualBasePay').value) {
            alert('기본급이 계산되지 않았습니다.\n직원을 다시 선택해주세요.');
            return;
        }
        document.getElementById('manualForm').submit();
    }
</script>

</body>
</html>
