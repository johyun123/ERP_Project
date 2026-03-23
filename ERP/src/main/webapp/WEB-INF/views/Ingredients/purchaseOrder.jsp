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

<%
java.util.Map<String,String> emojiMap = new java.util.LinkedHashMap<>();
emojiMap.put("원두",     "☕");
emojiMap.put("유제품",   "🥛");
emojiMap.put("시럽/소스","🍯");
emojiMap.put("파우더",   "🌿");
emojiMap.put("차류",     "🍵");
emojiMap.put("소모품",   "🧴");
emojiMap.put("기타",     "📦");
request.setAttribute("emojiMap", emojiMap);
%>

<div class="content">

    <div class="page-header">
        <div class="page-title">발주 등록 <span>재고를 선택하여 발주합니다</span></div>
    </div>

    <%-- 거래처 선택 안내 배너 --%>
    <div id="supplierBanner" class="supplier-banner">
        <span>💡 원재료를 선택하면 거래처가 자동으로 설정됩니다. 같은 거래처의 원재료만 한 번에 발주할 수 있습니다.</span>
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

                <%-- 카테고리 탭 --%>
                <div style="padding:12px 20px 0; display:flex; gap:6px; flex-wrap:wrap;
                            border-bottom:1.5px solid var(--border-light);">
                    <button class="tab-btn active" onclick="filterOrderCategory('all',this)">전체</button>
                    <button class="tab-btn" onclick="filterOrderCategory('원두',this)">☕ 원두</button>
                    <button class="tab-btn" onclick="filterOrderCategory('유제품',this)">🥛 유제품</button>
                    <button class="tab-btn" onclick="filterOrderCategory('시럽/소스',this)">🍯 시럽/소스</button>
                    <button class="tab-btn" onclick="filterOrderCategory('파우더',this)">🌿 파우더</button>
                    <button class="tab-btn" onclick="filterOrderCategory('차류',this)">🍵 차류</button>
                    <button class="tab-btn" onclick="filterOrderCategory('소모품',this)">🧴 소모품</button>
                    <button class="tab-btn" onclick="filterOrderCategory('기타',this)">📦 기타</button>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>원재료명</th>
                            <th>카테고리</th>
                            <th>단위</th>
                            <th>현재 재고</th>
                            <th>단가</th>
                            <th>거래처</th>
                            <th>선택</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:set var="currentCat" value=""/>
                    <c:choose>
                        <c:when test="${empty ingredientList}">
                            <tr class="empty-row"><td colspan="7">등록된 원재료가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${ingredientList}">
                                <%-- 카테고리 구분 행 --%>
                                <c:if test="${item.category != currentCat}">
                                    <c:set var="currentCat" value="${item.category}"/>
                                    <tr class="category-header-row" data-category="${item.category}">
                                        <td colspan="7" style="background:#f8f9ff; font-weight:700;
                                            color:var(--primary); font-size:0.82rem;
                                            padding:8px 16px; letter-spacing:0.3px;">
                                            ${emojiMap[item.category]} ${item.category}
                                        </td>
                                    </tr>
                                </c:if>
                                <tr class="ingredient-row"
                                    id="row-${item.id}"
                                    data-category="${item.category}"
                                    data-supplier="${item.supplier}">
                                    <td><strong>${item.name}</strong>
                                        <c:if test="${item.stock_qty <= item.min_stock}">
                                            <span class="badge badge-low" style="margin-left:6px;">부족</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge badge-category">
                                            ${emojiMap[item.category]} ${item.category}
                                        </span>
                                    </td>
                                    <td>${item.unit}</td>
                                    <td>${item.stock_qty}</td>
                                    <td><fmt:formatNumber value="${item.unit_cost}" pattern="#,###"/>원</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.supplier}">
                                                <span class="supplier-tag">${item.supplier}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:var(--text-muted);">미등록</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button"
                                            id="btn-${item.id}"
                                            class="btn btn-edit"
                                            onclick="addToCart(${item.id},'${item.name}','${item.unit}',${item.unit_cost},'${item.supplier}')">
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
                            <label>거래처명</label>
                            <%-- 자동 세팅, 읽기 전용 --%>
                            <input type="text" id="cart_supplier"
                                   placeholder="원재료 선택 시 자동 설정"
                                   readonly
                                   style="background:#f8f9ff; color:var(--primary);
                                          font-weight:600; cursor:default;">
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
                        <tr>
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
.supplier-banner {
    background: var(--primary-light);
    border: 1.5px solid rgba(91,110,245,0.2);
    border-radius: var(--radius-md);
    padding: 12px 18px;
    font-size: 0.85rem;
    color: var(--primary);
    font-weight: 500;
    margin-bottom: 16px;
}
.supplier-tag {
    display: inline-block;
    background: var(--accent-green-light);
    color: var(--accent-green);
    font-size: 0.78rem;
    font-weight: 600;
    padding: 3px 10px;
    border-radius: 20px;
    white-space: nowrap;
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
/* 비활성화된 원재료 행 */
.ingredient-row.disabled {
    opacity: 0.35;
    pointer-events: none;
}
.ingredient-row.disabled .btn {
    background: var(--border-light);
    color: var(--text-muted);
    cursor: not-allowed;
}
.tab-btn {
    padding: 6px 14px;
    border: 1.5px solid var(--border);
    border-radius: 20px;
    background: var(--bg-card);
    color: var(--text-secondary);
    font-size: 0.82rem;
    font-weight: 500;
    cursor: pointer;
    transition: var(--transition);
    font-family: 'Noto Sans KR', sans-serif;
    margin-bottom: 10px;
}
.tab-btn:hover  { border-color: var(--primary); color: var(--primary); }
.tab-btn.active {
    background: var(--primary-gradient);
    color: #fff;
    border-color: transparent;
    box-shadow: 0 2px 8px rgba(91,110,245,0.3);
}
@media (max-width: 1100px) {
    .order-layout { grid-template-columns: 1fr; }
}
</style>

<script>
let cart = [];
let currentSupplier = ''; // 현재 선택된 거래처

document.getElementById('cart_ordered_at').value = new Date().toISOString().split('T')[0];

/* 거래처 기준으로 행 활성/비활성 처리 */
function updateRowStates() {
    document.querySelectorAll('.ingredient-row').forEach(function(row) {
        if (!currentSupplier) {
            row.classList.remove('disabled');
            return;
        }
        const rowSupplier = row.dataset.supplier || '';
        if (rowSupplier === currentSupplier) {
            row.classList.remove('disabled');
        } else {
            row.classList.add('disabled');
        }
    });
    // 카테고리 헤더도 체크 - 해당 카테고리 전체 비활성이면 헤더도 어둡게
    document.querySelectorAll('.category-header-row').forEach(function(header) {
        const cat = header.dataset.category;
        const hasActive = Array.from(
            document.querySelectorAll('.ingredient-row[data-category="' + cat + '"]')
        ).some(function(r) { return !r.classList.contains('disabled'); });
        header.style.opacity = hasActive ? '1' : '0.35';
    });
}

function filterIngredients() {
    const kw = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('.ingredient-row').forEach(function(row) {
        const name = row.querySelector('td strong').innerText.toLowerCase();
        row.style.display = name.includes(kw) ? '' : 'none';
    });
    document.querySelectorAll('.category-header-row').forEach(function(header) {
        const cat = header.dataset.category;
        const hasVisible = Array.from(
            document.querySelectorAll('.ingredient-row[data-category="' + cat + '"]')
        ).some(function(r) { return r.style.display !== 'none'; });
        header.style.display = hasVisible ? '' : 'none';
    });
}

function filterOrderCategory(category, btn) {
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');
    document.querySelectorAll('.ingredient-row').forEach(function(row) {
        row.style.display = (category === 'all' || row.dataset.category === category) ? '' : 'none';
    });
    document.querySelectorAll('.category-header-row').forEach(function(row) {
        row.style.display = (category === 'all' || row.dataset.category === category) ? '' : 'none';
    });
}

function addToCart(id, name, unit, unit_cost, supplier) {
    // 이미 카트에 있으면 수량만 증가
    const existing = cart.find(function(c) { return c.id === id; });
    if (existing) {
        existing.qty++;
        renderCart();
        return;
    }
    // 첫 번째 추가 시 거래처 자동 세팅
    if (!currentSupplier) {
        currentSupplier = supplier || '';
        document.getElementById('cart_supplier').value = currentSupplier;
        updateRowStates();
    }
    cart.push({ id: id, name: name, unit: unit, unit_cost: unit_cost, qty: 1 });
    renderCart();
}

function changeQty(id, qty) {
    const item = cart.find(function(c) { return c.id === id; });
    if (item) { item.qty = Math.max(1, parseInt(qty) || 1); renderCart(); }
}

function removeFromCart(id) {
    cart = cart.filter(function(c) { return c.id !== id; });
    // 카트가 비면 거래처 초기화
    if (cart.length === 0) {
        currentSupplier = '';
        document.getElementById('cart_supplier').value = '';
        updateRowStates();
    }
    renderCart();
}

function clearCart() {
    cart = [];
    currentSupplier = '';
    document.getElementById('cart_supplier').value = '';
    updateRowStates();
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
    if (cart.length === 0)  { alert('발주할 원재료를 추가해 주세요.'); return; }
    const supplier   = document.getElementById('cart_supplier').value.trim();
    const ordered_at = document.getElementById('cart_ordered_at').value;
    if (!ordered_at) { alert('발주일을 선택해 주세요.'); return; }
    const total = cart.reduce(function(s, c) { return s + c.qty * c.unit_cost; }, 0);
    document.getElementById('form_supplier').value   = supplier;
    document.getElementById('form_ordered_at').value = ordered_at;
    document.getElementById('form_note').value       = document.getElementById('cart_note').value;
    document.getElementById('form_total_cost').value = total;
    document.getElementById('form_items').value      = JSON.stringify(cart);
    if (confirm('총 ' + total.toLocaleString() + '원 발주하시겠습니까?')) {
        document.getElementById('orderForm').submit();
    }
}
</script>

</body>
</html>