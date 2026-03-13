package com.example.demo.Domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Purchases {
    private long id;
    private String supplier;
    private int total_cost;
    private String status;
    private LocalDate ordered_at;
    private LocalDate received_at;
    private String note;
    private LocalDateTime created_at;
    
    
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getSupplier() {
		return supplier;
	}
	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
	public int getTotal_cost() {
		return total_cost;
	}
	public void setTotal_cost(int total_cost) {
		this.total_cost = total_cost;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public LocalDate getOrdered_at() {
		return ordered_at;
	}
	public void setOrdered_at(LocalDate ordered_at) {
		this.ordered_at = ordered_at;
	}
	public LocalDate getReceived_at() {
		return received_at;
	}
	public void setReceived_at(LocalDate received_at) {
		this.received_at = received_at;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public LocalDateTime getCreated_at() {
		return created_at;
	}
	public void setCreated_at(LocalDateTime created_at) {
		this.created_at = created_at;
	}


}
