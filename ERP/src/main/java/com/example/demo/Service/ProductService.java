package com.example.demo.Service;

import com.example.demo.Domain.MenuDomain;
import com.example.demo.Domain.CategoryDomain;
import com.example.demo.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class ProductService {

    private final ProductMapper productMapper;

    // @Autowired 필드 주입 → 생성자 주입으로 변경
    public ProductService(ProductMapper productMapper) {
        this.productMapper = productMapper;
    }

    public List<MenuDomain> getMenuList() {
        return productMapper.getMenuList();
    }

    public MenuDomain getMenuById(Long id) {
        return productMapper.getMenuById(id);
    }

    public List<CategoryDomain> getCategoryList() {
        return productMapper.getCategoryList();
    }

    public void insertMenu(MenuDomain menu) {
        productMapper.insertMenu(menu);
    }

    public void updateMenu(MenuDomain menu) {
        productMapper.updateMenu(menu);
    }

    // @Transactional 추가 — recipes 삭제 후 menus 삭제 실패 시 롤백 보장
    @Transactional
    public void deleteMenu(Long id) {
        productMapper.deleteRecipeByMenuId(id); // recipes 먼저 삭제 (FK)
        productMapper.deleteMenu(id);           // menus 삭제
    }

    public void insertCategory(CategoryDomain category) {
        productMapper.insertCategory(category);
    }
}