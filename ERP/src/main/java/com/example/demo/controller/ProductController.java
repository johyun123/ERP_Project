package com.example.demo.controller;

import com.example.demo.Domain.MenuDomain;
import com.example.demo.Domain.CategoryDomain;
import com.example.demo.Service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    /* ===== 제품 관리 페이지 ===== */
    @GetMapping("/product/menu")
    public String product(Model model) {
        model.addAttribute("menuList",     productService.getMenuList());
        model.addAttribute("categoryList", productService.getCategoryList());
        return "Product/product";
    }

    /* ===== 제품 등록 ===== */
    @PostMapping("/productInsert")
    public String productInsert(
            @RequestParam Long   category_id,
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam int    price,
            @RequestParam int    cost,
            @RequestParam int    isAvailable) {

        productService.insertMenu(buildMenu(null, category_id, name, description, price, cost, isAvailable));
        return "redirect:/product/menu";
    }

    /* ===== 제품 수정 ===== */
    @PostMapping("/productUpdate")
    public String productUpdate(
            @RequestParam Long   id,
            @RequestParam Long   category_id,
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam int    price,
            @RequestParam int    cost,
            @RequestParam int    isAvailable) {

        productService.updateMenu(buildMenu(id, category_id, name, description, price, cost, isAvailable));
        return "redirect:/product/menu";
    }

    /* ===== 제품 삭제 ===== */
    @PostMapping("/productDelete")
    public String productDelete(@RequestParam Long id) {
        productService.deleteMenu(id);
        return "redirect:/product/menu";
    }

    /* ===== 카테고리 등록 ===== */
    @PostMapping("/categoryInsert")
    public String categoryInsert(@RequestParam String name) {
        CategoryDomain category = new CategoryDomain();
        category.setName(name);
        productService.insertCategory(category);
        return "redirect:/product/menu"; // 기존 /product → /product/menu 로 수정 (실제 페이지 경로)
    }

    // ── private 헬퍼 ──────────────────────────────────────────

    /** productInsert / productUpdate 공통 MenuDomain 생성 */
    private MenuDomain buildMenu(Long id, Long categoryId, String name,
                                 String description, int price, int cost, int isAvailable) {
        MenuDomain menu = new MenuDomain();
        if (id != null) menu.setId(id);
        menu.setCategoryId(categoryId);
        menu.setName(name);
        menu.setDescription(description);
        menu.setPrice(price);
        menu.setCost(cost);
        menu.setIsAvailable(isAvailable);
        return menu;
    }
}