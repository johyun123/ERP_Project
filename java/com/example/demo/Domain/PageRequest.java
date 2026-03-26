package com.example.demo.Domain;

public class PageRequest {
    private int page;       // 현재 페이지 (1부터 시작)
    private int size;       // 페이지당 항목 수
    private String category; // 카테고리 필터 (null이면 전체)
    private String keyword;  // 검색어 (null이면 전체)

    public PageRequest() {
        this.page = 1;
        this.size = 10;
    }

    public PageRequest(int page, int size) {
        this.page = page;
        this.size = size;
    }

    // LIMIT offset 계산
    public int getOffset() {
        return (page - 1) * size;
    }

    public int getPage()               { return page; }
    public void setPage(int page)      { this.page = Math.max(1, page); }

    public int getSize()               { return size; }
    public void setSize(int size)      { this.size = size; }

    public String getCategory()              { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getKeyword()             { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
}