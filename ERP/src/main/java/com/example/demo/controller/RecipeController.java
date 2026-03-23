package com.example.demo.controller;

import com.example.demo.Domain.RecipeDomain;
import com.example.demo.Service.RecipeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@Controller
public class RecipeController {

    private final RecipeService recipeService;

    // @Autowired 필드 주입 → 생성자 주입으로 변경 (Spring 권장 방식)
    public RecipeController(RecipeService recipeService) {
        this.recipeService = recipeService;
    }

    /* ===== 레시피 상세 페이지 ===== */
    @GetMapping("/product/recipe/{menuId}")
    public String recipeDetail(@PathVariable Long menuId, Model model) {
        model.addAttribute("menu",           recipeService.getMenuById(menuId));
        model.addAttribute("recipeList",     recipeService.getRecipeByMenuId(menuId));
        model.addAttribute("ingredientList", recipeService.getIngredientList());
        return "Product/Recipedetail";
    }

    /* ===== 레시피 관리 페이지 ===== */
    @GetMapping("/product/recipe")
    public String recipe(Model model) {
        model.addAttribute("recipeList",     recipeService.getRecipeList());
        model.addAttribute("menuList",       recipeService.getMenuList());
        model.addAttribute("ingredientList", recipeService.getIngredientList());
        return "Product/Recipe";
    }

    /* ===== 레시피 등록 ===== */
    @PostMapping("/recipeInsert")
    public String recipeInsert(
            @RequestParam Long       menuId,
            @RequestParam Long       ingredientId,
            @RequestParam BigDecimal quantity,
            @RequestParam(required = false) String recipe) {

        recipeService.insertRecipe(buildRecipe(null, menuId, ingredientId, quantity, recipe));
        return "redirect:/product/recipe";
    }

    /* ===== 레시피 수정 ===== */
    @PostMapping("/recipeUpdate")
    public String recipeUpdate(
            @RequestParam Long       id,
            @RequestParam Long       menuId,
            @RequestParam Long       ingredientId,
            @RequestParam BigDecimal quantity,
            @RequestParam(required = false) String recipe) {

        recipeService.updateRecipe(buildRecipe(id, menuId, ingredientId, quantity, recipe));
        return "redirect:/product/recipe/" + menuId;
    }

    /* ===== 레시피 삭제 ===== */
    @PostMapping("/recipeDelete")
    public String recipeDelete(@RequestParam Long id) {
        recipeService.deleteRecipe(id);
        return "redirect:/product/recipe";
    }

    // ── private 헬퍼 ──────────────────────────────────────────

    /** recipeInsert / recipeUpdate 공통 RecipeDomain 생성 */
    private RecipeDomain buildRecipe(Long id, Long menuId, Long ingredientId,
                                     BigDecimal quantity, String recipe) {
        RecipeDomain domain = new RecipeDomain();
        if (id != null) domain.setId(id);
        domain.setMenuId(menuId);
        domain.setIngredientId(ingredientId);
        domain.setQuantity(quantity);
        domain.setRecipe(recipe);
        return domain;
    }
}