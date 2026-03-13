<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>거래처 등록 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Ingredients/stock.css"/>
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">거래처 등록 <span>새로운 거래처를 등록합니다</span></div>
    </div>

    <div class="form-card">
        <div class="form-card-title">거래처 정보 입력</div>
        <form action="/inventory/vendor/register" method="post" enctype="multipart/form-data">
            <div class="form-row">
                <div class="form-group">
                    <label>거래처명 *</label>
                    <input type="text" name="supplier_name" required placeholder="거래처명을 입력하세요">
                </div>
                <div class="form-group">
                    <label>거래처 유형</label>
                    <select name="supplier_type">
                        <option value="">선택하세요</option>
                        <option value="원두">원두</option>
                        <option value="유제품">유제품</option>
                        <option value="시럽/소스">시럽/소스</option>
                        <option value="소모품">소모품</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>대표자명</label>
                    <input type="text" name="ceo_name" placeholder="대표자 이름">
                </div>
                <div class="form-group">
                    <label>주소</label>
                    <input type="text" name="address" placeholder="거래처 주소">
                </div>
            </div>
            <div class="form-group">
                <label>계약서 첨부</label>
                <input type="file" name="contract_file" accept=".pdf,.doc,.docx,.jpg,.png">
                <small style="color:var(--text-muted); font-size:0.78rem; display:block; margin-top:4px;">
                    PDF, Word, 이미지 파일 업로드 가능
                </small>
            </div>
            <div class="form-group">
                <label>비고</label>
                <textarea name="note" rows="4" placeholder="거래처 관련 메모를 입력하세요"></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-cancel"
                        onclick="location.href='/inventory/vendor'">취소</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>

</div>
</body>
</html>
