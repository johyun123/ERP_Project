<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출 내역 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Common.css" />
    <link rel="stylesheet" href="/css/Finance/F_list.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>
<div class="content">

    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">💳</span>
            <div>
                <h1 class="page-title">지출 내역</h1>
                <p class="page-sub">재무관리 &gt; 지출 내역</p>
            </div>
        </div>
        <%-- [2순위] 지출등록 → 팝업으로 변경 --%>
        <button class="btn btn-primary" onclick="openModal('registerModal')">+ 지출 등록</button>
    </div>

    <div class="filter-bar">
        <select class="filter-input" id="filterType" onchange="applyFilter()">
            <option value="">전체 유형</option>
            <option value="재료비">재료비</option><option value="인건비">인건비</option>
            <option value="임대료">임대료</option><option value="공과금">공과금</option>
            <option value="소모품">소모품</option><option value="마케팅">마케팅</option><option value="기타">기타</option>
        </select>
        <input type="date" class="filter-input" id="filterDateFrom" onchange="applyFilter()" />
        <span class="filter-sep">~</span>
        <input type="date" class="filter-input" id="filterDateTo" onchange="applyFilter()" />
        <%-- 검색 추가 --%>
        <input type="text" class="filter-input" id="filterKeyword" placeholder="비고 검색..." oninput="applyFilter()" style="width:160px;" />
        <button class="btn btn-reset" onclick="resetFilter()">초기화</button>
        <span id="filterCount" style="font-size:0.82rem;color:var(--primary);font-weight:600;background:var(--primary-light);padding:3px 10px;border-radius:20px;display:none;"></span>
    </div>

    <div class="table-card">
        <table class="expense-table">
            <thead>
                <tr>
                    <th>No.</th><th>지출 날짜</th><th>지출 유형</th><th>금액</th>
                    <th>비고</th><th>등록자</th><th>등록일시</th><th>영수증</th><th>관리</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <c:choose>
                    <c:when test="${empty result.list}">
                        <tr><td colspan="9" class="empty-row">등록된 지출 내역이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="exp" items="${result.list}" varStatus="status">
                        <tr class="expense-row"
                            data-type="${exp.expenseType}"
                            data-date="${exp.expenseDate}"
                            data-desc="${empty exp.description ? '' : exp.description}">
                            <td class="td-no">${status.count}</td>
                            <td>${exp.expenseDate}</td>
                            <td><span class="type-badge type-${exp.expenseType}">${exp.expenseType}</span></td>
                            <td class="td-amount"><fmt:formatNumber value="${exp.amount}" pattern="#,###"/>원</td>
                            <td class="td-desc">${empty exp.description ? '-' : exp.description}</td>
                            <td>${empty exp.registeredByName ? '-' : exp.registeredByName}</td>
                            <td class="td-date">${exp.createdAt}</td>
                            <td>
                                <button class="btn-icon btn-receipt" onclick="openReceiptPopup(${exp.id})">🧾 조회</button>
                            </td>
                            <td class="td-actions">
                                <button class="btn-icon btn-edit"
                                    onclick="openEditModal(${exp.id},'${exp.expenseType}',${exp.amount},'${exp.expenseDate}','${empty exp.description ? '' : exp.description}')">✏️</button>
                                <button class="btn-icon btn-delete" onclick="deleteExpense(${exp.id})">🗑️</button>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- 서버사이드 페이징 (result 모델 적용 시 활성화) --%>
        <div class="pagination" style="display:flex;align-items:center;justify-content:space-between;padding:14px 20px;border-top:1.5px solid var(--border-light);">
            <div></div>
            <div style="display:flex;gap:4px;">
                <c:if test="${result.hasPrev()}"><button class="page-btn" onclick="goPage(${result.startPage-1})">‹</button></c:if>
                <c:forEach begin="${result.startPage}" end="${result.endPage}" var="p">
                    <button class="page-btn ${p==result.page?'active':''}" onclick="goPage(${p})">${p}</button>
                </c:forEach>
                <c:if test="${result.hasNext()}"><button class="page-btn" onclick="goPage(${result.endPage+1})">›</button></c:if>
            </div>
            <div style="font-size:0.8rem;color:var(--text-muted);">총 ${result.totalCount}건</div>
        </div>
    </div>
</div>

<%-- [2순위] 지출 등록 모달 (F_register.jsp 내용 팝업화) --%>
<div class="modal-overlay" id="registerModal">
    <div class="modal modal-receipt" style="max-width:680px;">
        <div class="modal-header">
            <span class="modal-title">💳 지출 등록</span>
            <button class="modal-close" onclick="closeModal('registerModal')">✕</button>
        </div>
        <div class="modal-body">
            <form id="registerForm" action="/f_register" method="post" enctype="multipart/form-data">
                <input type="hidden" id="regAmountRaw" name="amount" />

                <%-- 영수증 업로드 + OCR --%>
                <div class="form-group">
                    <label class="form-label">영수증 업로드 <span style="font-size:0.72rem;font-weight:700;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border-radius:20px;padding:2px 9px;">🤖 OCR 자동분석</span></label>
                    <div class="file-drop-area" id="regFileDropArea" onclick="document.getElementById('regReceiptFile').click()">
                        <input type="file" id="regReceiptFile" name="receiptFile" accept="image/*" style="display:none;" onchange="handleRegFileSelect(this)" />
                        <div class="file-drop-icon">📷</div>
                        <div class="file-drop-text" id="regFileDropText">
                            영수증 업로드 시 자동 분석합니다<br>
                            <span class="file-drop-hint">JPG, PNG · 최대 10MB · 클릭 또는 드래그</span>
                        </div>
                    </div>
                    <div id="regOcrStatus" style="display:none;" class="ocr-status"></div>
                    <div id="regFilePreview"></div>
                </div>

                <div class="form-group">
                    <label class="form-label required">지출 날짜</label>
                    <input type="date" class="form-input" id="regExpenseDate" name="expenseDate" />
                </div>
                <div class="form-group">
                    <label class="form-label required">지출 유형</label>
                    <select class="form-input form-select" id="regExpenseType" name="expenseType">
                        <option value="" disabled selected>유형 선택</option>
                        <option value="재료비">재료비</option><option value="인건비">인건비</option>
                        <option value="임대료">임대료</option><option value="공과금">공과금</option>
                        <option value="소모품">소모품</option><option value="마케팅">마케팅</option><option value="기타">기타</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label required">금액</label>
                    <div class="input-wrap">
                        <input type="text" class="form-input input-with-unit" id="regAmount" placeholder="0" oninput="formatAmount(this)" />
                        <span class="input-unit">원</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">비고</label>
                    <textarea class="form-input form-textarea" id="regMemo" name="description" placeholder="영수증 업로드 시 가맹점명 자동입력"></textarea>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('registerModal')">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitRegister()">등록</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 수정 모달 --%>
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
                        <option value="재료비">재료비</option><option value="인건비">인건비</option>
                        <option value="임대료">임대료</option><option value="공과금">공과금</option>
                        <option value="소모품">소모품</option><option value="마케팅">마케팅</option><option value="기타">기타</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label required">금액</label>
                    <div class="input-wrap">
                        <input type="text" class="form-input input-with-unit" id="editAmountDisplay" placeholder="0" oninput="formatAmount(this)" />
                        <input type="hidden" id="editAmount" name="amount" />
                        <span class="input-unit">원</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">비고</label>
                    <textarea class="form-input form-textarea" id="editDesc" name="description"></textarea>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitEdit()">저장</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 영수증 조회 모달 --%>
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
                    <input type="file" id="receiptUpload" accept="image/*,.pdf" style="display:none;" onchange="previewReceipt(this)" />
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
/* ===== 필터 (서버사이드) ===== */
var currentSize = ${not empty size ? size : 10};

function applyFilter() {
    var url = '/f_list?page=1&size=' + currentSize;
    var keyword  = document.getElementById('filterKeyword').value.trim();
    var category = document.getElementById('filterType').value;
    var dateFrom = document.getElementById('filterDateFrom').value;
    var dateTo   = document.getElementById('filterDateTo').value;
    if (keyword)  url += '&keyword='  + encodeURIComponent(keyword);
    if (category) url += '&category=' + encodeURIComponent(category);
    if (dateFrom) url += '&dateFrom=' + dateFrom;
    if (dateTo)   url += '&dateTo='   + dateTo;
    location.href = url;
}
function resetFilter() {
    location.href = '/f_list?page=1&size=' + currentSize;
}
function goPage(p) {
    var url = '/f_list?page=' + p + '&size=' + currentSize;
    var keyword  = '${not empty keyword ? keyword : ""}';
    var category = '${not empty category ? category : ""}';
    var dateFrom = '${not empty dateFrom ? dateFrom : ""}';
    var dateTo   = '${not empty dateTo ? dateTo : ""}';
    if (keyword)  url += '&keyword='  + encodeURIComponent(keyword);
    if (category) url += '&category=' + encodeURIComponent(category);
    if (dateFrom) url += '&dateFrom=' + dateFrom;
    if (dateTo)   url += '&dateTo='   + dateTo;
    location.href = url;
}

/* ===== 금액 콤마 ===== */
function formatAmount(input) {
    var val=input.value.replace(/[^0-9]/g,'');
    input.value=val?Number(val).toLocaleString():'';
}

/* ===== 모달 ===== */
function openModal(id)  { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

/* ===== 지출 등록 OCR ===== */
function handleRegFileSelect(input) {
    var file=input.files[0]; if(!file)return;
    var sizeKB=(file.size/1024).toFixed(1);
    document.getElementById('regFileDropText').innerHTML='<strong>'+file.name+'</strong><br><span class="file-drop-hint">'+sizeKB+' KB</span>';
    document.getElementById('regFileDropArea').classList.add('has-file');
    if(file.type.startsWith('image/')) {
        var reader=new FileReader();
        reader.onload=function(e){document.getElementById('regFilePreview').innerHTML='<img src="'+e.target.result+'" style="max-width:100%;max-height:180px;border-radius:var(--radius-sm);margin-top:8px;">';};
        reader.readAsDataURL(file);
    }
    analyzeOcr(file);
}
function analyzeOcr(file) {
    var el=document.getElementById('regOcrStatus');
    el.style.display='flex'; el.className='ocr-status ocr-loading';
    el.innerHTML='<span class="ocr-spinner"></span> 영수증 분석 중...';
    var fd=new FormData(); fd.append('image',file);
    fetch('/ocr/analyze',{method:'POST',body:fd})
        .then(function(r){return r.json();})
        .then(function(data){
            if(data.success){
                if(data.date&&data.date.length===10) document.getElementById('regExpenseDate').value=data.date;
                if(data.amount&&data.amount>0){document.getElementById('regAmount').value=data.amount.toLocaleString();document.getElementById('regAmountRaw').value=data.amount;}
                if(data.storeName) document.getElementById('regMemo').value=data.storeName;
                el.className='ocr-status ocr-success'; el.innerHTML='✓ 분석 완료 — 내용을 확인 후 수정하세요.';
            } else {
                el.className='ocr-status ocr-fail'; el.innerHTML='⚠ 자동분석 실패 — 수동으로 입력해주세요.';
            }
        })
        .catch(function(){el.className='ocr-status ocr-fail';el.innerHTML='⚠ 서버 오류 — 수동으로 입력해주세요.';});
}
function submitRegister() {
    var date=document.getElementById('regExpenseDate').value;
    var type=document.getElementById('regExpenseType').value;
    var amount=document.getElementById('regAmount').value.replace(/,/g,'');
    if(!date){alert('지출 날짜를 선택해주세요.');return;}
    if(!type){alert('지출 유형을 선택해주세요.');return;}
    if(!amount){alert('금액을 입력해주세요.');return;}
    document.getElementById('regAmountRaw').value=amount;
    document.getElementById('registerForm').submit();
}

/* ===== 수정 모달 ===== */
function openEditModal(id,type,amount,date,desc) {
    document.getElementById('editId').value            = id;
    document.getElementById('editDate').value          = date;
    document.getElementById('editType').value          = type;
    document.getElementById('editAmountDisplay').value = Number(amount).toLocaleString();
    document.getElementById('editAmount').value        = amount;
    document.getElementById('editDesc').value          = desc;
    openModal('editModal');
}
function submitEdit() {
    var raw=document.getElementById('editAmountDisplay').value.replace(/,/g,'');
    if(!raw){alert('금액을 입력해주세요.');return;}
    document.getElementById('editAmount').value=raw;
    document.getElementById('editForm').submit();
}

/* ===== 삭제 ===== */
function deleteExpense(id) {
    if(!confirm('해당 지출 내역을 삭제하시겠습니까?'))return;
    var f=document.createElement('form'); f.method='post'; f.action='/f_delete';
    var i=document.createElement('input'); i.type='hidden'; i.name='id'; i.value=id;
    f.appendChild(i); document.body.appendChild(f); f.submit();
}

/* ===== 영수증 조회 ===== */
var currentReceiptId=null;
function openReceiptPopup(id) {
    currentReceiptId=id;
    document.getElementById('receiptImg').style.display='none';
    document.getElementById('receiptEmpty').style.display='block';
    document.getElementById('receiptDropText').innerHTML='클릭하거나 파일을 드래그하여 업로드<br><span class="file-drop-hint">JPG, PNG, PDF 지원</span>';
    document.getElementById('receiptDropArea').classList.remove('has-file');
    openModal('receiptModal');
}
function previewReceipt(input) {
    var file=input.files[0]; if(!file)return;
    document.getElementById('receiptDropText').innerHTML='<strong>'+file.name+'</strong><br><span class="file-drop-hint">'+((file.size/1024).toFixed(1))+' KB</span>';
    document.getElementById('receiptDropArea').classList.add('has-file');
    if(file.type.startsWith('image/')){
        var reader=new FileReader();
        reader.onload=function(e){var img=document.getElementById('receiptImg');img.src=e.target.result;img.style.display='block';document.getElementById('receiptEmpty').style.display='none';};
        reader.readAsDataURL(file);
    }
}
var dropArea=document.getElementById('receiptDropArea');
dropArea.addEventListener('dragover',function(e){e.preventDefault();dropArea.classList.add('drag-over');});
dropArea.addEventListener('dragleave',function(){dropArea.classList.remove('drag-over');});
dropArea.addEventListener('drop',function(e){e.preventDefault();dropArea.classList.remove('drag-over');var file=e.dataTransfer.files[0];if(file){var inp=document.getElementById('receiptUpload');var dt=new DataTransfer();dt.items.add(file);inp.files=dt.files;previewReceipt(inp);}});
function applyReceipt(){var inp=document.getElementById('receiptUpload');if(!inp.files[0]){alert('변경할 파일을 선택해주세요.');return;}alert('영수증이 적용되었습니다.');closeModal('receiptModal');}

/* ===== 모달 외부클릭 버그 수정 ===== */
document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('mousedown',function(e){o._cr=(e.target===o);});
    o.addEventListener('mouseup',  function(e){if(e.target===o&&o._cr)o.classList.remove('active');o._cr=false;});
});
</script>
</body>
</html>
