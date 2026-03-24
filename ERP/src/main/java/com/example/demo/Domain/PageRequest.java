package com.example.demo.Domain;

/**
 * 공통 페이지 요청 DTO
 * - Ingredients : category, keyword
 * - Finance (Expense) : expenseType, dateFrom, dateTo, keyword
 * - Finance (Payroll) : payYear, payMonth, keyword
 */
public class PageRequest {

    private int page;
    private int size;

    // ── Ingredients ──────────────────────────
    private String category;

    // ── 공통 키워드 ───────────────────────────
    private String keyword;

    // ── Expense 전용 ──────────────────────────
    private String expenseType;
    private String dateFrom;
    private String dateTo;

    // ── Payroll 전용 ──────────────────────────
    private String payYear;
    private String payMonth;

    // ─────────────────────────────────────────
    public PageRequest(int page, int size) {
        this.page = (page < 1) ? 1 : page;
        this.size = (size < 1) ? 10 : size;
    }

    /** MyBatis OFFSET 자동계산 */
    public int getOffset() {
        return (page - 1) * size;
    }

    // ── Getters / Setters ─────────────────────
    public int getPage()    { return page; }
    public int getSize()    { return size; }
    public void setPage(int page) { this.page = page; }
    public void setSize(int size) { this.size = size; }

    public String getCategory()    { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getKeyword()     { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getExpenseType() { return expenseType; }
    public void setExpenseType(String expenseType) { this.expenseType = expenseType; }

    public String getDateFrom()    { return dateFrom; }
    public void setDateFrom(String dateFrom) { this.dateFrom = dateFrom; }

    public String getDateTo()      { return dateTo; }
    public void setDateTo(String dateTo) { this.dateTo = dateTo; }

    public String getPayYear()     { return payYear; }
    public void setPayYear(String payYear) { this.payYear = payYear; }

    public String getPayMonth()    { return payMonth; }
    public void setPayMonth(String payMonth) { this.payMonth = payMonth; }
}