package com.example.demo.Domain;

public class OrderPageRequest {
    private int    page;
    private int    size;
    private String keyword;   // 주문번호 or 결제수단 검색
    private String status;    // 상태 필터 (대기/완료/취소)
    private String dateFrom;  // 시작일 (yyyy-MM-dd)
    private String dateTo;    // 종료일 (yyyy-MM-dd)

    public OrderPageRequest() {
        this.page = 1;
        this.size = 10;
    }

    public OrderPageRequest(int page, int size) {
        this.page = page;
        this.size = size;
    }

    public int getOffset() {
        return (page - 1) * size;
    }

    public int    getPage()                  { return page; }
    public void   setPage(int page)          { this.page = Math.max(1, page); }
    public int    getSize()                  { return size; }
    public void   setSize(int size)          { this.size = size; }
    public String getKeyword()               { return keyword; }
    public void   setKeyword(String keyword) { this.keyword = keyword; }
    public String getStatus()                { return status; }
    public void   setStatus(String status)   { this.status = status; }
    public String getDateFrom()              { return dateFrom; }
    public void   setDateFrom(String d)      { this.dateFrom = d; }
    public String getDateTo()                { return dateTo; }
    public void   setDateTo(String d)        { this.dateTo = d; }
}
