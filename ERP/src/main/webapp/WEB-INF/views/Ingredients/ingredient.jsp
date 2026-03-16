<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>재고 현황 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Ingredients/stock.css"/>
</head>
<body>

<%-- 헤더 + 사이드바 (고정) --%>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<%-- 페이지 콘텐츠 --%>
<div class="content">

    <div class="page-header">
        <div class="page-title">재고 현황 <span>원재료 재고를 관리합니다</span></div>
        <button class="btn btn-primary" onclick="openModal('registerModal')">+ 원재료 등록</button>
    </div>

    <%-- 상단 요약 카드 --%>
    <c:set var="lowCount" value="0"/>
    <c:forEach var="item" items="${list}">
        <c:if test="${item.stock_qty <= item.min_stock}">
            <c:set var="lowCount" value="${lowCount + 1}"/>
        </c:if>
    </c:forEach>

    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-icon blue">📦</div>
            <div class="stat-info">
                <div class="label">전체 품목</div>
                <div class="value">${list.size()}개</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red">⚠️</div>
            <div class="stat-info">
                <div class="label">재고 부족</div>
                <div class="value red">${lowCount}개</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✅</div>
            <div class="stat-info">
                <div class="label">정상 재고</div>
                <div class="value green">${list.size() - lowCount}개</div>
            </div>
        </div>
    </div>

    <%-- 테이블 --%>
    <div class="table-card">
        <div class="table-card-header">
            <h3>원재료 목록</h3>
        </div>
        <table class="data-table">
            <thead>
                <tr>
                    <th>원재료명</th>
                    <th>단위</th>
                    <th>현재 재고</th>
                    <th>최소 기준량</th>
                    <th>상태</th>
                    <th>거래처</th>
                    <th>원가</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr class="empty-row"><td colspan="8">등록된 원재료가 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${list}">
                    <tr>
                        <td><strong>${item.name}</strong></td>
                        <td>${item.unit}</td>
                        <td>${item.stock_qty}</td>
                        <td>${item.min_stock}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.stock_qty <= item.min_stock}">
                                    <span class="badge badge-low">⚠ 부족</span>
                                </c:when>
                                <c:when test="${item.stock_qty <= item.min_stock * 1.5}">
                                    <span class="badge badge-warning">△ 주의</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-normal">✓ 정상</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${empty item.supplier ? '-' : item.supplier}</td>
                        <td><fmt:formatNumber value="${item.unit_cost}" pattern="#,###"/>원</td>
                        <td>
                            <button class="btn btn-edit"
                                onclick="openEditModal(${item.id},'${item.name}','${item.unit}',${item.stock_qty},${item.min_stock},${item.unit_cost},'${item.supplier}')">
                                수정
                            </button>
                            <form action="/inventory/delete/${item.id}" method="post" style="display:inline"
                                  onsubmit="return confirm('${item.name}을(를) 삭제하시겠습니까?')">
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

<%-- 등록 모달 --%>
<div class="modal-overlay" id="registerModal">
    <div class="modal">
        <div class="modal-title">➕ 원재료 등록</div>
        <form action="/inventory/register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>원재료명 *</label>
                    <input type="text" name="name" required placeholder="예: 원두">
                </div>
                <div class="form-group">
                    <label>단위 *</label>
                    <input type="text" name="unit" required placeholder="예: kg, box, ea">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>현재 재고량</label>
                    <input type="number" name="stock_qty" step="0.01" value="0">
                </div>
                <div class="form-group">
                    <label>최소 재고 기준량</label>
                    <input type="number" name="min_stock" step="0.01" value="0">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>원가 (개당)</label>
                    <input type="number" name="unit_cost" value="0">
                </div>
                <div class="form-group">
                    <label>거래처</label>
                    <input type="text" name="supplier" placeholder="공급업체명">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('registerModal')">취소</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>

<%-- 수정 모달 --%>
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-title">✏️ 원재료 수정</div>
        <form action="/inventory/update" method="post">
            <input type="hidden" name="id" id="edit_id">
            <div class="form-row">
                <div class="form-group">
                    <label>원재료명 *</label>
                    <input type="text" name="name" id="edit_name" required>
                </div>
                <div class="form-group">
                    <label>단위 *</label>
                    <input type="text" name="unit" id="edit_unit" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>현재 재고량</label>
                    <input type="number" name="stock_qty" id="edit_stock_qty" step="0.01">
                </div>
                <div class="form-group">
                    <label>최소 재고 기준량</label>
                    <input type="number" name="min_stock" id="edit_min_stock" step="0.01">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>원가 (개당)</label>
                    <input type="number" name="unit_cost" id="edit_unit_cost">
                </div>
                <div class="form-group">
                    <label>거래처</label>
                    <input type="text" name="supplier" id="edit_supplier">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id)  { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
function openEditModal(id, name, unit, stock_qty, min_stock, unit_cost, supplier) {
    document.getElementById('edit_id').value        = id;
    document.getElementById('edit_name').value      = name;
    document.getElementById('edit_unit').value      = unit;
    document.getElementById('edit_stock_qty').value = stock_qty;
    document.getElementById('edit_min_stock').value = min_stock;
    document.getElementById('edit_unit_cost').value = unit_cost;
    document.getElementById('edit_supplier').value  = supplier;
    openModal('editModal');
}
document.querySelectorAll('.modal-overlay').forEach(o => {
    o.addEventListener('click', e => { if(e.target===o) o.classList.remove('active'); });
});
</script>

</body>
</html>
