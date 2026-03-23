<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지출 등록 | ERP CAFE SYSTEM</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Common.css" />
    <link rel="stylesheet" href="/css/Finance/F_register.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title-wrap">
            <span class="page-icon">&#128176;</span>
            <div>
                <h1 class="page-title">지출 등록</h1>
                <p class="page-sub">재무관리 &gt; 지출 등록</p>
            </div>
        </div>
    </div>

    <div class="form-card">
        <p class="form-section-title">지출 정보 입력</p>

        <form id="expenseForm" action="/f_register" method="post" enctype="multipart/form-data">
            <input type="hidden" id="amountRaw" name="amount" />

            <div class="form-grid">

                <!-- 영수증 파일 업로드 (가장 위 — OCR 결과가 아래 폼에 반영) -->
                <div class="form-group form-group-full">
                    <label class="form-label">영수증 업로드 <span class="ocr-badge">&#129302; OCR 자동분석</span></label>
                    <div class="file-drop-area" id="fileDropArea"
                         onclick="document.getElementById('receiptFile').click()">
                        <input type="file" id="receiptFile" name="receiptFile"
                               accept="image/*" style="display:none;"
                               onchange="handleFileSelect(this)" />
                        <div class="file-drop-icon">&#128248;</div>
                        <div class="file-drop-text" id="fileDropText">
                            영수증을 업로드하면 내용을 자동으로 분석합니다<br>
                            <span class="file-drop-hint">JPG, PNG 지원 · 최대 10MB · 클릭 또는 드래그</span>
                        </div>
                    </div>
                    <!-- OCR 상태 표시 -->
                    <div id="ocrStatus" class="ocr-status" style="display:none;"></div>
                    <!-- 이미지 미리보기 -->
                    <div class="file-preview" id="filePreview"></div>
                </div>

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

                <!-- 금액 -->
                <div class="form-group">
                    <label class="form-label required">금액</label>
                    <div class="input-wrap">
                        <input type="text" class="form-input input-with-unit" id="amount"
                               placeholder="0" oninput="formatAmount(this)" />
                        <span class="input-unit">원</span>
                    </div>
                </div>

                <!-- 비고 (가맹점명 자동입력) -->
                <div class="form-group form-group-full">
                    <label class="form-label">비고</label>
                    <textarea class="form-input form-textarea" id="memo" name="description"
                              placeholder="영수증 업로드 시 가맹점명이 자동입력됩니다"></textarea>
                </div>

            </div>

            <!-- 버튼 -->
            <div class="form-actions">
                <button class="btn btn-submit" type="button" onclick="submitForm()">등록</button>
            </div>

        </form>
    </div>
</div>

<script>
    /* ===== 금액 콤마 ===== */
    function formatAmount(input) {
        var val = input.value.replace(/[^0-9]/g, '');
        input.value = val ? Number(val).toLocaleString() : '';
    }

    /* ===== 파일 선택 → 미리보기 + OCR 자동호출 ===== */
    function handleFileSelect(input) {
        var file = input.files[0];
        if (!file) return;

        // 미리보기
        var preview = document.getElementById('filePreview');
        var text    = document.getElementById('fileDropText');
        var sizeKB  = (file.size / 1024).toFixed(1);
        text.innerHTML = '<strong>' + file.name + '</strong><br>'
                       + '<span class="file-drop-hint">' + sizeKB + ' KB</span>';
        document.getElementById('fileDropArea').classList.add('has-file');

        if (file.type.startsWith('image/')) {
            var reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = '<img src="' + e.target.result
                    + '" alt="영수증 미리보기" class="receipt-preview-img" />';
            };
            reader.readAsDataURL(file);
        }

        // OCR 자동 분석
        analyzeOcr(file);
    }

    /* ===== OCR 분석 요청 ===== */
    function analyzeOcr(file) {
        var statusEl = document.getElementById('ocrStatus');
        statusEl.style.display = 'flex';
        statusEl.className     = 'ocr-status ocr-loading';
        statusEl.innerHTML     = '<span class="ocr-spinner"></span> 영수증 분석 중...';

        var formData = new FormData();
        formData.append('image', file);

        fetch('/ocr/analyze', { method: 'POST', body: formData })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    applyOcrResult(data);
                    statusEl.className = 'ocr-status ocr-success';
                    statusEl.innerHTML = '&#10003; 분석 완료 — 내용을 확인 후 필요시 수정하세요.';
                } else {
                    statusEl.className = 'ocr-status ocr-fail';
                    statusEl.innerHTML = '&#9888; 자동분석 실패: ' + (data.message || '수동으로 입력해주세요.');
                }
            })
            .catch(function(err) {
                statusEl.className = 'ocr-status ocr-fail';
                statusEl.innerHTML = '&#9888; 서버 오류 — 수동으로 입력해주세요.';
            });
    }

    /* ===== OCR 결과를 폼에 자동 채움 ===== */
    function applyOcrResult(data) {
        // 날짜
        if (data.date && data.date.length === 10) {
            document.getElementById('expenseDate').value = data.date;
        }
        // 금액
        if (data.amount && data.amount > 0) {
            document.getElementById('amount').value    = data.amount.toLocaleString();
            document.getElementById('amountRaw').value = data.amount;
        }
        // 가맹점명 → 비고
        if (data.storeName) {
            document.getElementById('memo').value = data.storeName;
        }
    }

    /* ===== 드래그 앤 드롭 ===== */
    var dropArea = document.getElementById('fileDropArea');
    dropArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        dropArea.classList.add('drag-over');
    });
    dropArea.addEventListener('dragleave', function() {
        dropArea.classList.remove('drag-over');
    });
    dropArea.addEventListener('drop', function(e) {
        e.preventDefault();
        dropArea.classList.remove('drag-over');
        var file = e.dataTransfer.files[0];
        if (file) {
            var input = document.getElementById('receiptFile');
            var dt = new DataTransfer();
            dt.items.add(file);
            input.files = dt.files;
            handleFileSelect(input);
        }
    });

    /* ===== 유효성 검사 & 제출 ===== */
    function submitForm() {
        var date   = document.getElementById('expenseDate').value;
        var type   = document.getElementById('expenseType').value;
        var amount = document.getElementById('amount').value.replace(/,/g, '');

        if (!date)   { alert('지출 날짜를 선택해주세요.'); return; }
        if (!type)   { alert('지출 유형을 선택해주세요.'); return; }
        if (!amount) { alert('금액을 입력해주세요.'); return; }

        document.getElementById('amountRaw').value = amount;
        document.getElementById('expenseForm').submit();
    }
</script>

</body>
</html>
