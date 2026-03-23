package com.example.demo.controller;

import com.example.demo.Domain.*;
import com.example.demo.Service.IngredientsService;
import com.example.demo.Service.PurchasesService;
import com.example.demo.Service.SuppliersService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
public class IngredientsController {

    private final IngredientsService ingredientsService;
    private final SuppliersService   suppliersService;
    private final PurchasesService   purchasesService;
    private final ObjectMapper       objectMapper;

    public IngredientsController(IngredientsService is, SuppliersService ss,
                                 PurchasesService ps, ObjectMapper objectMapper) {
        this.ingredientsService = is;
        this.suppliersService   = ss;
        this.purchasesService   = ps;
        this.objectMapper       = objectMapper;
    }

    // ============================================================
    // 재고 현황
    // ============================================================
    @GetMapping("/inventory")
    public String stock(
            @RequestParam(defaultValue = "1")  int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false)    String category,
            @RequestParam(required = false)    String keyword,
            @RequestParam(required = false)    String deleteError,
            Model model) {

        PageRequest req = new PageRequest(page, size);
        req.setCategory(category);
        req.setKeyword(keyword);

        PageResult<Ingredients> result = ingredientsService.getByPage(req);
        model.addAttribute("result",      result);
        model.addAttribute("category",    category);
        model.addAttribute("keyword",     keyword);
        model.addAttribute("size",        size);
        // [버그수정 2] 발주 이력 있어 삭제 실패 시 알림 플래그
        model.addAttribute("deleteError", deleteError);
        return "Ingredients/ingredient";
    }

    @PostMapping("/inventory/register")
    public String stockRegister(@ModelAttribute Ingredients i) {
        ingredientsService.register(i);
        return "redirect:/inventory";
    }

    @GetMapping("/inventory/{id}")
    @ResponseBody
    public Ingredients stockGetOne(@PathVariable long id) {
        return ingredientsService.getById(id);
    }

    // [버그수정 1] redirect URL 한글 인코딩 — UriComponentsBuilder 적용
    @PostMapping("/inventory/update")
    public String stockUpdate(
            @ModelAttribute Ingredients i,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false)   String category,
            @RequestParam(required = false)   String keyword) {

        ingredientsService.modify(i);
        return buildInventoryRedirect(page, category, keyword);
    }

    // [버그수정 1] redirect 한글 인코딩
    // [버그수정 2] 발주 이력 있으면 삭제 거부 → 알림 플래그 전달
    @PostMapping("/inventory/delete/{id}")
    public String stockDelete(
            @PathVariable long id,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false)   String category,
            @RequestParam(required = false)   String keyword) {

        if (ingredientsService.hasPurchaseHistory(id)) {
            UriComponentsBuilder b = UriComponentsBuilder
                    .fromPath("/inventory")
                    .queryParam("page", page)
                    .queryParam("deleteError", "true");
            if (category != null) b.queryParam("category", category);
            if (keyword  != null) b.queryParam("keyword",  keyword);
            return "redirect:" + b.build().encode().toUriString();
        }
        ingredientsService.remove(id);
        return buildInventoryRedirect(page, category, keyword);
    }

    // ============================================================
    // 거래처 등록 (팝업 POST — GET 엔드포인트 제거)
    // ============================================================
    @PostMapping("/inventory/vendor/register")
    public String supplierRegistPost(
            @RequestParam String supplier_name,
            @RequestParam(required = false) String supplier_type,
            @RequestParam(required = false) String ceo_name,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String note,
            @RequestParam(value = "contract_file", required = false) MultipartFile file
    ) throws IOException {
        Suppliers s = new Suppliers();
        s.setSupplier_name(supplier_name);
        s.setSupplier_type(supplier_type);
        s.setCeo_name(ceo_name);
        s.setAddress(address);
        s.setNote(note);
        s.setContract_file(saveContractFile(file));
        suppliersService.register(s);
        return "redirect:/inventory/vendor";
    }

    // ============================================================
    // 거래처 관리
    // ============================================================
    @GetMapping("/inventory/vendor")
    public String supplierList(Model model) {
        model.addAttribute("list", suppliersService.getAll());
        return "Ingredients/supplierList";
    }

    @PostMapping("/inventory/vendor/update")
    public String supplierUpdate(@ModelAttribute Suppliers s) {
        suppliersService.modify(s);
        return "redirect:/inventory/vendor";
    }

    @PostMapping("/inventory/vendor/delete/{id}")
    public String supplierDelete(@PathVariable long id) {
        suppliersService.remove(id);
        return "redirect:/inventory/vendor";
    }

    // ============================================================
    // 발주 내역
    // ============================================================
    @GetMapping("/inventory/order/history")
    public String purchaseList(
            @RequestParam(defaultValue = "1")  int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false)    String keyword,
            Model model) {

        PageRequest req = new PageRequest(page, size);
        req.setKeyword(keyword);

        PageResult<Purchases> result = purchasesService.getByPage(req);
        model.addAttribute("result",  result);
        model.addAttribute("keyword", keyword);
        model.addAttribute("size",    size);
        return "Ingredients/purchaseList";
    }

    @GetMapping("/inventory/order/items/{purchaseId}")
    @ResponseBody
    public List<Map<String, Object>> purchaseItems(@PathVariable long purchaseId) {
        return purchasesService.getItems(purchaseId);
    }

    @PostMapping("/inventory/order/update")
    public String purchaseUpdate(@ModelAttribute Purchases p,
                                 @RequestParam(defaultValue = "1") int page) {
        purchasesService.modify(p);
        return "redirect:/inventory/order/history?page=" + page;
    }

    @PostMapping("/inventory/order/cancel/{id}")
    public String purchaseCancel(@PathVariable long id,
                                 @RequestParam(defaultValue = "1") int page) {
        purchasesService.cancel(id);
        return "redirect:/inventory/order/history?page=" + page;
    }

    // ============================================================
    // 발주 등록
    // ============================================================
    @GetMapping("/inventory/order")
    public String purchaseOrder(Model model) {
        model.addAttribute("ingredientList", ingredientsService.getAll());
        return "Ingredients/purchaseOrder";
    }

    @PostMapping("/inventory/order")
    public String purchaseOrderPost(
            @RequestParam String supplier,
            @RequestParam String ordered_at,
            @RequestParam(required = false) String note,
            @RequestParam int    total_cost,
            @RequestParam String itemsJson) throws Exception {

        Purchases p = new Purchases();
        p.setSupplier(supplier);
        p.setOrdered_at(LocalDate.parse(ordered_at));
        p.setNote(note);
        p.setTotal_cost(total_cost);

        List<Map<String, Object>> rawItems = objectMapper.readValue(
                itemsJson, new TypeReference<List<Map<String, Object>>>() {});

        List<PurchaseItems> items = rawItems.stream().map(raw -> {
            PurchaseItems item = new PurchaseItems();
            item.setIngredient_id(((Number) raw.get("id")).longValue());
            item.setQty(((Number) raw.get("qty")).doubleValue());
            item.setUnit_cost(((Number) raw.get("unit_cost")).intValue());
            item.setSubtotal((int) (item.getQty() * item.getUnit_cost()));
            return item;
        }).toList();

        purchasesService.register(p, items);
        return "redirect:/inventory/order/history";
    }

    // ── private 헬퍼 ──────────────────────────────────────────

    /** 재고 목록 redirect — 한글 카테고리 자동 인코딩 */
    private String buildInventoryRedirect(int page, String category, String keyword) {
        UriComponentsBuilder b = UriComponentsBuilder
                .fromPath("/inventory")
                .queryParam("page", page);
        if (category != null) b.queryParam("category", category);
        if (keyword  != null) b.queryParam("keyword",  keyword);
        return "redirect:" + b.build().encode().toUriString();
    }

    /** 거래처 계약서 파일 저장 후 웹 경로 반환 */
    private String saveContractFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) return null;
        String filename  = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        String uploadDir = System.getProperty("user.dir")
                         + "/src/main/resources/static/uploads/contracts/";
        Path path = Paths.get(uploadDir + filename);
        Files.createDirectories(path.getParent());
        Files.write(path, file.getBytes());
        return "/uploads/contracts/" + filename;
    }
}