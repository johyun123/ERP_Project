package com.example.demo.mapper;
 
import com.example.demo.Domain.MenuDomain;
import com.example.demo.Domain.CategoryDomain;
import org.apache.ibatis.annotations.Mapper;
 
import java.util.List;
 
@Mapper
public interface ProductMapper {
 
    List<MenuDomain> getMenuList();

    MenuDomain getMenuById(Long id);
    
    List<CategoryDomain> getCategoryList();
 
    void insertMenu(MenuDomain menu);
    
    void updateMenu(MenuDomain menu);
    
    void deleteMenu(Long id);
    
    void deleteRecipeByMenuId(Long menuId);
 
    void insertCategory(CategoryDomain category);
}