<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>수익 예측 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Analysis/analysis.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">수익 예측 <span>매출 · 수입 · 지출 · 순익 예측</span></div>
        <button class="btn btn-primary" onclick="runForecast()">🔮 예측 실행</button>
    </div>

    <div class="coming-soon-card">
        <div class="coming-soon-icon">🔮</div>
        <div class="coming-soon-title">수익 예측 준비 중</div>
        <div class="coming-soon-desc">
            Python · RPA 연동 후 아래 기능이 활성화됩니다.
        </div>
        <ul class="coming-soon-list">
            <li>📈 월별 매출 예측 (이동평균 / 회귀 분석)</li>
            <li>💸 지출 트렌드 분석</li>
            <li>💰 분기별 순익 예측</li>
            <li>📊 년별 재무제표 자동 생성</li>
        </ul>
        <button class="btn btn-secondary" style="margin-top:20px;" onclick="runForecast()">
            🔄 FastAPI 연동 테스트
        </button>
    </div>

</div>

<script>
function runForecast() {
    // TODO: FastAPI /analysis/forecast 호출
    alert('Python FastAPI 연동 후 사용 가능합니다.\n\nPOST /analysis/forecast/result 로 결과를 수신합니다.');
}
</script>
</body>
</html>
