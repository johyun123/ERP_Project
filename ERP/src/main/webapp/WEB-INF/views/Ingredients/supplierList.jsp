<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>거래처 관리 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Ingredients/stock.css"/>
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">거래처 관리 <span>등록된 거래처를 관리합니다</span></div>
        <button class="btn btn-primary" onclick="location.href='/inventory/vendor/register'">+ 거래처 등록</button>
    </div>

    <div class="table-card">
        <div class="table-card-header">
            <h3>거래처 목록</h3>
            <span style="font-size:0.82rem; color:var(--text-muted);">총 ${list.size()}개</span>
        </div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>거래처명</th>
                    <th>유형</th>
                    <th>대표자</th>
                    <th>주소</th>
                    <th>계약서</th>
                    <th>등록일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr class="empty-row"><td colspan="7">등록된 거래처가 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="s" items="${list}">
                    <tr>
                        <td><strong>${s.supplier_name}</strong></td>
                        <td>
                            <c:if test="${not empty s.supplier_type}">
                                <span class="badge badge-normal">${s.supplier_type}</span>
                            </c:if>
                        </td>
                        <td>${empty s.ceo_name ? '-' : s.ceo_name}</td>
                        <td style="max-width:180px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                            ${empty s.address ? '-' : s.address}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty s.contract_file}">
                                    <button class="btn btn-edit" onclick="viewContract('${s.contract_file}')">조회</button>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:var(--text-muted);">없음</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${s.created_at}</td>
                        <td>
                            <button class="btn btn-edit"
                                onclick="openEditModal(${s.id},'${s.supplier_name}','${s.supplier_type}','${s.ceo_name}','${s.address}','${s.note}')">
                                수정
                            </button>
                            <form action="/inventory/vendor/delete/${s.id}" method="post" style="display:inline"
                                  onsubmit="return confirm('${s.supplier_name}을(를) 삭제하시겠습니까?')">
                                <button type="submit" class="btn btn-delete">삭제</button>
                            </form>
                        </td>
                    </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

</div>

<%-- 수정 모달 --%>
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-title">✏️ 거래처 수정</div>
        <form action="/inventory/vendor/update" method="post">
            <input type="hidden" name="id" id="edit_id">
            <div class="form-row">
                <div class="form-group">
                    <label>거래처명 *</label>
                    <input type="text" name="supplier_name" id="edit_supplier_name" required>
                </div>
                <div class="form-group">
                    <label>거래처 유형</label>
                    <select name="supplier_type" id="edit_supplier_type">
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
                    <input type="text" name="ceo_name" id="edit_ceo_name">
                </div>
                <div class="form-group">
                    <label>주소</label>
                    <input type="text" name="address" id="edit_address">
                </div>
            </div>
            <div class="form-group">
                <label>비고</label>
                <textarea name="note" id="edit_note" rows="3"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>

<%-- 계약서 조회 모달 --%>
<div class="modal-overlay" id="contractModal">
    <div class="modal" style="width:620px; max-width:95vw;">
        <div class="modal-title">📄 계약서 조회</div>
        <div id="contractViewer" style="text-align:center; padding:20px; min-height:300px;"></div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeModal('contractModal')">닫기</button>
            <a id="contractDownload" href="#" class="btn btn-primary" download>다운로드</a>
        </div>
    </div>
</div>

<script>
function openModal(id)  { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
function openEditModal(id, name, type, ceo, address, note) {
    document.getElementById('edit_id').value            = id;
    document.getElementById('edit_supplier_name').value = name;
    document.getElementById('edit_supplier_type').value = type;
    document.getElementById('edit_ceo_name').value      = ceo;
    document.getElementById('edit_address').value       = address;
    document.getElementById('edit_note').value          = (note === 'null' ? '' : note);
    openModal('editModal');
}
function viewContract(filepath) {  
    const ext = filepath.split('.').pop().toLowerCase();
    const url = filepath;  
    const viewer = document.getElementById('contractViewer');
    
    if (['jpg','jpeg','png','gif'].includes(ext)) {
        viewer.innerHTML = '<img src="'+url+'" style="max-width:100%; border-radius:8px;">';
    } else if (ext === 'pdf') {
        viewer.innerHTML = '<iframe src="'+url+'" width="100%" height="400px" style="border:none;"></iframe>';
    } else {
        viewer.innerHTML = '<div style="padding:40px; color:var(--text-muted);">📎 다운로드해 주세요.</div>';
    }
    document.getElementById('contractDownload').href = url;
    openModal('contractModal');
}
document.querySelectorAll('.modal-overlay').forEach(o => {
    o.addEventListener('click', e => { if(e.target===o) o.classList.remove('active'); });
});
</script>

</body>
</html>
