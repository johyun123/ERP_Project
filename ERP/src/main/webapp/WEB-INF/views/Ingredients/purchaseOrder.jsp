<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>발주 등록 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Ingredients/stock.css"/>
</head>
<body>

<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">발주 등록 <span>재고를 선택하여 발주합니다</span></div>
    </div>

    <div class="order-layout">

        <%-- 왼쪽: 원재료 목록 --%>
        <div class="order-left">
            <div class="table-card">
                <div class="table-card-header">
                    <h3>📦 원재료 선택</h3>
                    <input type="text" id="searchInput" placeholder="검색..."
                           oninput="filterIngredients()"
                           style="padding:6px 12px; border:1.5px solid var(--border);
                                  border-radius:var(--radius-sm); font-size:0.85rem;
                                  width:160px; outline:none;">
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>원재료명</th>
                            <th>단위</th>
                            <th>현재 재고</th>
                            <th>단가</th>
                            <th>선택</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty ingredientList}">
                            <tr class="empty-row"><td colspan="5">등록된 원재료가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${ingredientList}">
                            <tr class="ingredient-row">
                                <td>
                                    <strong>${item.name}</strong>
                                    <c:if test="${item.stock_qty <= item.min_stock}">
                                        <span class="badge badge-low" style="margin-left:6px;">부족</span>
                                    </c:if>
                                </td>
                                <td>${item.unit}</td>
                                <td>${item.stock_qty}</td>
                                <td><fmt:formatNumber value="${item.unit_cost}" pattern="#,###"/>원</td>
                                <td>
                                    <button type="button" class="btn btn-edit"
                                        onclick="addToCart(${item.id},'${item.name}','${item.unit}',${item.unit_cost})">
                                        + 추가
                                    </button>
                                </td>
                            </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- 오른쪽: 발주 카트 --%>
        <div class="order-right">
            <div class="table-card">
                <div class="table-card-header"><h3>🛒 발주 목록</h3></div>
                <div style="padding:16px 20px;">
                    <div class="form-row">
                        <div class="form-group">
                            <label>거래처명 *</label>
                            <input type="text" id="cart_supplier" placeholder="거래처명 입력">
                        </div>
                        <div class="form-group">
                            <label>발주일 *</label>
                            <input type="date" id="cart_ordered_at">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>비고</label>
                        <input type="text" id="cart_note" placeholder="메모 입력">
                    </div>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>원재료명</th>
                            <th>수량</th>
                            <th>단가</th>
                            <th>소계</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody id="cartBody">
                        <tr id="cartEmpty">
                            <td colspan="5" style="padding:30px; color:var(--text-muted); text-align:center;">
                                원재료를 추가해 주세요
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="cart-total">
                    <span>총 발주금액</span>
                    <strong id="totalAmount">0원</strong>
                </div>
                <div style="padding:16px 20px; display:flex; justify-content:flex-end; gap:10px;">
                    <button type="button" class="btn btn-cancel" onclick="clearCart()">초기화</button>
                    <button type="button" class="btn btn-primary" onclick="submitOrder()">발주 등록</button>
                </div>
            </div>
        </div>

    </div>
</div>

<%-- hidden form --%>
<form id="orderForm" action="/inventory/order" method="post">
    <input type="hidden" name="supplier"   id="form_supplier">
    <input type="hidden" name="ordered_at" id="form_ordered_at">
    <input type="hidden" name="note"       id="form_note">
    <input type="hidden" name="total_cost" id="form_total_cost">
    <input type="hidden" name="itemsJson"  id="form_items">
</form>

<style>
.order-layout {
    display: grid;
    grid-template-columns: 1fr 420px;
    gap: 20px;
    align-items: start;
}
.cart-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 20px;
    border-top: 1.5px solid var(--border-light);
    font-size: 0.95rem;
    font-weight: 600;
}
.cart-total strong {
    font-family: 'Outfit', sans-serif;
    font-size: 1.2rem;
    color: var(--primary);
}
@media (max-width: 1100px) {
    .order-layout { grid-template-columns: 1fr; }
}
</style>

<script>
let cart = [];
document.getElementById('cart_ordered_at').value = new Date().toISOString().split('T')[0];

function filterIngredients() {
    const kw = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('.ingredient-row').forEach(row => {
        row.style.display = row.querySelector('td strong').innerText.toLowerCase().includes(kw) ? '' : 'none';
    });
}
function addToCart(id, name, unit, unit_cost) {
    const existing = cart.find(c => c.id === id);
    if (existing) { existing.qty++; }
    else { cart.push({ id, name, unit, unit_cost, qty: 1 }); }
    renderCart();
}
function changeQty(id, qty) {
    const item = cart.find(c => c.id === id);
    if (item) { item.qty = Math.max(1, parseInt(qty) || 1); renderCart(); }
}
function removeFromCart(id) {
    cart = cart.filter(c => c.id !== id);
    renderCart();
}
function clearCart() {
    cart = [];
    renderCart();
}
function renderCart() {
    const tbody = document.getElementById('cartBody');
    if (cart.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" style="padding:30px; color:var(--text-muted); text-align:center;">원재료를 추가해 주세요</td></tr>';
        document.getElementById('totalAmount').innerText = '0원';
        return;
    }
    let total = 0, html = '';
    cart.forEach(function(item) {
        const sub = item.qty * item.unit_cost;
        total += sub;
        html += '<tr>'
            + '<td><strong>' + item.name + '</strong><br><small style="color:var(--text-muted)">' + item.unit + '</small></td>'
            + '<td><input type="number" min="1" value="' + item.qty + '" onchange="changeQty(' + item.id + ',this.value)"'
            + ' style="width:64px; padding:5px 8px; border:1.5px solid var(--border); border-radius:var(--radius-sm); text-align:center; font-size:0.88rem;"></td>'
            + '<td>' + item.unit_cost.toLocaleString() + '원</td>'
            + '<td><strong>' + sub.toLocaleString() + '원</strong></td>'
            + '<td><button type="button" class="btn btn-delete" onclick="removeFromCart(' + item.id + ')">✕</button></td>'
            + '</tr>';
    });
    tbody.innerHTML = html;
    document.getElementById('totalAmount').innerText = total.toLocaleString() + '원';
}
function submitOrder() {
    if (cart.length === 0) { alert('발주할 원재료를 추가해 주세요.'); return; }
    const supplier   = document.getElementById('cart_supplier').value.trim();
    const ordered_at = document.getElementById('cart_ordered_at').value;
    if (!supplier)   { alert('거래처명을 입력해 주세요.'); return; }
    if (!ordered_at) { alert('발주일을 선택해 주세요.'); return; }
    const total = cart.reduce((s, c) => s + c.qty * c.unit_cost, 0);
    document.getElementById('form_supplier').value   = supplier;
    document.getElementById('form_ordered_at').value = ordered_at;
    document.getElementById('form_note').value       = document.getElementById('cart_note').value;
    document.getElementById('form_total_cost').value = total;
    document.getElementById('form_items').value      = JSON.stringify(cart);
    if (confirm(`총 ${total.toLocaleString()}원 발주하시겠습니까?`)) {
        document.getElementById('orderForm').submit();
    }
}
</script>

</body>
</html>
