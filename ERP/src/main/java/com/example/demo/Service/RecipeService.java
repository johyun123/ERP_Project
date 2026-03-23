package com.example.demo.Service;

import com.example.demo.Domain.RecipeDomain;
import com.example.demo.Domain.MenuDomain;
import com.example.demo.mapper.RecipeMapper;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class RecipeService {

    private final RecipeMapper recipeMapper;

    // @Autowired 필드 주입 → 생성자 주입으로 변경
    public RecipeService(RecipeMapper recipeMapper) {
        this.recipeMapper = recipeMapper;
    }

    public List<RecipeDomain> getRecipeList()              { return recipeMapper.getRecipeList(); }
    public List<MenuDomain>   getMenuList()                { return recipeMapper.getMenuList(); }
    public List<RecipeDomain> getIngredientList()          { return recipeMapper.getIngredientList(); }
    public MenuDomain         getMenuById(Long menuId)     { return recipeMapper.getMenuById(menuId); }
    public List<RecipeDomain> getRecipeByMenuId(Long menuId) { return recipeMapper.getRecipeByMenuId(menuId); }

    public void insertRecipe(RecipeDomain domain) { recipeMapper.insertRecipe(domain); }
    public void updateRecipe(RecipeDomain domain) { recipeMapper.updateRecipe(domain); }
    public void deleteRecipe(Long id)             { recipeMapper.deleteRecipe(id); }
}