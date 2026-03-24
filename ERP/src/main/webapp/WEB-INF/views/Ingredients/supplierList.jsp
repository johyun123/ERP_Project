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
        <button class="btn btn-primary" onclick="openModal('registerModal')">+ 거래처 등록</button>
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
                    <tr class="clickable-row" onclick="openDetailModal(${s.id}, '${s.supplier_name}', '${s.supplier_type}', '${s.ceo_name}', '${s.address}', '${s.note}')">
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
                        <td onclick="event.stopPropagation()">
                            <c:choose>
                                <c:when test="${not empty s.contract_file}">
                                    <button class="btn btn-edit"
                                            onclick="viewContract('${s.contract_file}')">조회</button>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:var(--text-muted);">없음</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${s.created_at}</td>
                        <td onclick="event.stopPropagation()">
                            <button class="btn btn-edit"
                                onclick="openEditModal(${s.id},'${s.supplier_name}','${s.supplier_type}','${s.ceo_name}','${s.address}','${s.note}','${s.contract_file}')">
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

<%-- ===== 거래처 상세 모달 ===== --%>
<div class="modal-overlay" id="detailModal">
    <div class="modal" style="width:680px; max-width:95vw;">
        <div class="modal-title">
            🏢 <span id="detailName"></span>
            <span id="detailType" style="font-size:0.78rem; font-weight:500; margin-left:8px;"></span>
        </div>

        <%-- 거래처 기본 정보 --%>
        <div class="detail-info-grid">
            <div class="detail-info-item">
                <span class="detail-label">대표자</span>
                <span id="detailCeo" class="detail-value"></span>
            </div>
            <div class="detail-info-item">
                <span class="detail-label">주소</span>
                <span id="detailAddress" class="detail-value"></span>
            </div>
            <div class="detail-info-item" id="detailNoteWrap">
                <span class="detail-label">비고</span>
                <span id="detailNote" class="detail-value"></span>
            </div>
        </div>

        <%-- 담당 원재료 목록 --%>
        <div style="margin-top:20px;">
            <div style="font-size:0.85rem; font-weight:700; color:var(--text-primary);
                        margin-bottom:10px; padding-bottom:8px; border-bottom:1.5px solid var(--border-light);">
                📦 담당 원재료
                <span id="ingredientCount" style="font-size:0.78rem; font-weight:400;
                      color:var(--text-muted); margin-left:6px;"></span>
            </div>
            <div id="ingredientList">
                <div style="text-align:center; padding:20px; color:var(--text-muted);">로딩 중...</div>
            </div>
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeModal('detailModal')">닫기</button>
        </div>
    </div>
</div>

<%-- ===== 거래처 등록 모달 ===== --%>
<div class="modal-overlay" id="registerModal">
    <div class="modal">
        <div class="modal-title">➕ 거래처 등록</div>
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
                <input type="file" name="contract_file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png">
                <small style="color:var(--text-muted); font-size:0.78rem; display:block; margin-top:4px;">
                    PDF, Word, 이미지 파일 업로드 가능
                </small>
            </div>
            <div class="form-group">
                <label>비고</label>
                <textarea name="note" rows="3" placeholder="거래처 관련 메모를 입력하세요"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('registerModal')">취소</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>

<%-- ===== 거래처 수정 모달 ===== --%>
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-title">✏️ 거래처 수정</div>
        <form action="/inventory/vendor/update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id"            id="edit_id">
            <input type="hidden" name="contract_file" id="edit_contract_file">
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
                <label>계약서</label>
                <div id="edit_contract_preview" style="margin-bottom:8px;"></div>
                <div id="edit_contract_delete_wrap" style="display:none; margin-bottom:8px;">
                    <label style="display:flex; align-items:center; gap:6px; cursor:pointer;
                                  font-size:0.82rem; color:var(--accent-red); font-weight:500;">
                        <input type="checkbox" name="delete_contract" id="edit_delete_contract"
                               value="true" onchange="toggleContractInput(this.checked)">
                        기존 계약서 삭제
                    </label>
                </div>
                <div id="edit_contract_upload_wrap">
                    <input type="file" name="new_contract_file" id="edit_contract_input"
                           accept=".pdf,.doc,.docx,.jpg,.jpeg,.png">
                    <small style="color:var(--text-muted); font-size:0.78rem; display:block; margin-top:4px;">
                        새 파일 선택 시 교체, 선택 안 하면 기존 유지
                    </small>
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

<%-- ===== 계약서 조회 모달 ===== --%>
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

<style>
.detail-info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    padding: 14px;
    background: var(--bg-content);
    border-radius: var(--radius-md);
    margin-bottom: 4px;
}
.detail-info-item {
    display: flex;
    flex-direction: column;
    gap: 3px;
}
.detail-label {
    font-size: 0.72rem;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
.detail-value {
    font-size: 0.88rem;
    color: var(--text-primary);
    font-weight: 500;
}

/* 담당 원재료 테이블 */
.ingredient-detail-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.85rem;
}
.ingredient-detail-table th {
    background: #fafafa;
    padding: 9px 14px;
    font-size: 0.72rem;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    text-align: center;
    border-bottom: 1.5px solid var(--border-light);
}
.ingredient-detail-table td {
    padding: 10px 14px;
    text-align: center;
    border-bottom: 1px solid var(--border-light);
    color: var(--text-primary);
}
.ingredient-detail-table tr:last-child td { border-bottom: none; }
.ingredient-detail-table td:first-child    { text-align: left; }
.ingredient-detail-table th:first-child    { text-align: left; }
</style>

<script>
function openModal(id)  { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

/* ===== 거래처 상세 모달 ===== */
function openDetailModal(id, name, type, ceo, address, note) {
    document.getElementById('detailName').innerText    = name;
    document.getElementById('detailType').innerHTML    = type
        ? '<span class="badge badge-normal">' + type + '</span>' : '';
    document.getElementById('detailCeo').innerText     = ceo     || '-';
    document.getElementById('detailAddress').innerText = address || '-';
    document.getElementById('detailNote').innerText    = (note && note !== 'null') ? note : '-';

    document.getElementById('ingredientList').innerHTML =
        '<div style="text-align:center; padding:20px; color:var(--text-muted);">로딩 중...</div>';
    document.getElementById('ingredientCount').innerText = '';

    openModal('detailModal');

    // 담당 원재료 목록 조회
    fetch('/inventory/vendor/' + id + '/ingredients')
        .then(function(res) { return res.json(); })
        .then(function(list) {
            var countEl = document.getElementById('ingredientCount');
            if (!list || list.length === 0) {
                document.getElementById('ingredientList').innerHTML =
                    '<div style="text-align:center; padding:20px; color:var(--text-muted); font-size:0.85rem;">담당 원재료가 없습니다.</div>';
                countEl.innerText = '(0개)';
                return;
            }
            countEl.innerText = '(' + list.length + '개)';

            var badgeMap = {
                '원두': '☕', '유제품': '🥛', '시럽/소스': '🍯',
                '파우더': '🌿', '차류': '🍵', '소모품': '🧴', '기타': '📦'
            };

            var html = '<table class="ingredient-detail-table">'
                + '<thead><tr>'
                + '<th>원재료명</th><th>카테고리</th><th>단위</th>'
                + '<th>현재 재고</th><th>상태</th><th>단가</th>'
                + '</tr></thead><tbody>';

            list.forEach(function(item) {
                var emoji  = badgeMap[item.category] || '📦';
                var status, statusClass;
                if (item.stock_qty <= item.min_stock) {
                    status = '⚠ 부족'; statusClass = 'badge-low';
                } else if (item.stock_qty <= item.min_stock * 1.5) {
                    status = '△ 주의'; statusClass = 'badge-warning';
                } else {
                    status = '✓ 정상'; statusClass = 'badge-normal';
                }
                html += '<tr>'
                    + '<td><strong>' + item.name + '</strong></td>'
                    + '<td><span class="badge badge-category">' + emoji + ' ' + item.category + '</span></td>'
                    + '<td>' + item.unit + '</td>'
                    + '<td>' + item.stock_qty + '</td>'
                    + '<td><span class="badge ' + statusClass + '">' + status + '</span></td>'
                    + '<td>' + Number(item.unit_cost).toLocaleString() + '원</td>'
                    + '</tr>';
            });
            html += '</tbody></table>';
            document.getElementById('ingredientList').innerHTML = html;
        })
        .catch(function() {
            document.getElementById('ingredientList').innerHTML =
                '<div style="text-align:center; padding:20px; color:var(--accent-red);">불러오기 실패</div>';
        });
}

/* ===== 수정 모달 ===== */
function openEditModal(id, name, type, ceo, address, note, contractFile) {
    document.getElementById('edit_id').value            = id;
    document.getElementById('edit_supplier_name').value = name;
    document.getElementById('edit_supplier_type').value = type;
    document.getElementById('edit_ceo_name').value      = ceo;
    document.getElementById('edit_address').value       = address;
    document.getElementById('edit_note').value          = (note === 'null' ? '' : note);
    document.getElementById('edit_contract_file').value = (contractFile === 'null' ? '' : contractFile);
    document.getElementById('edit_delete_contract').checked = false;
    document.getElementById('edit_contract_input').value    = '';
    document.getElementById('edit_contract_upload_wrap').style.display = '';

    var preview    = document.getElementById('edit_contract_preview');
    var deleteWrap = document.getElementById('edit_contract_delete_wrap');

    if (contractFile && contractFile !== 'null') {
        var ext = contractFile.split('.').pop().toLowerCase();
        if (['jpg','jpeg','png','gif'].includes(ext)) {
            preview.innerHTML = '<img src="' + contractFile + '" style="max-height:80px; border-radius:6px; border:1.5px solid var(--border);">'
                + '<p style="font-size:0.75rem; color:var(--text-muted); margin-top:4px;">현재 계약서</p>';
        } else {
            preview.innerHTML = '<span style="font-size:0.82rem; color:var(--primary);">📎 기존 파일 있음 (' + contractFile.split('/').pop() + ')</span>';
        }
        deleteWrap.style.display = '';
    } else {
        preview.innerHTML        = '<span style="font-size:0.82rem; color:var(--text-muted);">등록된 계약서 없음</span>';
        deleteWrap.style.display = 'none';
    }
    openModal('editModal');
}

function toggleContractInput(checked) {
    document.getElementById('edit_contract_upload_wrap').style.display = checked ? 'none' : '';
    document.getElementById('edit_contract_preview').style.opacity     = checked ? '0.4' : '1';
    if (checked) document.getElementById('edit_contract_input').value  = '';
}

/* ===== 계약서 조회 ===== */
function viewContract(filepath) {
    if (!filepath || filepath === 'null') return;
    var ext    = filepath.split('.').pop().toLowerCase();
    var viewer = document.getElementById('contractViewer');
    if (['jpg','jpeg','png','gif'].includes(ext)) {
        viewer.innerHTML = '<img src="' + filepath + '" style="max-width:100%; border-radius:8px;">';
    } else if (ext === 'pdf') {
        viewer.innerHTML = '<iframe src="' + filepath + '" width="100%" height="400px" style="border:none; border-radius:8px;"></iframe>';
    } else {
        viewer.innerHTML = '<div style="padding:40px; color:var(--text-muted);">📎 ' + filepath.split('/').pop() + '<br><br>다운로드해 주세요.</div>';
    }
    document.getElementById('contractDownload').href = filepath;
    openModal('contractModal');
}

document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) { if(e.target===o) o.classList.remove('active'); });
});
</script>

</body>
</html>
