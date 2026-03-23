package com.example.demo.mapper;

import com.example.demo.Domain.RecipeDomain;
import com.example.demo.Domain.MenuDomain;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface RecipeMapper {

    MenuDomain         getMenuById(Long menuId);
    List<RecipeDomain> getRecipeByMenuId(Long menuId);
    List<RecipeDomain> getRecipeList();
    List<MenuDomain>   getMenuList();

    // ※ 반환 타입 확인 필요: 재료 목록인데 List<RecipeDomain> 이 맞는지 검토
    //   XML resultType 및 실제 쿼리 결과와 일치하는지 확인 바람
    List<RecipeDomain> getIngredientList();

    void insertRecipe(RecipeDomain domain);
    void updateRecipe(RecipeDomain domain);
    void deleteRecipe(Long id);
}