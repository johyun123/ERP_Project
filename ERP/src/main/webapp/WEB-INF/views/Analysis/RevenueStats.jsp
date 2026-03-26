<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>수익통계 | ERP CAFE</title>
    <link rel="stylesheet" href="/css/header.css"/>
    <link rel="stylesheet" href="/css/Analysis/analysis.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp"/>

<div class="content">

    <div class="page-header">
        <div class="page-title">수익통계 <span>매출분개 및 재무제표를 조회합니다</span></div>
        <div style="display:flex; gap:10px;">
            <button class="btn btn-secondary" onclick="refreshData()">🔄 최신화</button>
            <button class="btn btn-primary"   onclick="downloadExcel()">⬇ 다운로드</button>
        </div>
    </div>

    <%-- 탭 --%>
    <div class="analysis-tabs">
        <button class="analysis-tab-btn ${tab == 'journal'   ? 'active' : ''}" onclick="switchTab('journal',   this)">📒 매출분개</button>
        <button class="analysis-tab-btn ${tab == 'statement' ? 'active' : ''}" onclick="switchTab('statement', this)">📊 재무제표</button>
    </div>

    <%-- 데이터 없을 때 안내 배너 --%>
    <div id="noBanner" class="no-data-banner">
        📭 FastAPI에서 아직 데이터를 받지 못했습니다. Python 분석 실행 후 최신화 버튼을 눌러주세요.
    </div>

    <%-- ===== 매출분개 탭 ===== --%>
    <div id="tab-journal" class="tab-content ${tab == 'journal' ? 'active' : ''}">

        <%-- 요약 카드 --%>
        <div class="stat-row">
            <div class="stat-card">
                <div class="stat-icon blue">💰</div>
                <div class="stat-info">
                    <div class="label">총 매출</div>
                    <div class="value" id="totalRevenue">-</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon red">💸</div>
                <div class="stat-info">
                    <div class="label">총 지출</div>
                    <div class="value red" id="totalExpense">-</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">📈</div>
                <div class="stat-info">
                    <div class="label">당기순이익</div>
                    <div class="value" id="netProfit">-</div>
                </div>
            </div>
        </div>

        <%-- 차트 2개 --%>
        <div class="analysis-grid">
            <div class="chart-card">
                <div class="chart-card-header"><h3>📈 월별 매출 / 지출 추이</h3></div>
                <div class="chart-wrap"><canvas id="barChart"></canvas></div>
            </div>
            <div class="chart-card">
                <div class="chart-card-header"><h3>🍩 지출 항목별 비중</h3></div>
                <div class="chart-wrap"><canvas id="donutChart"></canvas></div>
            </div>
        </div>

        <%-- 순이익 라인 차트 --%>
        <div class="chart-card" style="margin-bottom:20px;">
            <div class="chart-card-header"><h3>💰 순이익 추이</h3></div>
            <div class="chart-wrap"><canvas id="lineChart"></canvas></div>
        </div>

        <%-- 분개장 테이블 --%>
        <div class="table-card">
            <div class="table-card-header">
                <h3>📒 매출분개 내역</h3>
                <span id="journalCount" style="font-size:0.82rem; color:var(--text-muted);"></span>
            </div>
            <div id="journalTable">
                <div class="empty-placeholder">최신화 버튼을 눌러 데이터를 불러오세요.</div>
            </div>
        </div>
    </div>

    <%-- ===== 재무제표 탭 ===== --%>
    <div id="tab-statement" class="tab-content ${tab == 'statement' ? 'active' : ''}">

        <div class="statement-grid">
            <div class="statement-card">
                <div class="statement-card-header">📋 재무상태표</div>
                <div id="balanceSheet"><div class="empty-placeholder">최신화 버튼을 눌러 데이터를 불러오세요.</div></div>
            </div>
            <div class="statement-card">
                <div class="statement-card-header">📊 손익계산서</div>
                <div id="incomeStatement"><div class="empty-placeholder">최신화 버튼을 눌러 데이터를 불러오세요.</div></div>
            </div>
            <div class="statement-card">
                <div class="statement-card-header">💼 자본변동표</div>
                <div id="equityStatement"><div class="empty-placeholder">최신화 버튼을 눌러 데이터를 불러오세요.</div></div>
            </div>
        </div>
    </div>

</div>

<script>
var currentTab = '${tab}';
var barChart, donutChart, lineChart;

/* ===== 탭 전환 ===== */
function switchTab(tab, btn) {
    document.querySelectorAll('.tab-content').forEach(function(el) { el.classList.remove('active'); });
    document.querySelectorAll('.analysis-tab-btn').forEach(function(b) { b.classList.remove('active'); });
    document.getElementById('tab-' + tab).classList.add('active');
    btn.classList.add('active');
    currentTab = tab;
    history.replaceState(null, '', '/analysis/stats?tab=' + tab);
}

/* ===== 최신화 ===== */
function refreshData() {
    var btn = event.currentTarget;
    btn.disabled = true;
    btn.textContent = '⏳ 불러오는 중...';

    var api = currentTab === 'journal' ? '/api/revenue/journal' : '/api/revenue/statement';

    fetch(api)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (!data || Object.keys(data).length === 0) {
                alert('아직 FastAPI에서 받은 데이터가 없습니다.\nPython 분석을 먼저 실행해주세요.');
                return;
            }
            document.getElementById('noBanner').style.display = 'none';
            if (currentTab === 'journal') renderJournal(data);
            else                          renderStatement(data);
        })
        .catch(function(e) { alert('불러오기 실패: ' + e.message); })
        .finally(function() {
            btn.disabled = false;
            btn.textContent = '🔄 최신화';
        });
}

/* ===== 매출분개 렌더링 ===== */
function renderJournal(data) {
    // 요약 카드
    var totalRevenue = data.total_revenue || 0;
    var totalExpense = data.total_expense || 0;
    var netProfit    = data.net_profit    || (totalRevenue - totalExpense);

    document.getElementById('totalRevenue').textContent = totalRevenue.toLocaleString() + '원';
    document.getElementById('totalExpense').textContent = totalExpense.toLocaleString() + '원';
    document.getElementById('netProfit').textContent    = netProfit.toLocaleString()    + '원';
    document.getElementById('netProfit').className      = 'value ' + (netProfit >= 0 ? 'green' : 'red');

    // 월별 데이터 (monthly_trends: [{month, revenue, expense, net_profit}])
    var trends   = data.monthly_trends || [];
    var labels   = trends.map(function(t) { return t.month; });
    var revenues = trends.map(function(t) { return t.revenue || 0; });
    var expenses = trends.map(function(t) { return t.expense || 0; });
    var profits  = trends.map(function(t) { return t.net_profit || (t.revenue - t.expense); });

    // ① 바 차트
    if (barChart) barChart.destroy();
    barChart = new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                { label: '매출', data: revenues, backgroundColor: 'rgba(91,110,245,0.7)', borderRadius: 6 },
                { label: '지출', data: expenses, backgroundColor: 'rgba(239,68,68,0.5)',  borderRadius: 6 }
            ]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'top' } },
            scales: { y: { ticks: { callback: function(v) { return v.toLocaleString() + '원'; } } } }
        }
    });

    // ② 도넛 차트 (expense_details: [{expense_type, amount}])
    var expTypes = data.expense_details || [];
    if (donutChart) donutChart.destroy();
    var colors = ['#5b6ef5','#ef4444','#f59e0b','#22c55e','#8b5cf6','#06b6d4','#ec4899'];
    donutChart = new Chart(document.getElementById('donutChart'), {
        type: 'doughnut',
        data: {
            labels: expTypes.map(function(e) { return e.expense_type; }),
            datasets: [{
                data: expTypes.map(function(e) { return e.amount || 0; }),
                backgroundColor: colors.slice(0, expTypes.length),
                borderWidth: 2, borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'right' },
                tooltip: { callbacks: { label: function(ctx) { return ctx.label + ': ' + ctx.raw.toLocaleString() + '원'; } } }
            }
        }
    });

    // ③ 순이익 라인 차트
    if (lineChart) lineChart.destroy();
    lineChart = new Chart(document.getElementById('lineChart'), {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: '순이익',
                data: profits,
                borderColor: '#22c55e',
                backgroundColor: 'rgba(34,197,94,0.08)',
                borderWidth: 2.5, pointRadius: 5, tension: 0.3, fill: true
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'top' } },
            scales: { y: { ticks: { callback: function(v) { return v.toLocaleString() + '원'; } } } }
        }
    });

    // ④ 분개장 테이블 (journal_entries: [{date, type, description, debit, credit}])
    var entries = data.journal_entries || [];
    document.getElementById('journalCount').textContent = '총 ' + entries.length + '건';
    if (entries.length === 0) {
        document.getElementById('journalTable').innerHTML = '<div class="empty-placeholder">분개 데이터가 없습니다.</div>';
        return;
    }
    var rows = entries.map(function(e) {
        return '<tr>'
            + '<td>' + (e.date || '-') + '</td>'
            + '<td><span class="badge badge-category">' + (e.type || '-') + '</span></td>'
            + '<td style="text-align:left;">' + (e.description || '-') + '</td>'
            + '<td class="amount-plus">' + (e.debit  ? '+' + Number(e.debit).toLocaleString()  + '원' : '-') + '</td>'
            + '<td class="amount-minus">' + (e.credit ? '-' + Number(e.credit).toLocaleString() + '원' : '-') + '</td>'
            + '</tr>';
    }).join('');
    document.getElementById('journalTable').innerHTML =
        '<table class="data-table"><thead><tr>'
        + '<th>날짜</th><th>유형</th><th>내용</th><th>수입(차변)</th><th>지출(대변)</th>'
        + '</tr></thead><tbody>' + rows + '</tbody></table>';
}

/* ===== 재무제표 렌더링 ===== */
function renderStatement(data) {
    var totalRevenue   = data.total_revenue   || 0;
    var totalExpense   = data.total_expense   || 0;
    var netProfit      = data.net_profit      || (totalRevenue - totalExpense);
    var initialCapital = data.initial_capital || 10000000;
    var totalCapital   = data.total_capital   || (initialCapital + netProfit);
    var expTypes       = data.expense_details || [];

    // 재무상태표
    document.getElementById('balanceSheet').innerHTML = buildTable([
        { label: '초기 자본',   value: initialCapital,  type: 'neutral' },
        { label: '총 수익',     value: totalRevenue,    type: 'plus' },
        { label: '총 지출',     value: totalExpense,    type: 'minus' },
        { label: '당기순이익',  value: netProfit,       type: netProfit >= 0 ? 'plus' : 'minus' },
        { label: '자본 총액',   value: totalCapital,    type: 'total' },
        { label: '부채',        value: 0,               type: 'neutral' },
        { label: '자산 총액',   value: totalCapital,    type: 'total' }
    ]);

    // 손익계산서
    var incomeRows = expTypes.map(function(e) {
        return { label: (e.expense_type || '기타') + ' 지출', value: e.amount || 0, type: 'minus' };
    });
    incomeRows.push({ label: '총 매출',    value: totalRevenue, type: 'plus' });
    incomeRows.push({ label: '총 지출',    value: totalExpense, type: 'minus' });
    incomeRows.push({ label: '당기순이익', value: netProfit,    type: netProfit >= 0 ? 'plus' : 'minus', bold: true });
    document.getElementById('incomeStatement').innerHTML = buildTable(incomeRows);

    // 자본변동표
    document.getElementById('equityStatement').innerHTML = buildTable([
        { label: '전기 자본',    value: initialCapital, type: 'neutral' },
        { label: '당기순이익',   value: netProfit,      type: netProfit >= 0 ? 'plus' : 'minus' },
        { label: '현재 자본',    value: totalCapital,   type: 'total' },
        { label: '자본변동 총액', value: netProfit,     type: netProfit >= 0 ? 'plus' : 'minus', bold: true }
    ]);
}

function buildTable(rows) {
    var html = '<table class="statement-table">';
    rows.forEach(function(row) {
        var cls    = row.type === 'plus' ? 'amount-plus' : row.type === 'minus' ? 'amount-minus' : row.type === 'total' ? 'amount-total' : '';
        var prefix = row.type === 'plus' ? '+' : row.type === 'minus' ? '-' : '';
        html += '<tr' + (row.bold ? ' class="row-total"' : '') + '>'
            + '<td class="st-label">' + row.label + '</td>'
            + '<td class="st-value ' + cls + '">' + prefix + Math.abs(row.value).toLocaleString() + '원</td>'
            + '</tr>';
    });
    return html + '</table>';
}

/* ===== 다운로드 ===== */
function downloadExcel() {
    location.href = '/analysis/excel/download';
}
</script>
</body>
</html>
