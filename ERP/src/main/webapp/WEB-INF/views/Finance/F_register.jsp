<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출 등록 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Finance/F_register.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content"> 	

    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">💰</span>
            <div>
                <h1 class="page-title">지출 등록</h1>
                <p class="page-sub">재무관리 &gt; 지출 등록</p>
            </div>
        </div>
    </div>

    <form id="expenseForm" action="/f_register" method="post">
		<input type="hidden" id="amountRaw" name="amount" />
		<div class="form-grid">
		
		    <!-- 지출 날짜 -->
		    <div class="form-group">
		        <label class="form-label required">지출 날짜</label>
		        <input type="date" class="form-input" id="expenseDate" name="expenseDate" />
		    </div>
		
		    <!-- 지출 유형 -->
		    <div class="form-group">
		        <label class="form-label required">지출 유형</label>
		        <select class="form-input form-select" id="expenseType" name="expenseType">
		            <option value="" disabled selected>유형 선택</option>
		            <option value="재료비">재료비</option>
		            <option value="인건비">인건비</option>
		            <option value="임대료">임대료</option>
		            <option value="공과금">공과금</option>
		            <option value="소모품">소모품</option>
		            <option value="마케팅">마케팅</option>
		            <option value="기타">기타</option>
		        </select>
		    </div>
		
		    <!-- 금액 (화면용 — name 제거, hidden으로 실제 전송) -->
		    <div class="form-group">
		        <label class="form-label required">금액</label>
		        <div class="input-wrap">
		            <input type="text" class="form-input input-with-unit" id="amount"
		                   placeholder="0" oninput="formatAmount(this)" />
		            <span class="input-unit">원</span>
		        </div>
		    </div>
		
		    <!-- 비고 -->
		    <div class="form-group form-group-full">
		        <label class="form-label">비고</label>
		        <textarea class="form-input form-textarea" id="memo" name="description"
		                  placeholder="추가 메모를 입력하세요"></textarea>
		    </div>
		
		    <!-- 영수증 파일 -->
		    <div class="form-group form-group-full">
		        <label class="form-label">영수증 파일</label>
		        <div class="file-drop-area" id="fileDropArea" onclick="document.getElementById('receiptFile').click()">
		            <input type="file" id="receiptFile" name="receiptFile"
		                   accept="image/*,.pdf" style="display:none;"
		                   onchange="handleFileSelect(this)" />
		            <div class="file-drop-icon">📎</div>
		            <div class="file-drop-text" id="fileDropText">
		                클릭하거나 파일을 드래그하여 업로드<br>
		                <span class="file-drop-hint">JPG, PNG, PDF 지원 · 최대 10MB</span>
		            </div>
		        </div>
		        <div class="file-preview" id="filePreview"></div>
		    </div>
		</div>
		
		<!-- 버튼 영역 -->
		<div class="form-actions">
		    <button class="btn btn-submit" type="button" onclick="submitForm()">등록</button>
		</div>
		
	</form>
</div>

<script>
    /* 금액 천 단위 콤마 */
    function formatAmount(input) {
        let val = input.value.replace(/[^0-9]/g, '');
        input.value = val ? Number(val).toLocaleString() : '';
    }

    /* 파일 선택 처리 */
    function handleFileSelect(input) {
        const file = input.files[0];
        if (!file) return;

        const preview = document.getElementById('filePreview');
        const text    = document.getElementById('fileDropText');
        const sizeKB  = (file.size / 1024).toFixed(1);

        text.innerHTML = '<strong>' + file.name + '</strong><br>'
                       + '<span class="file-drop-hint">' + sizeKB + ' KB</span>';
        document.getElementById('fileDropArea').classList.add('has-file');

        // 이미지면 미리보기
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = '<img src="' + e.target.result + '" alt="영수증 미리보기" class="receipt-preview-img" />';
            };
            reader.readAsDataURL(file);
        } else {
            preview.innerHTML = '<div class="pdf-badge">📄 PDF 파일 첨부됨</div>';
        }
    }

    /* 드래그 앤 드롭 */
    const dropArea = document.getElementById('fileDropArea');
    dropArea.addEventListener('dragover', e => { e.preventDefault(); dropArea.classList.add('drag-over'); });
    dropArea.addEventListener('dragleave', () => dropArea.classList.remove('drag-over'));
    dropArea.addEventListener('drop', e => {
        e.preventDefault();
        dropArea.classList.remove('drag-over');
        const file = e.dataTransfer.files[0];
        if (file) {
            const input = document.getElementById('receiptFile');
            const dt = new DataTransfer();
            dt.items.add(file);
            input.files = dt.files;
            handleFileSelect(input);
        }
    });

    /* 유효성 검사 & 제출 */
    function submitForm() {
	    const date   = document.getElementById('expenseDate').value;
	    const type   = document.getElementById('expenseType').value;
	    const amount = document.getElementById('amount').value.replace(/,/g, '');
	
	    if (!date)   { alert('지출 날짜를 선택해주세요.'); return; }
	    if (!type)   { alert('지출 유형을 선택해주세요.'); return; }
	    if (!amount) { alert('금액을 입력해주세요.'); return; }
	
	    document.getElementById('amountRaw').value = amount;
	    document.getElementById('expenseForm').submit();
	}
</script>

</body>
</html>
