<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 내역 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Common.css" />
    <link rel="stylesheet" href="/css/Order/OrderDetail.css" />
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>
<div class="content">
    <div class="page-header">
        <h2>주문 내역</h2>
        <button class="btn-add" onclick="openAddPopup()">+ 주문 추가</button>
    </div>

    <%-- 검색 + 날짜 필터 --%>
    <div style="display:flex;align-items:center;gap:10px;margin-bottom:16px;flex-wrap:wrap;">
        <input type="text" id="searchInput" placeholder="주문번호 / 결제수단 검색..."
               style="padding:8px 12px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:0.88rem;outline:none;width:220px;"
               oninput="applyFilter()" />
        <select id="filterStatus" onchange="applyFilter()"
                style="padding:8px 12px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:0.88rem;outline:none;">
            <option value="">전체 상태</option>
            <option value="대기">대기</option>
            <option value="완료">완료</option>
            <option value="취소">취소</option>
        </select>
        <input type="date" id="filterDateFrom" onchange="applyFilter()"
               style="padding:8px 12px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:0.88rem;outline:none;" />
        <span style="color:var(--text-muted);">~</span>
        <input type="date" id="filterDateTo" onchange="applyFilter()"
               style="padding:8px 12px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:0.88rem;outline:none;" />
        <button onclick="resetFilter()"
                style="padding:8px 14px;border:1.5px solid var(--border);border-radius:var(--radius-sm);background:transparent;font-size:0.85rem;cursor:pointer;">초기화</button>
        <span id="filterCount" style="font-size:0.82rem;color:var(--primary);font-weight:600;background:var(--primary-light);padding:3px 10px;border-radius:20px;display:none;"></span>
    </div>

    <table class="order-table">
        <thead>
            <tr>
                <th>주문번호</th><th>할인 전 총액</th><th>할인 금액</th>
                <th>실제 결제 금액</th><th>결제수단</th><th>상태</th>
                <th>요청사항</th><th>주문일시</th><th>관리</th>
            </tr>
        </thead>
        <tbody id="orderTableBody">
            <c:forEach var="order" items="${result.list}">
            <tr class="order-row"
                data-orderno="${order.orderNo}"
                data-payment="${order.paymentType}"
                data-status="${order.status}"
                data-date="${order.orderedAtFormatted}">
                <td>${order.orderNo}</td>
                <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>원</td>
                <td><fmt:formatNumber value="${order.discountAmount}" pattern="#,###"/>원</td>
                <td><fmt:formatNumber value="${order.finalAmount}" pattern="#,###"/>원</td>
                <td>${order.paymentType}</td>
                <td><span class="status-badge status-${order.status}">${order.status}</span></td>
                <td>${empty order.note ? '-' : order.note}</td>
                <td>${order.orderedAtFormatted}</td>
                <td class="action-cell">
                    <button class="btn-action btn-status" onclick="openStatusPopup(${order.id},'${order.status}')">상태변경</button>
                    <button class="btn-action btn-cancel-order" onclick="confirmDelete(${order.id})">삭제</button>
                </td>
            </tr>
            </c:forEach>
            <c:if test="${empty result.list}">
                <tr><td colspan="9" class="no-data">등록된 주문이 없습니다.</td></tr>
            </c:if>
        </tbody>
    </table>

    <%-- 페이지네이션 영역 (서버사이드 페이징 적용 시 result 모델 필요) --%>
    <div style="display:flex;justify-content:center;gap:4px;padding:16px 0;">
        <c:if test="${result.hasPrev()}">
            <button class="page-btn" onclick="goPage(${result.startPage-1})">‹</button>
        </c:if>
        <c:forEach begin="${result.startPage}" end="${result.endPage}" var="p">
            <button class="page-btn ${p==result.page?'active':''}" onclick="goPage(${p})">${p}</button>
        </c:forEach>
        <c:if test="${result.hasNext()}">
            <button class="page-btn" onclick="goPage(${result.endPage+1})">›</button>
        </c:if>
    </div>
</div>

<%-- 주문 추가 팝업 --%>
<div class="popup-overlay" id="popupOverlay">
    <div class="popup-box popup-wide">
        <div class="popup-header">
            <h3>주문 추가</h3>
            <button type="button" class="btn-close" onclick="closePopup()">✕</button>
        </div>
        <form id="orderForm" action="/orderAdd" method="post">
            <div class="popup-body">
                <div class="form-row"><label>주문번호</label>
                    <input type="text" name="orderNo" id="orderNo" readonly class="input-readonly"/>
                </div>
                <div class="form-row"><label>메뉴 선택</label>
                    <div class="menu-grid">
                        <c:forEach var="menu" items="${menuList}">
                            <div class="menu-card" onclick="addToCart(${menu.id},'${menu.name}',${menu.price})">
                                <div class="menu-name">${menu.name}</div>
                                <div class="menu-price">${menu.price}원</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div class="form-row"><label>장바구니 <span id="cartCount" class="cart-count">0개</span></label>
                    <div class="cart-box">
                        <div class="cart-row cart-header">
                            <div class="col-name">메뉴</div><div class="col-price">단가</div>
                            <div class="col-qty">수량</div><div class="col-sub">소계</div><div class="col-del"></div>
                        </div>
                        <div id="cartBody"><div class="cart-empty">메뉴를 선택하세요</div></div>
                    </div>
                    <div id="cartHiddenInputs"></div>
                </div>
                <div class="form-row"><label>할인 전 총액 (원)</label>
                    <input type="number" name="totalAmount" id="totalAmount" readonly class="input-readonly" value="0"/>
                </div>
                <div class="form-row"><label>할인 항목</label>
                    <div class="discount-options">
                        <button type="button" class="btn-discount" onclick="applyDiscount(this,5)">멤버십 할인 (5%)</button>
                        <button type="button" class="btn-discount" onclick="applyDiscount(this,10)">쿠폰 할인 (10%)</button>
                        <button type="button" class="btn-discount" onclick="applyDiscount(this,20)">VIP 할인 (20%)</button>
                    </div>
                </div>
                <div class="form-row"><label>할인 금액 (원)</label>
                    <input type="number" name="discountAmount" id="discountAmount" readonly class="input-readonly" value="0"/>
                </div>
                <div class="form-row"><label>실제 결제 금액 (원)</label>
                    <input type="number" name="finalAmount" id="finalAmount" readonly class="input-readonly" value="0"/>
                </div>
                <div class="form-row"><label>결제수단</label>
                    <select name="paymentType" id="paymentType">
                        <option value="카드">카드</option><option value="현금">현금</option>
                        <option value="카카오페이">카카오페이</option><option value="네이버페이">네이버페이</option><option value="토스페이">토스</option>
                    </select>
                </div>
                <div class="form-row"><label>요청사항</label>
                    <textarea name="note" id="note" placeholder="요청사항을 입력하세요"></textarea>
                </div>
            </div>
            <div class="popup-footer">
                <button type="button" class="btn-cancel" onclick="closePopup()">취소</button>
                <button type="button" class="btn-submit" onclick="submitOrder()">주문 등록</button>
            </div>
        </form>
    </div>
</div>

<%-- 상태 변경 팝업 --%>
<div class="popup-overlay" id="statusOverlay">
    <div class="popup-box" style="width:360px;">
        <div class="popup-header">
            <h3>상태 변경</h3>
            <button type="button" class="btn-close" onclick="closeStatusPopup()">✕</button>
        </div>
        <form id="statusForm" action="/orderStatus" method="post">
            <div class="popup-body">
                <input type="hidden" name="id" id="statusOrderId"/>
                <div class="form-row"><label>변경할 상태 선택</label>
                    <div class="status-options">
                        <button type="button" class="btn-status-opt" data-value="대기"   onclick="selectStatus(this)">대기</button>
                        <button type="button" class="btn-status-opt" data-value="완료"   onclick="selectStatus(this)">완료</button>
                        <button type="button" class="btn-status-opt" data-value="취소"   onclick="selectStatus(this)">취소</button>
                    </div>
                    <input type="hidden" name="status" id="selectedStatus"/>
                </div>
            </div>
            <div class="popup-footer">
                <button type="button" class="btn-cancel" onclick="closeStatusPopup()">닫기</button>
                <button type="button" class="btn-submit" onclick="submitStatus()">변경</button>
            </div>
        </form>
    </div>
</div>

<form id="deleteForm" action="/orderDelete" method="post">
    <input type="hidden" name="id" id="deleteOrderId"/>
</form>

<script>
/* ===== 필터/검색 (서버사이드) ===== */
var currentSize = ${not empty size ? size : 10};

function applyFilter() {
    var url = '/order?page=1&size=' + currentSize;
    var keyword  = document.getElementById('searchInput').value.trim();
    var status   = document.getElementById('filterStatus').value;
    var dateFrom = document.getElementById('filterDateFrom').value;
    var dateTo   = document.getElementById('filterDateTo').value;
    if (keyword)  url += '&keyword='  + encodeURIComponent(keyword);
    if (status)   url += '&status='   + encodeURIComponent(status);
    if (dateFrom) url += '&dateFrom=' + dateFrom;
    if (dateTo)   url += '&dateTo='   + dateTo;
    location.href = url;
}
function resetFilter() {
    location.href = '/order?page=1&size=' + currentSize;
}
function goPage(p) {
    var url = '/order?page=' + p + '&size=' + currentSize;
    var keyword  = '${not empty keyword ? keyword : ""}';
    var status   = '${not empty status  ? status  : ""}';
    var dateFrom = '${not empty dateFrom ? dateFrom : ""}';
    var dateTo   = '${not empty dateTo   ? dateTo   : ""}';
    if (keyword)  url += '&keyword='  + encodeURIComponent(keyword);
    if (status)   url += '&status='   + encodeURIComponent(status);
    if (dateFrom) url += '&dateFrom=' + dateFrom;
    if (dateTo)   url += '&dateTo='   + dateTo;
    location.href = url;
}

/* ===== 주문 추가 팝업 ===== */
var cart = [], selectedDiscountRate = 0;
function openAddPopup() {
    cart = []; selectedDiscountRate = 0;
    generateOrderNo(); renderCart();
    document.querySelectorAll('.btn-discount').forEach(function(b){b.classList.remove('active');});
    ['totalAmount','discountAmount','finalAmount'].forEach(function(id){document.getElementById(id).value='0';});
    document.getElementById('paymentType').value='카드';
    document.getElementById('note').value='';
    document.getElementById('popupOverlay').style.display='flex';
}
function closePopup() { document.getElementById('popupOverlay').style.display='none'; }
function generateOrderNo() {
    var now=new Date(), d=now.getFullYear()+String(now.getMonth()+1).padStart(2,'0')+String(now.getDate()).padStart(2,'0');
    document.getElementById('orderNo').value='ORD-'+d+'-'+String(Math.floor(1000+Math.random()*9000));
}
function addToCart(menuId,menuName,unitPrice) {
    menuId=Number(menuId);
    var exist=cart.find(function(c){return c.menuId===menuId;});
    if(exist){exist.qty++;}else{cart.push({menuId:menuId,menuName:menuName,unitPrice:unitPrice,qty:1});}
    renderCart();
}
function changeQty(menuId,delta) {
    menuId=Number(menuId);
    var item=cart.find(function(c){return c.menuId===menuId;});
    if(!item)return;
    item.qty+=delta;
    if(item.qty<=0)cart=cart.filter(function(c){return c.menuId!==menuId;});
    renderCart();
}
function removeCart(menuId) {
    menuId=Number(menuId);
    cart=cart.filter(function(c){return c.menuId!==menuId;});
    renderCart();
}
function renderCart() {
    var body=document.getElementById('cartBody'), hidden=document.getElementById('cartHiddenInputs');
    hidden.innerHTML='';
    if(cart.length===0){body.innerHTML='<div class="cart-empty">메뉴를 선택하세요</div>';document.getElementById('cartCount').textContent='0개';updateTotal();return;}
    body.innerHTML='';
    cart.forEach(function(item){
        var sub=item.unitPrice*item.qty, row=document.createElement('div');
        row.className='cart-row cart-item';
        row.innerHTML='<div class="col-name">'+item.menuName+'</div><div class="col-price">'+item.unitPrice.toLocaleString()+'원</div>'
            +'<div class="col-qty"><button type="button" onclick="changeQty('+item.menuId+',-1)">－</button><span>'+item.qty+'</span><button type="button" onclick="changeQty('+item.menuId+',1)">＋</button></div>'
            +'<div class="col-sub">'+sub.toLocaleString()+'원</div><div class="col-del"><button type="button" class="btn-remove" onclick="removeCart('+item.menuId+')">✕</button></div>';
        body.appendChild(row);
        hidden.innerHTML+='<input type="hidden" name="menuId" value="'+item.menuId+'"><input type="hidden" name="qty" value="'+item.qty+'"><input type="hidden" name="unitPrice" value="'+item.unitPrice+'">';
    });
    document.getElementById('cartCount').textContent=cart.length+'개';
    updateTotal();
}
function applyDiscount(btn,rate) {
    if(btn.classList.contains('active')){btn.classList.remove('active');selectedDiscountRate=0;}
    else{document.querySelectorAll('.btn-discount').forEach(function(b){b.classList.remove('active');});btn.classList.add('active');selectedDiscountRate=rate;}
    updateTotal();
}
function updateTotal() {
    var total=cart.reduce(function(s,c){return s+c.unitPrice*c.qty;},0), disc=Math.floor(total*selectedDiscountRate/100);
    document.getElementById('totalAmount').value=total;
    document.getElementById('discountAmount').value=disc;
    document.getElementById('finalAmount').value=total-disc;
}
function submitOrder() { if(cart.length===0){alert('메뉴를 1개 이상 선택해주세요.');return;} document.getElementById('orderForm').submit(); }

/* ===== 상태 변경 팝업 ===== */
function openStatusPopup(orderId,currentStatus) {
    document.getElementById('statusOrderId').value=orderId;
    document.getElementById('selectedStatus').value=currentStatus;
    document.querySelectorAll('.btn-status-opt').forEach(function(b){b.classList.toggle('active',b.getAttribute('data-value')===currentStatus);});
    document.getElementById('statusOverlay').style.display='flex';
}
function closeStatusPopup() { document.getElementById('statusOverlay').style.display='none'; }
function selectStatus(btn) {
    document.querySelectorAll('.btn-status-opt').forEach(function(b){b.classList.remove('active');});
    btn.classList.add('active');
    document.getElementById('selectedStatus').value=btn.getAttribute('data-value');
}
function submitStatus() {
    if(!document.getElementById('selectedStatus').value){alert('상태를 선택해주세요.');return;}
    document.getElementById('statusForm').submit();
}
function confirmDelete(orderId) {
    if(!confirm('주문을 취소하시겠습니까?'))return;
    document.getElementById('deleteOrderId').value=orderId;
    document.getElementById('deleteForm').submit();
}

/* ===== 팝업 외부클릭 버그 수정 ===== */
['popupOverlay','statusOverlay'].forEach(function(id) {
    var o = document.getElementById(id);
    o.addEventListener('mousedown', function(e){ o._cr = (e.target===o); });
    o.addEventListener('mouseup',   function(e){ if(e.target===o&&o._cr){ if(id==='popupOverlay') closePopup(); else closeStatusPopup(); } o._cr=false; });
});
</script>
</body>
</html>
