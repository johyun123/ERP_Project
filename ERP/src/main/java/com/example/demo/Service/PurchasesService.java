package com.example.demo.Service;

import com.example.demo.Domain.Purchases;
import com.example.demo.Domain.PurchaseItems;
import com.example.demo.mapper.PurchasesMapper;
import com.example.demo.mapper.PurchaseItemsMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class PurchasesService {

    private final PurchasesMapper     purchasesMapper;
    private final PurchaseItemsMapper purchaseItemsMapper;

    public PurchasesService(PurchasesMapper pm, PurchaseItemsMapper pim) {
        this.purchasesMapper     = pm;
        this.purchaseItemsMapper = pim;
    }

    public List<Purchases> getAll() {
        return purchasesMapper.findAll();
    }

    public Purchases getById(long id) {
        return purchasesMapper.findById(id);
    }

    /** 발주 id로 아이템 목록 조회 (원재료명 포함) */
    public List<Map<String, Object>> getItems(long purchaseId) {
        return purchaseItemsMapper.findByPurchaseId(purchaseId);
    }

    @Transactional
    public void register(Purchases p, List<PurchaseItems> items) {
        purchasesMapper.insert(p);
        for (PurchaseItems item : items) {
            item.setPurchase_id(p.getId());
            purchaseItemsMapper.insert(item);
        }
    }

    public void modify(Purchases p) {
        purchasesMapper.update(p);
    }

    public void cancel(long id) {
        purchasesMapper.cancel(id);
    }
}
