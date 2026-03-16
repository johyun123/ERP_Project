package com.example.demo.Domain;

public class FinanceExpense {
	private Long   id;
    private String expenseType;
    private int    amount;
    private String expenseDate;   // "yyyy-MM-dd"
    private String description;
    private Long   registeredBy;
    private String createdAt;
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getExpenseType() {
		return expenseType;
	}
	public void setExpenseType(String expenseType) {
		this.expenseType = expenseType;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public String getExpenseDate() {
		return expenseDate;
	}
	public void setExpenseDate(String expenseDate) {
		this.expenseDate = expenseDate;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Long getRegisteredBy() {
		return registeredBy;
	}
	public void setRegisteredBy(Long registeredBy) {
		this.registeredBy = registeredBy;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
}
