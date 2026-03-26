package com.example.demo.controller;

import com.example.demo.Service.FinanceService;
import com.example.demo.Service.IngredientsService;
import com.example.demo.Service.OrderService;
import com.example.demo.mapper.PurchasesMapper;
import com.example.demo.mapper.StockLogMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@Controller
public class RevenueController {

    private final OrderService       orderService;
    private final IngredientsService ingredientsService;
    private final FinanceService     financeService;
    private final PurchasesMapper    purchasesMapper;
    private final StockLogMapper     stockLogMapper;
    private final ServletContext     servletContext;

    // ── FastAPI 결과를 메모리에 보관 ──────────────────
    private static Map<String, Object> latestJournal   = new HashMap<>();
    private static Map<String, Object> latestStatement = new HashMap<>();
    private static Map<String, Object> latestForecast  = new HashMap<>();
    private static Map<String, Object> latestInventory = new HashMap<>();
    private static String              latestExcelPath = null;

    public RevenueController(OrderService orderService,
                             IngredientsService ingredientsService,
                             FinanceService financeService,
                             PurchasesMapper purchasesMapper,
                             StockLogMapper stockLogMapper,
                             ServletContext servletContext) {
        this.orderService       = orderService;
        this.ingredientsService = ingredientsService;
        this.financeService     = financeService;
        this.purchasesMapper    = purchasesMapper;
        this.stockLogMapper     = stockLogMapper;
        this.servletContext     = servletContext;
    }

    private String getExcelDir() throws IOException {
        String dir = servletContext.getRealPath("/") + "uploads/excel/";
        Files.createDirectories(Paths.get(dir));
        return dir;
    }

    // ============================================================
    // 페이지 라우팅
    // ============================================================
    @GetMapping("/analysis/stats")
    public String stats(@RequestParam(defaultValue = "journal") String tab, Model model) {
        model.addAttribute("tab", tab);
        return "Analysis/RevenueStats";
    }

    @GetMapping("/analysis/forecast")
    public String forecast() {
        return "Analysis/RevenueForecast";
    }

    @GetMapping("/analysis/inventory")
    public String inventoryForecast() {
        return "Analysis/RevenueInventory";
    }

    // ============================================================
    // ① REST API - Python이 가져갈 원본 데이터
    // ============================================================
    @GetMapping("/api/data/orders")
    @ResponseBody
    public Object getOrders() {
        return orderService.getOrderList();
    }

    @GetMapping("/api/data/expenses")
    @ResponseBody
    public Object getExpenses() {
        return financeService.getExpenseList();
    }

    @GetMapping("/api/data/payrolls")
    @ResponseBody
    public Object getPayrolls() {
        return financeService.getPayrollList();
    }

    @GetMapping("/api/data/purchases")
    @ResponseBody
    public Object getPurchases() {
        return purchasesMapper.findAll();
    }

    @GetMapping("/api/data/ingredients")
    @ResponseBody
    public Object getIngredients() {
        return ingredientsService.getAll();
    }

    @GetMapping("/api/data/stock_logs")
    @ResponseBody
    public Object getStockLogs() {
        return stockLogMapper.findAll();
    }

    @GetMapping("/api/data/menus")
    @ResponseBody
    public Object getMenus() {
        return orderService.getMenuList();
    }

    // ============================================================
    // ② FastAPI → Spring POST 수신 (메모리 보관)
    // ============================================================
    @PostMapping("/analysis/journal")
    @ResponseBody
    public Map<String, Object> receiveJournal(@RequestBody Map<String, Object> body) {
        latestJournal = body;
        Map<String, Object> result = new HashMap<>();
        result.put("status", "ok");
        return result;
    }

    @PostMapping("/analysis/statement")
    @ResponseBody
    public Map<String, Object> receiveStatement(@RequestBody Map<String, Object> body) {
        latestStatement = body;
        Map<String, Object> result = new HashMap<>();
        result.put("status", "ok");
        return result;
    }

    @PostMapping("/analysis/forecast/result")
    @ResponseBody
    public Map<String, Object> receiveForecast(@RequestBody Map<String, Object> body) {
        latestForecast = body;
        Map<String, Object> result = new HashMap<>();
        result.put("status", "ok");
        return result;
    }

    @PostMapping("/analysis/inventory/result")
    @ResponseBody
    public Map<String, Object> receiveInventoryForecast(@RequestBody Map<String, Object> body) {
        latestInventory = body;
        Map<String, Object> result = new HashMap<>();
        result.put("status", "ok");
        return result;
    }

    // 엑셀 파일 수신
    @PostMapping("/analysis/excel/upload")
    @ResponseBody
    public Map<String, Object> uploadExcel(@RequestParam MultipartFile file) throws IOException {
        String filename  = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        Files.write(Paths.get(getExcelDir() + filename), file.getBytes());
        latestExcelPath = "/uploads/excel/" + filename;

        Map<String, Object> result = new HashMap<>();
        result.put("status",      "uploaded");
        result.put("excelPath",   latestExcelPath);
        result.put("downloadUrl", "/analysis/excel/download");
        return result;
    }

    // ============================================================
    // ③ JSP가 조회하는 최신 결과 API
    // ============================================================
    @GetMapping("/api/revenue/journal")
    @ResponseBody
    public Map<String, Object> getLatestJournal() {
        return latestJournal;
    }

    @GetMapping("/api/revenue/statement")
    @ResponseBody
    public Map<String, Object> getLatestStatement() {
        return latestStatement;
    }

    @GetMapping("/api/revenue/forecast")
    @ResponseBody
    public Map<String, Object> getLatestForecast() {
        return latestForecast;
    }

    @GetMapping("/api/revenue/inventory")
    @ResponseBody
    public Map<String, Object> getLatestInventory() {
        return latestInventory;
    }

    // 엑셀 다운로드
    @GetMapping("/analysis/excel/download")
    public void downloadExcel(HttpServletResponse response) throws IOException {
        if (latestExcelPath == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "생성된 엑셀 파일이 없습니다.");
            return;
        }
        String filePath = servletContext.getRealPath("/")
                + latestExcelPath.replaceFirst("^/", "");
        File file = new File(filePath);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일이 존재하지 않습니다.");
            return;
        }
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" +
                java.net.URLEncoder.encode(file.getName(), "UTF-8") + "\"");
        response.setContentLengthLong(file.length());
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buf = new byte[4096];
            int len;
            while ((len = fis.read(buf)) != -1) os.write(buf, 0, len);
        }
    }
}