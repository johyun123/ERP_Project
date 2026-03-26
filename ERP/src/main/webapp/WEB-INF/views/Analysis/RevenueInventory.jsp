<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>재고 소진 추이 예측 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Analysis/analysis.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">재고 소진 추이 예측 <span>원재료별 소진 예측일 분석</span></div>
        <button class="btn btn-primary" onclick="runInventoryForecast()">🔮 예측 실행</button>
    </div>

    <div class="coming-soon-card">
        <div class="coming-soon-icon">📦</div>
        <div class="coming-soon-title">재고 소진 추이 예측 준비 중</div>
        <div class="coming-soon-desc">
            Python · RPA 연동 후 아래 기능이 활성화됩니다.
        </div>
        <ul class="coming-soon-list">
            <li>📉 원재료별 일평균 소비량 계산</li>
            <li>📅 예상 소진일 자동 산출</li>
            <li>⚠️ 소진 임박 원재료 알림</li>
            <li>🛒 발주 시점 자동 추천</li>
        </ul>
        <button class="btn btn-secondary" style="margin-top:20px;" onclick="runInventoryForecast()">
            🔄 FastAPI 연동 테스트
        </button>
    </div>

</div>

<script>
function runInventoryForecast() {
    // TODO: FastAPI /analysis/inventory 호출
    alert('Python FastAPI 연동 후 사용 가능합니다.\n\nPOST /analysis/inventory/result 로 결과를 수신합니다.');
}
</script>
</body>
</html>
