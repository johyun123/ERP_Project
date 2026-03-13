package com.example.demo.controller;

import com.example.demo.Domain.Ingredients;
import com.example.demo.Domain.Purchases;
import com.example.demo.Domain.PurchaseItems;
import com.example.demo.Domain.Suppliers;
import com.example.demo.Service.IngredientsService;
import com.example.demo.Service.PurchasesService;
import com.example.demo.Service.SuppliersService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class IngredientsController {

    private final IngredientsService ingredientsService;
    private final SuppliersService   suppliersService;
    private final PurchasesService   purchasesService;

    public IngredientsController(IngredientsService is, SuppliersService ss, PurchasesService ps) {
        this.ingredientsService = is;
        this.suppliersService   = ss;
        this.purchasesService   = ps;
    }

    // ============================================================
    // 재고 현황
    // ============================================================
    @GetMapping("/inventory")
    public String stock(Model model) {
        model.addAttribute("list", ingredientsService.getAll());
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

    @PostMapping("/inventory/update")
    public String stockUpdate(@ModelAttribute Ingredients i) {
        ingredientsService.modify(i);
        return "redirect:/inventory";
    }

    @PostMapping("/inventory/delete/{id}")
    public String stockDelete(@PathVariable long id) {
        ingredientsService.remove(id);
        return "redirect:/inventory";
    }

    // ============================================================
    // 거래처 등록
    // ============================================================
    @GetMapping("/inventory/vendor/register")
    public String supplierRegist() {
        return "Ingredients/supplierRegist";
    }

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

        if (file != null && !file.isEmpty()) {
            String filename = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String uploadDir = System.getProperty("user.dir")
                             + "/src/main/resources/static/uploads/contracts/";
            Path path = Paths.get(uploadDir + filename);
            Files.createDirectories(path.getParent());
            Files.write(path, file.getBytes());
            s.setContract_file("/uploads/contracts/" + filename);
        }

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
    public String purchaseList(Model model) {
        model.addAttribute("list", purchasesService.getAll());
        return "Ingredients/purchaseList";
    }

    /** 발주 상세 아이템 목록 - JSON 반환 */
    @GetMapping("/inventory/order/items/{purchaseId}")
    @ResponseBody
    public List<Map<String, Object>> purchaseItems(@PathVariable long purchaseId) {
        return purchasesService.getItems(purchaseId);
    }

    @PostMapping("/inventory/order/update")
    public String purchaseUpdate(@ModelAttribute Purchases p) {
        purchasesService.modify(p);
        return "redirect:/inventory/order/history";
    }

    @PostMapping("/inventory/order/cancel/{id}")
    public String purchaseCancel(@PathVariable long id) {
        purchasesService.cancel(id);
        return "redirect:/inventory/order/history";
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
            @RequestParam int total_cost,
            @RequestParam String itemsJson) throws Exception {

        Purchases p = new Purchases();
        p.setSupplier(supplier);
        p.setOrdered_at(LocalDate.parse(ordered_at));
        p.setNote(note);
        p.setTotal_cost(total_cost);


        List<PurchaseItems> items = new ArrayList<>();
        String cleaned = itemsJson.trim().replaceAll("^\\[|\\]$", ""); 
        String[] objects = cleaned.split("\\},\\{");                   

        for (String obj : objects) {
            obj = obj.replaceAll("[\\[\\]\\{\\}]", "").trim();         
            PurchaseItems item = new PurchaseItems();
            for (String kv : obj.split(",")) {
                String[] pair = kv.split(":");
                if (pair.length < 2) continue;
                String key = pair[0].replaceAll("\"", "").trim();
                String val = pair[1].replaceAll("\"", "").trim();
                switch (key) {
                    case "id":        item.setIngredient_id(Long.parseLong(val));    break;
                    case "qty":       item.setQty(Double.parseDouble(val));          break;
                    case "unit_cost": item.setUnit_cost(Integer.parseInt(val));      break;
                }
            }
            item.setSubtotal((int)(item.getQty() * item.getUnit_cost()));
            items.add(item);
        }

        purchasesService.register(p, items);
        return "redirect:/inventory/order/history";
    }
}
