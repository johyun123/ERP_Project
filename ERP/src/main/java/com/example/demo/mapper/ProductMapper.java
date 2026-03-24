package com.example.demo.mapper;
 
import com.example.demo.Domain.MenuDomain;
import com.example.demo.Domain.CategoryDomain;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
 
@Mapper
public interface ProductMapper {
 
    List<MenuDomain> getMenuList();

    MenuDomain getMenuById(Long id);
    
    List<CategoryDomain> getCategoryList();
    
    List<MenuDomain> getMenuList(@Param("offset") int offset, @Param("size") int size);
    int getMenuCount();
 
    void insertMenu(MenuDomain menu);
    
    void updateMenu(MenuDomain menu);
    
    void deleteMenu(Long id);
    
    void deleteRecipeByMenuId(Long menuId);
 
    void insertCategory(CategoryDomain category);
    
    // =========================
    // ✅ 카테고리별 페이징 (추가)
    // =========================
    List<MenuDomain> getMenuListByCategory(
        @Param("categoryId") Long categoryId,
        @Param("offset") int offset,
        @Param("size") int size);
        int getMenuCountByCategory(@Param("categoryId") Long categoryId);
        
        List<MenuDomain> getMenuListByKeyword(
        	    @Param("keyword") String keyword,
        	    @Param("offset") int offset,
        	    @Param("size") int size
        	);

        	int getMenuCountByKeyword(@Param("keyword") String keyword);

}