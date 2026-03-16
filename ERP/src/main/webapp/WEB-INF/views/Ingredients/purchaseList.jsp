<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 내역 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Ingredients/stock.css"/>
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">발주 내역 <span>발주 현황을 관리합니다</span></div>
        <button class="btn btn-primary" onclick="location.href='/inventory/order'">+ 발주 등록</button>
    </div>

    <%-- 상태별 요약 --%>
    <c:set var="orderedCnt"  value="0"/>
    <c:set var="receivedCnt" value="0"/>
    <c:set var="cancelCnt"   value="0"/>
    <c:forEach var="p" items="${list}">
        <c:if test="${p.status == 'ordered'}">  <c:set var="orderedCnt"  value="${orderedCnt+1}"/></c:if>
        <c:if test="${p.status == 'received'}"> <c:set var="receivedCnt" value="${receivedCnt+1}"/></c:if>
        <c:if test="${p.status == 'cancelled'}"><c:set var="cancelCnt"   value="${cancelCnt+1}"/></c:if>
    </c:forEach>

    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-icon blue">📋</div>
            <div class="stat-info">
                <div class="label">발주 완료</div>
                <div class="value">${orderedCnt}건</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✅</div>
            <div class="stat-info">
                <div class="label">입고 완료</div>
                <div class="value green">${receivedCnt}건</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red">❌</div>
            <div class="stat-info">
                <div class="label">취소</div>
                <div class="value red">${cancelCnt}건</div>
            </div>
        </div>
    </div>

    <div class="table-card">
        <div class="table-card-header"><h3>발주 목록</h3></div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>거래처명</th>
                    <th>총 금액</th>
                    <th>발주일</th>
                    <th>입고일</th>
                    <th>상태</th>
                    <th>비고</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr class="empty-row"><td colspan="8">발주 내역이 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${list}">
                    <tr class="clickable-row" onclick="openDetailModal(${p.id}, '${p.supplier}', '${p.ordered_at}')">
                        <td>${p.id}</td>
                        <td><strong>${p.supplier}</strong></td>
                        <td><fmt:formatNumber value="${p.total_cost}" pattern="#,###"/>원</td>
                        <td>${p.ordered_at}</td>
                        <td>${empty p.received_at ? '-' : p.received_at}</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.status == 'ordered'}">
                                    <span class="badge badge-warning">발주완료</span>
                                </c:when>
                                <c:when test="${p.status == 'received'}">
                                    <span class="badge badge-normal">입고완료</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-low">취소</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${empty p.note ? '-' : p.note}</td>
                        <td onclick="event.stopPropagation()">
                            <c:if test="${p.status != 'cancelled'}">
                                <button class="btn btn-edit"
                                    onclick="openEditModal(${p.id},'${p.supplier}','${p.status}','${p.received_at}','${p.note}')">
                                    수정
                                </button>
                                <form action="/inventory/order/cancel/${p.id}" method="post" style="display:inline"
                                      onsubmit="return confirm('발주를 취하하시겠습니까?')">
                                    <button type="submit" class="btn btn-delete">취하</button>
                                </form>
                            </c:if>
                            <c:if test="${p.status == 'cancelled'}">
                                <span style="color:var(--text-muted); font-size:0.82rem;">처리완료</span>
                            </c:if>
                        </td>
                    </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

</div>

<%-- 발주 상세 모달 --%>
<div class="modal-overlay" id="detailModal">
    <div class="modal" style="width:620px; max-width:95vw;">
        <div class="modal-title">
            📦 발주 상세
            <span id="detailInfo" style="font-size:0.82rem; font-weight:400;
                  color:var(--text-muted); margin-left:10px;"></span>
        </div>
        <div id="detailContent" style="min-height:160px;">
            <div style="text-align:center; padding:40px; color:var(--text-muted);">로딩 중...</div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeModal('detailModal')">닫기</button>
        </div>
    </div>
</div>

<%-- 수정 모달 --%>
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-title">✏️ 발주 수정</div>
        <form action="/inventory/order/update" method="post">
            <input type="hidden" name="id" id="edit_id">
            <div class="form-row">
                <div class="form-group">
                    <label>거래처명</label>
                    <input type="text" name="supplier" id="edit_supplier">
                </div>
                <div class="form-group">
                    <label>상태</label>
                    <select name="status" id="edit_status">
                        <option value="ordered">발주완료</option>
                        <option value="received">입고완료</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>입고일</label>
                    <input type="date" name="received_at" id="edit_received_at">
                </div>
                <div class="form-group">
                    <label>비고</label>
                    <input type="text" name="note" id="edit_note">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>

<style>
.clickable-row { cursor: pointer; }
.clickable-row:hover td { background: var(--primary-light) !important; }

.detail-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.88rem;
}
.detail-table th {
    background: #fafafa;
    padding: 10px 14px;
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    text-align: center;
    border-bottom: 1.5px solid var(--border-light);
}
.detail-table td {
    padding: 11px 14px;
    text-align: center;
    border-bottom: 1px solid var(--border-light);
}
.detail-table tr:last-child td { border-bottom: none; }
.detail-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 14px;
    margin-top: 8px;
    background: var(--primary-light);
    border-radius: var(--radius-sm);
    font-weight: 700;
    font-size: 0.95rem;
    color: var(--primary);
}
</style>

<script>
function openModal(id)  { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

function openDetailModal(purchaseId, supplier, orderedAt) {
    document.getElementById('detailInfo').innerText = supplier + ' · ' + orderedAt;
    document.getElementById('detailContent').innerHTML =
        '<div style="text-align:center; padding:40px; color:var(--text-muted);">로딩 중...</div>';
    openModal('detailModal');

    fetch('/inventory/order/items/' + purchaseId)
        .then(function(res) { return res.json(); })
        .then(function(items) {
            if (!items || items.length === 0) {
                document.getElementById('detailContent').innerHTML =
                    '<div style="text-align:center; padding:40px; color:var(--text-muted);">등록된 원재료가 없습니다.</div>';
                return;
            }
            var total = 0;
            var html = '<table class="detail-table">'
                + '<thead><tr>'
                + '<th>원재료명</th><th>단위</th><th>수량</th><th>단가</th><th>소계</th>'
                + '</tr></thead><tbody>';

            items.forEach(function(item) {
                total += item.subtotal;
                html += '<tr>'
                    + '<td><strong>' + item.ingredient_name + '</strong></td>'
                    + '<td>' + item.ingredient_unit + '</td>'
                    + '<td>' + item.qty + '</td>'
                    + '<td>' + Number(item.unit_cost).toLocaleString() + '원</td>'
                    + '<td><strong>' + Number(item.subtotal).toLocaleString() + '원</strong></td>'
                    + '</tr>';
            });

            html += '</tbody></table>';
            html += '<div class="detail-total">'
                + '<span>총 발주금액</span>'
                + '<span>' + total.toLocaleString() + '원</span>'
                + '</div>';

            document.getElementById('detailContent').innerHTML = html;
        })
        .catch(function() {
            document.getElementById('detailContent').innerHTML =
                '<div style="text-align:center; padding:40px; color:var(--accent-red);">데이터를 불러오지 못했습니다.</div>';
        });
}

function openEditModal(id, supplier, status, received_at, note) {
    document.getElementById('edit_id').value          = id;
    document.getElementById('edit_supplier').value    = supplier;
    document.getElementById('edit_status').value      = status;
    document.getElementById('edit_received_at').value = (received_at === 'null' ? '' : received_at);
    document.getElementById('edit_note').value        = (note === 'null' ? '' : note);
    openModal('editModal');
}

document.querySelectorAll('.modal-overlay').forEach(function(o) {
    o.addEventListener('click', function(e) {
        if (e.target === o) o.classList.remove('active');
    });
});
</script>

</body>
</html>
