"""
forecast_revenue.py — 수익 예측
월별 실적 집계 후 선형 회귀로 향후 N개월 예측
반환: dict {history: [...], forecasts: [...], summary: {...}}
"""

from collections import defaultdict
from datetime import date
from processing.utils import safe_int
from config import FORECAST_MONTHS


def _linear_trend(values: list[float]) -> tuple[float, float]:
    """단순 선형회귀: (slope, intercept)"""
    n = len(values)
    if n < 2:
        return 0.0, float(values[0]) if values else 0.0
    x_mean = (n - 1) / 2.0
    y_mean = sum(values) / n
    num = sum((i - x_mean) * (v - y_mean) for i, v in enumerate(values))
    den = sum((i - x_mean) ** 2 for i in range(n))
    slope = num / den if den != 0 else 0.0
    return slope, y_mean - slope * x_mean


def _next_ym(year: int, month: int, delta: int) -> tuple[int, int]:
    """(year, month)에서 delta개월 후 (음수 가능)"""
    total = (year * 12 + month - 1) + delta
    y = total // 12
    m = total % 12 + 1
    return y, m


def build_revenue_forecast(
    orders:    list,
    expenses:  list,
    payrolls:  list,
    purchases: list,
    months_ahead: int = None,
) -> dict:

    if months_ahead is None:
        months_ahead = 6  # 항상 6개월 예측

    # ── 월별 매출 집계 ──────────────────────────────────────────
    monthly_rev: dict[tuple, int] = defaultdict(int)
    for o in orders:
        if o.get("status") != "완료":
            continue
        dt_str = (o.get("orderedAt") or "")[:10]
        if not dt_str:
            continue
        try:
            dt = date.fromisoformat(dt_str)
            monthly_rev[(dt.year, dt.month)] += safe_int(o.get("finalAmount"))
        except ValueError:
            pass

    # ── 월별 지출 집계 (expenses + payrolls + purchases) ────────
    monthly_exp: dict[tuple, int] = defaultdict(int)
    for e in expenses:
        dt_str = (e.get("expenseDate") or "")[:10]
        if not dt_str:
            continue
        try:
            dt = date.fromisoformat(dt_str)
            monthly_exp[(dt.year, dt.month)] += safe_int(e.get("amount"))
        except ValueError:
            pass

    for p in payrolls:
        y, m = p.get("payYear"), p.get("payMonth")
        if y and m:
            monthly_exp[(int(y), int(m))] += safe_int(p.get("netPay"))

    for pur in purchases:
        if (pur.get("status") or "") not in ("ordered", "received"):
            continue
        dt_str = str(pur.get("ordered_at") or "")[:10]
        if not dt_str:
            continue
        try:
            dt = date.fromisoformat(dt_str)
            monthly_exp[(dt.year, dt.month)] += safe_int(pur.get("total_cost"))
        except ValueError:
            pass

    # ── 현재 월 기준 6개월 전까지만 히스토리 사용 ───────────────
    today = date.today()
    current_ym = (today.year, today.month)
    cutoff_ym = _next_ym(today.year, today.month, -6)  # 6개월 전 (year, month)

    all_months_full = sorted(set(monthly_rev.keys()) | set(monthly_exp.keys()))
    # 6개월 전 이후 ~ 당월 미만 데이터만 사용 (당월 제외: 집계 미완료)
    all_months = [ym for ym in all_months_full if cutoff_ym <= ym < current_ym]

    if not all_months:
        return {"history": [], "forecasts": [], "summary": {}}

    # ── 히스토리 구성 (최근 6개월) ───────────────────────────────
    history = []
    for ym in all_months:
        rev = monthly_rev.get(ym, 0)
        exp = monthly_exp.get(ym, 0)
        history.append({
            "year":       ym[0],
            "month":      ym[1],
            "label":      f"{ym[0]}년 {ym[1]}월",
            "revenue":    rev,
            "expenses":   exp,
            "net_income": rev - exp,
        })

    # ── 최근 6개월 데이터로 트렌드 계산 ─────────────────────────
    window = min(6, len(all_months))
    recent = all_months[-window:]
    rev_vals = [float(monthly_rev.get(m, 0)) for m in recent]
    exp_vals = [float(monthly_exp.get(m, 0)) for m in recent]

    rev_slope, rev_intercept = _linear_trend(rev_vals)
    exp_slope, exp_intercept = _linear_trend(exp_vals)

    # 평균은 전체 히스토리 기간으로 계산 (엑셀 테이블 AVERAGE 범위와 일치)
    avg_rev = sum(float(monthly_rev.get(m, 0)) for m in all_months) / len(all_months)
    avg_exp = sum(float(monthly_exp.get(m, 0)) for m in all_months) / len(all_months)

    # ── 예측 ─────────────────────────────────────────────────────
    last_ym = all_months[-1]
    forecasts = []
    n = len(recent)
    for i in range(1, months_ahead + 1):
        fy, fm = _next_ym(last_ym[0], last_ym[1], i)
        pred_rev = max(0.0, rev_slope * (n - 1 + i) + rev_intercept)
        pred_exp = max(0.0, exp_slope * (n - 1 + i) + exp_intercept)
        forecasts.append({
            "year":                fy,
            "month":               fm,
            "label":               f"{fy}년 {fm}월",
            "predicted_revenue":   round(pred_rev),
            "predicted_expenses":  round(pred_exp),
            "predicted_net_income": round(pred_rev - pred_exp),
        })

    return {
        "history":  history,
        "forecasts": forecasts,
        "summary": {
            "avg_monthly_revenue":   round(avg_rev),
            "avg_monthly_expenses":  round(avg_exp),
            "avg_monthly_net":       round(avg_rev - avg_exp),
            "revenue_trend":         "상승" if rev_slope > 0 else ("하락" if rev_slope < 0 else "보합"),
            "data_months":           len(all_months),
            "forecast_months":       months_ahead,
        },
    }
