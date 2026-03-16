<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출 내역 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Finance/F_list.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <!-- 페이지 헤더 -->
    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">💳</span>
            <div>
                <h1 class="page-title">지출 내역</h1>
                <p class="page-sub">재무관리 &gt; 지출 내역</p>
            </div>
        </div>
        <button class="btn btn-primary" onclick="location.href='/f_register'">+ 지출 등록</button>
    </div>

    <!-- 검색/필터 바 -->
    <div class="filter-bar">
        <select class="filter-input" id="filterType" onchange="applyFilter()">
            <option value="">전체 유형</option>
            <option value="재료비">재료비</option>
            <option value="인건비">인건비</option>
            <option value="임대료">임대료</option>
            <option value="공과금">공과금</option>
            <option value="소모품">소모품</option>
            <option value="마케팅">마케팅</option>
            <option value="기타">기타</option>
        </select>
        <input type="date" class="filter-input" id="filterDateFrom" onchange="applyFilter()" />
        <span class="filter-sep">~</span>
        <input type="date" class="filter-input" id="filterDateTo" onchange="applyFilter()" />
        <button class="btn btn-reset" onclick="resetFilter()">초기화</button>
    </div>

    <!-- 테이블 -->
    <div class="table-card">
        <table class="expense-table">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>지출 날짜</th>
                    <th>지출 유형</th>
                    <th>금액</th>
                    <th>비고</th>
                    <th>등록자</th>
                    <th>등록일시</th>
                    <th>영수증</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <%-- JSTL로 목록 출력 --%>
                <c:choose>
                    <c:when test="${empty expenseList}">
                        <tr>
                            <td colspan="9" class="empty-row">등록된 지출 내역이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="exp" items="${expenseList}" varStatus="status">
                        <tr class="expense-row" data-type="${exp.expenseType}" data-date="${exp.expenseDate}">
                            <td class="td-no">${status.count}</td>
                            <td>${exp.expenseDate}</td>
                            <td><span class="type-badge type-${exp.expenseType}">${exp.expenseType}</span></td>
                            <td class="td-amount"><fmt:formatNumber value="${exp.amount}" pattern="#,###"/>원</td>
                            <td class="td-desc">${empty exp.description ? '-' : exp.description}</td>
                            <td>${empty exp.registeredBy ? '-' : exp.registeredBy}</td>
                            <td class="td-date">${exp.createdAt}</td>
                            <td>
                                <button class="btn-icon btn-receipt" onclick="openReceiptPopup(${exp.id})">🧾 조회</button>
                            </td>
                            <td class="td-actions">
                                <button class="btn-icon btn-edit" onclick="openEditModal(${exp.id}, '${exp.expenseType}', ${exp.amount}, '${exp.expenseDate}', '${empty exp.description ? "" : exp.description}')">✏️</button>
                                <button class="btn-icon btn-delete" onclick="deleteExpense(${exp.id})">🗑️</button>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</div>

<!-- ===== 수정 모달 ===== -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">지출 수정</span>
            <button class="modal-close" onclick="closeModal('editModal')">✕</button>
        </div>
        <div class="modal-body">
            <form id="editForm" action="/f_update" method="post">
                <input type="hidden" id="editId" name="id" />

                <div class="form-group">
                    <label class="form-label required">지출 날짜</label>
                    <input type="date" class="form-input" id="editDate" name="expenseDate" />
                </div>
                <div class="form-group">
                    <label class="form-label required">지출 유형</label>
                    <select class="form-input form-select" id="editType" name="expenseType">
                        <option value="재료비">재료비</option>
                        <option value="인건비">인건비</option>
                        <option value="임대료">임대료</option>
                        <option value="공과금">공과금</option>
                        <option value="소모품">소모품</option>
                        <option value="마케팅">마케팅</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label required">금액</label>
                    <div class="input-wrap">
                        <input type="text" class="form-input input-with-unit" id="editAmountDisplay"
                               placeholder="0" oninput="formatAmount(this)" />
                        <input type="hidden" id="editAmount" name="amount" />
                        <span class="input-unit">원</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">비고</label>
                    <textarea class="form-input form-textarea" id="editDesc" name="description"
                              placeholder="추가 메모를 입력하세요"></textarea>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitEdit()">저장</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===== 영수증 팝업 ===== -->
<div class="modal-overlay" id="receiptModal">
    <div class="modal modal-receipt">
        <div class="modal-header">
            <span class="modal-title">🧾 영수증 조회</span>
            <button class="modal-close" onclick="closeModal('receiptModal')">✕</button>
        </div>
        <div class="modal-body">
            <div class="receipt-preview-wrap" id="receiptPreviewWrap">
                <div class="receipt-empty" id="receiptEmpty">등록된 영수증이 없습니다.</div>
                <img id="receiptImg" class="receipt-img" src="" alt="영수증" style="display:none;" />
            </div>

            <div class="receipt-upload-section">
                <label class="form-label">영수증 변경</label>
                <div class="file-drop-area" id="receiptDropArea" onclick="document.getElementById('receiptUpload').click()">
                    <input type="file" id="receiptUpload" accept="image/*,.pdf" style="display:none;"
                           onchange="previewReceipt(this)" />
                    <div class="file-drop-icon">📎</div>
                    <div class="file-drop-text" id="receiptDropText">
                        클릭하거나 파일을 드래그하여 업로드<br>
                        <span class="file-drop-hint">JPG, PNG, PDF 지원</span>
                    </div>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('receiptModal')">닫기</button>
                <button type="button" class="btn btn-primary" onclick="applyReceipt()">적용</button>
            </div>
        </div>
    </div>
</div>

<script>
    /* ===== 필터 ===== */
    function applyFilter() {
        const type     = document.getElementById('filterType').value;
        const dateFrom = document.getElementById('filterDateFrom').value;
        const dateTo   = document.getElementById('filterDateTo').value;

        document.querySelectorAll('.expense-row').forEach(function(row) {
            const rowType = row.getAttribute('data-type');
            const rowDate = row.getAttribute('data-date');

            const typeMatch = !type || rowType === type;
            const fromMatch = !dateFrom || rowDate >= dateFrom;
            const toMatch   = !dateTo   || rowDate <= dateTo;

            row.style.display = (typeMatch && fromMatch && toMatch) ? '' : 'none';
        });
    }

    function resetFilter() {
        document.getElementById('filterType').value     = '';
        document.getElementById('filterDateFrom').value = '';
        document.getElementById('filterDateTo').value   = '';
        document.querySelectorAll('.expense-row').forEach(function(row) {
            row.style.display = '';
        });
    }

    /* ===== 금액 콤마 포맷 ===== */
    function formatAmount(input) {
        var val = input.value.replace(/[^0-9]/g, '');
        input.value = val ? Number(val).toLocaleString() : '';
    }

    /* ===== 모달 ===== */
    function openModal(id) {
        document.getElementById(id).classList.add('active');
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('active');
    }

    /* ===== 수정 모달 ===== */
    function openEditModal(id, type, amount, date, desc) {
        document.getElementById('editId').value            = id;
        document.getElementById('editDate').value          = date;
        document.getElementById('editType').value          = type;
        document.getElementById('editAmountDisplay').value = Number(amount).toLocaleString();
        document.getElementById('editAmount').value        = amount;
        document.getElementById('editDesc').value          = desc;
        openModal('editModal');
    }

    function submitEdit() {
        var raw = document.getElementById('editAmountDisplay').value.replace(/,/g, '');
        if (!raw) { alert('금액을 입력해주세요.'); return; }
        document.getElementById('editAmount').value = raw;
        document.getElementById('editForm').submit();
    }

    /* ===== 삭제 ===== */
    function deleteExpense(id) {
        if (!confirm('해당 지출 내역을 삭제하시겠습니까?')) return;
        var form = document.createElement('form');
        form.method = 'post';
        form.action = '/f_delete';
        var input = document.createElement('input');
        input.type  = 'hidden';
        input.name  = 'id';
        input.value = id;
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }

    /* ===== 영수증 팝업 ===== */
    var currentReceiptId = null;

    function openReceiptPopup(id) {
        currentReceiptId = id;
        // TODO: fetch로 영수증 URL 조회 후 표시
        // 현재는 프론트 구조만 구현
        document.getElementById('receiptImg').style.display = 'none';
        document.getElementById('receiptEmpty').style.display = 'block';
        document.getElementById('receiptDropText').innerHTML =
            '클릭하거나 파일을 드래그하여 업로드<br><span class="file-drop-hint">JPG, PNG, PDF 지원</span>';
        document.getElementById('receiptDropArea').classList.remove('has-file');
        openModal('receiptModal');
    }

    function previewReceipt(input) {
        var file = input.files[0];
        if (!file) return;

        var sizeKB = (file.size / 1024).toFixed(1);
        document.getElementById('receiptDropText').innerHTML =
            '<strong>' + file.name + '</strong><br><span class="file-drop-hint">' + sizeKB + ' KB</span>';
        document.getElementById('receiptDropArea').classList.add('has-file');

        if (file.type.startsWith('image/')) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.getElementById('receiptImg');
                img.src = e.target.result;
                img.style.display = 'block';
                document.getElementById('receiptEmpty').style.display = 'none';
            };
            reader.readAsDataURL(file);
        }
    }

    /* 드래그 앤 드롭 */
    var dropArea = document.getElementById('receiptDropArea');
    dropArea.addEventListener('dragover', function(e) { e.preventDefault(); dropArea.classList.add('drag-over'); });
    dropArea.addEventListener('dragleave', function() { dropArea.classList.remove('drag-over'); });
    dropArea.addEventListener('drop', function(e) {
        e.preventDefault();
        dropArea.classList.remove('drag-over');
        var file = e.dataTransfer.files[0];
        if (file) {
            var input = document.getElementById('receiptUpload');
            var dt = new DataTransfer();
            dt.items.add(file);
            input.files = dt.files;
            previewReceipt(input);
        }
    });

    function applyReceipt() {
        var input = document.getElementById('receiptUpload');
        if (!input.files[0]) { alert('변경할 파일을 선택해주세요.'); return; }
        // TODO: FormData로 서버에 업로드
        alert('영수증이 적용되었습니다.');
        closeModal('receiptModal');
    }

    /* 모달 외부 클릭 시 닫기 */
    document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === overlay) closeModal(overlay.id);
        });
    });
</script>

</body>
</html>
