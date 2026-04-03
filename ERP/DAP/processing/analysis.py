"""
analysis.py — Claude API를 활용한 재무 동향 AI 분석
최신화 시 재무제표 데이터를 바탕으로 경영 평가 및 개선안 생성.
ANTHROPIC_API_KEY 미설정 또는 호출 실패 시 빈 문자열 반환 (전체 흐름 중단 없음).
"""

import os


def build_financial_analysis(
    income:   dict,
    balance:  dict,
    forecast: dict,
    period:   str = "",
) -> str:
    """
    재무 데이터를 Claude에게 전달해 분석 텍스트 생성.
    반환: 마크다운 형식의 분석 문자열 (실패 시 "")
    """
    api_key = os.getenv("ANTHROPIC_API_KEY", "").strip()
    if not api_key:
        print("[analysis] ANTHROPIC_API_KEY 미설정 — AI 분석 생략")
        return ""

    try:
        import anthropic
    except ImportError:
        print("[analysis] anthropic 패키지 미설치 — pip install anthropic")
        return ""

    summary  = income.get("summary",  {})
    payroll  = income.get("payroll",  {})
    purch    = income.get("purchases",{})
    exp      = income.get("expenses", {})
    current  = balance.get("current", {})
    fc_sum   = forecast.get("summary",{})
    history  = forecast.get("history", [])

    total_revenue = summary.get("총매출",     0)
    total_expense = summary.get("총지출",     0)
    net_income    = summary.get("당기순이익", 0)
    cash          = current.get("현금",       0)
    inventory     = current.get("재고",       0)
    trend         = fc_sum.get("revenue_trend", "")
    avg_rev       = fc_sum.get("avg_monthly_revenue", 0)

    # 최근 3개월 추이 요약
    recent_months = history[-3:] if len(history) >= 3 else history
    monthly_summary = "\n".join(
        f"  - {h['label']}: 매출 {h['revenue']:,}원 / 지출 {h['expenses']:,}원 / 순이익 {h['net_income']:,}원"
        for h in recent_months
    ) or "  데이터 없음"

    margin_pct = round((net_income / total_revenue * 100), 1) if total_revenue else 0
    payroll_ratio = round((payroll.get('급여소계', 0) / total_expense * 100), 1) if total_expense else 0
    purchase_ratio = round((purch.get('발주소계', 0) / total_expense * 100), 1) if total_expense else 0

    prompt = f"""당신은 카페 경영 재무 전문가입니다.
아래 재무 데이터를 분석하여 경영진에게 전달할 보고서를 작성해주세요.

=== 분석 기간: {period} ===

[손익 현황]
- 총 매출: {total_revenue:,}원
- 총 지출: {total_expense:,}원
- 당기순이익: {net_income:,}원 (순이익률 {margin_pct}%)

[지출 구성]
- 급여 소계: {payroll.get('급여소계', 0):,}원 (지출 대비 {payroll_ratio}%)
- 발주 소계: {purch.get('발주소계', 0):,}원 (지출 대비 {purchase_ratio}%)
- 임대료: {exp.get('임대료', 0):,}원
- 공과금: {exp.get('공과금', 0):,}원
- 마케팅: {exp.get('마케팅', 0):,}원
- 기타 지출: {exp.get('기타', 0):,}원

[재무 상태]
- 현금 보유: {cash:,}원
- 재고 자산: {inventory:,}원

[최근 월별 추이]
{monthly_summary}

[예측 지표]
- 수익 트렌드: {trend}
- 월평균 매출: {avg_rev:,}원

---
아래 형식으로 한국어로 작성해주세요. 각 항목은 2~3문장으로 간결하게:

**📊 재무 동향 평가**
(현재 재무 상태의 전반적 평가. 수익성, 비용 구조, 현금 흐름 중심)

**⚠️ 주요 리스크**
(주의해야 할 재무적 위험 요소 1~2가지)

**💡 개선 권고사항**
(수익성 개선을 위한 구체적이고 실행 가능한 방안 3가지. 번호 매기기)"""

    try:
        client = anthropic.Anthropic(api_key=api_key)
        message = client.messages.create(
            model="claude-haiku-4-5",
            max_tokens=1024,
            messages=[{"role": "user", "content": prompt}],
        )
        result = message.content[0].text
        print(f"[analysis] AI 분석 완료 ({len(result)}자)")
        return result
    except Exception as e:
        print(f"[analysis] Claude API 호출 실패: {e}")
        return ""
