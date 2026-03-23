<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>레시피 관리</title>
    <link rel="stylesheet" href="/css/header.css" />
    <link rel="stylesheet" href="/css/Product/recipe.css" />
</head>

<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">
	
    <div class="page-header">
        <div class="page-title">레시피 관리 <span>메뉴별 원재료 사용량을 관리합니다</span></div>
    </div>

    <!-- 메뉴별 레시피 카드 목록 -->
    <div class="recipe-list">
        <c:forEach var="menu" items="${menuList}">

        <div class="recipe-card">
            <div class="recipe-card-header">
                <div class="recipe-menu-name">${menu.name}</div>
                <div class="recipe-card-btns">
                    <button class="btn update"
                        onclick="openUpdateModal('${menu.id}', '${menu.name}')">수정</button>
                    <button class="btn delete"
                        onclick="openDeleteModal('${menu.id}', '${menu.name}')">삭제</button>
                </div>
            </div>

            <div class="recipe-table-wrap">
                <table class="recipe-table">
                    <thead>
                        <tr>
                            <th>원재료</th>
                            <th>개당 소모량</th>
                            <th>재고수</th>
                            <th>재고 부족 여부</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="recipe" items="${recipeList}">
                            <c:if test="${recipe.menuId == menu.id}">
                            <tr>
                                <td>${recipe.ingredientName}</td>
                                <td>${recipe.quantity} ${recipe.recipe}</td>
                                <td>${recipe.currentStock}</td>
                                <td>
                                    <span class="badge ${recipe.stockStatus == '정상' ? 'badge-on' : 'badge-off'}">
                                        ${recipe.stockStatus}
                                    </span>
                                </td>
                            </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        </c:forEach>
    </div>

    <div class="bottom-box">
        <button class="register-btn" onclick="openInsertModal()">+ 레시피 등록</button>
    </div>

</div>

<!-- ===================== 레시피 등록 모달 ===================== -->
<div class="modal-overlay" id="insertModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-title">레시피 등록</div>
            <button class="modal-close" onclick="closeInsertModal()">✕</button>
        </div>
        <form action="/recipeInsert" method="post">
            <div class="modal-body">
                <div class="input-row">
                    <label>제품명</label>
                    <select name="menuId" required>
                        <option value="">제품 선택</option>
                        <c:forEach var="menu" items="${menuList}">
                            <option value="${menu.id}">${menu.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="input-row">
                    <label>원재료</label>
                    <select name="ingredientId" required>
                        <option value="">원재료 선택</option>
                        <c:forEach var="ing" items="${ingredientList}">
                            <option value="${ing.id}">${ing.ingredientName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="input-row">
                    <label>개당 소모량</label>
                    <input type="number" name="quantity" placeholder="예: 180" step="0.001" min="0" required>
                </div>
                <div class="input-row">
                    <label>단위 / 메모</label>
                    <input type="text" name="recipe" placeholder="예: ml, 투샷">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="cancel-btn" onclick="closeInsertModal()">취소</button>
                <button type="submit" class="submit-btn">등록</button>
            </div>
        </form>
    </div>
</div>

<!-- ===================== 레시피 수정 모달 ===================== -->
<div class="modal-overlay" id="updateModal">
    <div class="modal-box">
        <div class="modal-header">
            <div class="modal-title">레시피 수정 - <span id="updateMenuName"></span></div>
            <button class="modal-close" onclick="closeUpdateModal()">✕</button>
        </div>
        <form action="/recipeUpdate" method="post">
            <input type="hidden" name="id" id="updateId">
            <input type="hidden" name="menuId" id="updateMenuId">
            <div class="modal-body">
                <div class="input-row">
                    <label>원재료</label>
                    <select name="ingredientId" id="updateIngredientId" required>
                        <c:forEach var="ing" items="${ingredientList}">
                            <option value="${ing.id}">${ing.ingredientName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="input-row">
                    <label>개당 소모량</label>
                    <input type="number" name="quantity" id="updateQuantity" step="0.001" min="0" required>
                </div>
                <div class="input-row">
                    <label>단위 / 메모</label>
                    <input type="text" name="recipe" id="updateRecipe">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="cancel-btn" onclick="closeUpdateModal()">취소</button>
                <button type="submit" class="submit-btn">수정</button>
            </div>
        </form>
    </div>
</div>

<!-- ===================== 삭제 확인 모달 ===================== -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box modal-sm">
        <div class="modal-header">
            <div class="modal-title">삭제 확인</div>
            <button class="modal-close" onclick="closeDeleteModal()">✕</button>
        </div>
        <div class="modal-body">
            <p class="delete-msg">
                <strong id="deleteMenuName"></strong> 레시피를<br>삭제하시겠습니까?
            </p>
        </div>
        <div class="modal-footer">
            <button type="button" class="cancel-btn" onclick="closeDeleteModal()">아니요</button>
            <button type="button" class="submit-btn btn-danger" onclick="confirmDelete()">예</button>
        </div>
    </div>
</div>

<!-- 삭제용 hidden form -->
<form id="deleteForm" action="/recipeDelete" method="post">
    <input type="hidden" id="deleteRecipeId" name="id">
</form>

<!-- 토스트 -->
<div class="toast" id="toast"></div>

<script>
function openInsertModal() { document.getElementById('insertModal').classList.add('active'); }
function closeInsertModal() { document.getElementById('insertModal').classList.remove('active'); }

function openUpdateModal(menuId, menuName) {
    document.getElementById('updateMenuId').value = menuId;
    document.getElementById('updateMenuName').innerText = menuName;
    document.getElementById('updateModal').classList.add('active');
}
function closeUpdateModal() { document.getElementById('updateModal').classList.remove('active'); }

function openDeleteModal(id, name) {
    document.getElementById('deleteRecipeId').value = id;
    document.getElementById('deleteMenuName').innerText = name;
    document.getElementById('deleteModal').classList.add('active');
}
function closeDeleteModal() { document.getElementById('deleteModal').classList.remove('active'); }
function confirmDelete() { document.getElementById('deleteForm').submit(); }

function showToast(msg) {
    const toast = document.getElementById('toast');
    toast.innerText = msg;
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 2500);
}

document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', function(e) {
        if (e.target === this) this.classList.remove('active');
    });
});
</script>

</body>
</html>