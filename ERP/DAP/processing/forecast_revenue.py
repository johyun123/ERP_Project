"""
forecast_revenue.py — 수익 예측
월별 실적을 build_income_statement() 로 집계한 뒤
Holt's Double Exponential Smoothing 으로 향후 N개월 예측.

Holt's 방식:
  - 레벨(l): 현재 평균 수준. α 가 클수록 최근 실적에 더 빠르게 반응.
  - 트렌드(b): 레벨의 변화 속도. β 가 클수록 최근 트렌드 변화에 더 빠르게 반응.
  - h개월 후 예측 = l_T + h * b_T
  - 이상치가 있어도 α/β 평활 덕분에 선형 회귀보다 왜곡이 적음.

α = 0.4  (레벨 평활 — 최근 실적 반영 비중 40%)
β = 0.3  (트렌드 평활 — 최근 트렌드 변화 반영 비중 30%)
"""

from datetime import date
from processing.income import build_income_statement

# ── 평활 파라미터 ─────────────────────────────────────────────────
_ALPHA = 0.4   # 레벨 평활 계수
_BETA  = 0.3   # 트렌드 평활 계수


def _holt(values: list, alpha: float, beta: float) -> tuple:
    """
    Holt's Double Exponential Smoothing.
    반환: (level, trend)  — 마지막 시점 기준
    """
    if not values:
        return 0.0, 0.0
    if len(values) == 1:
        return float(values[0]), 0.0

    # 초기값: 첫 번째 실적을 레벨로, 두 번째와의 차이를 트렌드로
    l = float(values[0])
    b = float(values[1]) - float(values[0])

    for v in values[1:]:
        l_prev, b_prev = l, b
        l = alpha * float(v) + (1 - alpha) * (l_prev + b_prev)
        b = beta  * (l - l_prev) + (1 - beta) * b_prev

    return l, b


def _next_ym(year: int, month: int, delta: int) -> tuple:
    """(year, month) 에서 delta 개월 후"""
    total = (year * 12 + month - 1) + delta
    return total // 12, total % 12 + 1


def build_revenue_forecast(
    orders:         list,
    order_items:    list,
    expenses:       list,
    payrolls:       list,
    purchases:      list,
    purchase_items: list,
    ingredients:    list = None,
    employees:      list = None,
    menus:          list = None,
    categories:     list = None,
    months_ahead:   int  = None,
) -> dict:

    if months_ahead is None:
        months_ahead = 6

    # ── 데이터가 존재하는 월 탐색 ────────────────────────────────
    month_set: set = set()

    for o in orders:
        if o.get("status") != "완료":
            continue
        dt_str = (o.get("orderedAt") or "")[:10]
        if dt_str:
            try:
                dt = date.fromisoformat(dt_str)
                month_set.add((dt.year, dt.month))
            except ValueError:
                pass

    for e in expenses:
        dt_str = (e.get("expenseDate") or "")[:10]
        if dt_str:
            try:
                dt = date.fromisoformat(dt_str)
                month_set.add((dt.year, dt.month))
            except ValueError:
                pass

    for p in payrolls:
        y, m = p.get("payYear"), p.get("payMonth")
        if y and m:
            month_set.add((int(y), int(m)))

    for pur in purchases:
        if (pur.get("status") or "") not in ("ordered", "received"):
            continue
        dt_str = str(pur.get("ordered_at") or "")[:10]
        if dt_str:
            try:
                dt = date.fromisoformat(dt_str)
                month_set.add((dt.year, dt.month))
            except ValueError:
                pass

    # ── 현재 월 기준 6개월 이내 히스토리만 사용 (당월 미포함) ────
    today      = date.today()
    current_ym = (today.year, today.month)
    cutoff_ym  = _next_ym(today.year, today.month, -6)

    all_months = sorted(ym for ym in month_set if cutoff_ym <= ym < current_ym)

    if not all_months:
        return {"history": [], "forecasts": [], "summary": {}}

    # ── 월별 손익 집계 (income.py 재사용 → 손익계산서와 동일 기준) ─
    history = []
    for ym in all_months:
        stmt = build_income_statement(
            orders, order_items, expenses, payrolls,
            purchases, purchase_items,
            ingredients=ingredients,
            employees=employees,
            menus=menus,
            categories=categories,
            year=ym[0],
            month=ym[1],
        )
        rev = stmt["summary"]["총매출"]
        exp = stmt["summary"]["총지출"]
        history.append({
            "year":       ym[0],
            "month":      ym[1],
            "label":      f"{ym[0]}년 {ym[1]}월",
            "revenue":    rev,
            "expenses":   exp,
            "net_income": rev - exp,
        })

    # ── Holt's Double Exponential Smoothing ──────────────────────
    window  = min(6, len(history))
    recent  = history[-window:]

    rev_vals = [h["revenue"]    for h in recent]
    exp_vals = [h["expenses"]   for h in recent]
    net_vals = [h["net_income"] for h in recent]

    rev_l, rev_b = _holt(rev_vals, _ALPHA, _BETA)
    exp_l, exp_b = _holt(exp_vals, _ALPHA, _BETA)
    net_l, net_b = _holt(net_vals, _ALPHA, _BETA)

    avg_rev = sum(h["revenue"]  for h in history) / len(history)
    avg_exp = sum(h["expenses"] for h in history) / len(history)

    # ── 예측: l_T + h * b_T ──────────────────────────────────────
    last_ym   = all_months[-1]
    forecasts = []
    for h in range(1, months_ahead + 1):
        fy, fm   = _next_ym(last_ym[0], last_ym[1], h)
        pred_rev = max(0.0, rev_l + h * rev_b)
        pred_exp = max(0.0, exp_l + h * exp_b)
        forecasts.append({
            "year":                  fy,
            "month":                 fm,
            "label":                 f"{fy}년 {fm}월",
            "predicted_revenue":     round(pred_rev),
            "predicted_expenses":    round(pred_exp),
            "predicted_net_income":  round(pred_rev - pred_exp),
        })

    # 트렌드 판정: Holt's 마지막 트렌드(b) 기준 — 순이익 방향
    trend_label = "상승" if net_b > 0 else ("하락" if net_b < 0 else "보합")

    return {
        "history":  history,
        "forecasts": forecasts,
        "summary": {
            "avg_monthly_revenue":   round(avg_rev),
            "avg_monthly_expenses":  round(avg_exp),
            "avg_monthly_net":       round(avg_rev - avg_exp),
            "revenue_trend":         trend_label,
            "data_months":           len(all_months),
            "forecast_months":       months_ahead,
        },
    }
