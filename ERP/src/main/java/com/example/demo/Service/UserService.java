package com.example.demo.Service;

import java.util.List;

import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.Domain.Employees;
import com.example.demo.Domain.User;
import com.example.demo.mapper.UserMapper;

@Service
public class UserService {

    private final UserMapper      userMapper;
    private final PasswordEncoder passwordEncoder;
    private final HRMService      hrmService;

    public UserService(UserMapper userMapper, PasswordEncoder passwordEncoder, HRMService hrmService) {
        this.userMapper      = userMapper;
        this.passwordEncoder = passwordEncoder;
        this.hrmService      = hrmService;
    }

    // ── 조회 ──────────────────────────────────────────

    // 전체 사용자 조회
    public List<User> getAllUsers() {
        return userMapper.findAll();
    }

    // emp_num 기준 사용자 조회
    public User getUserById(String emp_num) {
        Employees emp = hrmService.getEmployeeById(emp_num);
        if (emp == null) return null;
        return userMapper.findById(emp.getId());
    }

    // ── 인증 ──────────────────────────────────────────

    // 로그인 검증 (payroll/auth, users/auth 에서 사용)
    public boolean login(String empNumOrUserId, String rawPassword) {
        User user = resolveUser(empNumOrUserId);
        if (user == null || user.getIs_active() != 1) return false;
        return BCrypt.checkpw(rawPassword, user.getUser_pw());
    }

    // login의 별칭 — HRMController, FinanceController에서 authenticate로 호출
    public boolean authenticate(String userId, String rawPw) {
        return login(userId, rawPw);
    }

    // 로그인 후 User 객체 반환
    public User loginAndGetUser(String empNumOrUserId, String rawPassword) {
        User user = resolveUser(empNumOrUserId);
        if (user == null) return null;
        if (user.getIs_active() != 1) throw new RuntimeException("비활성화된 계정입니다.");
        return BCrypt.checkpw(rawPassword, user.getUser_pw()) ? user : null;
    }

    // ── 계정 관리 ──────────────────────────────────────

    // 활성/비활성 토글
    public void toggleUserActive(Long id) {
        User user = userMapper.findById(id);
        if (user != null) {
            userMapper.updateUserActive(id, user.getIs_active() == 1 ? 0 : 1);
        }
    }

    // ERP 계정 등록
    public void registerByEmployee(String emp_num, String user_pw) {
        Employees emp = requireEmployee(emp_num);
        if (userMapper.findById(emp.getId()) != null) {
            throw new RuntimeException("이미 계정이 존재하는 직원입니다.");
        }
        User user = new User();
        user.setId(emp.getId());
        user.setUser_pw(passwordEncoder.encode(user_pw));
        user.setIs_active(1);
        userMapper.save(user);
    }

    // 비밀번호 변경
    public void changePassword(String emp_num, String new_pw) {
        Employees emp = requireEmployee(emp_num);
        if (userMapper.findById(emp.getId()) == null) {
            throw new RuntimeException("계정이 존재하지 않는 직원입니다.");
        }
        userMapper.updatePassword(emp.getId(), passwordEncoder.encode(new_pw));
    }

    // ERP 계정만 삭제 (employees는 유지)
    public void deleteUserAccount(String emp_num) {
        userMapper.deleteById(requireEmployee(emp_num).getId());
    }

    // 중복 체크
    public boolean existsByUserId(String emp_num) {
        Employees emp = hrmService.getEmployeeById(emp_num);
        if (emp == null) return false;
        return userMapper.findById(emp.getId()) != null;
    }

    // ── private 헬퍼 ──────────────────────────────────

    /**
     * emp_num으로 직원 조회 후 없으면 emp_num 자체로 user 조회
     * login / loginAndGetUser 공통 로직
     */
    private User resolveUser(String empNumOrUserId) {
        Employees emp = hrmService.getEmployeeById(empNumOrUserId);
        if (emp != null) return userMapper.findById(emp.getId());
        return userMapper.findByEmpNum(empNumOrUserId);
    }

    /** 직원 조회 후 없으면 예외 — 계정 관리 메서드 공통 */
    private Employees requireEmployee(String emp_num) {
        Employees emp = hrmService.getEmployeeById(emp_num);
        if (emp == null) throw new RuntimeException("존재하지 않는 직원입니다.");
        return emp;
    }
}