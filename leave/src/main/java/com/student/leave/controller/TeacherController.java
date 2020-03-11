package com.student.leave.controller;

import com.student.leave.dao.TeacherMapper;
import com.student.leave.model.Teacher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@Controller
@RequestMapping("/teacher")
public class TeacherController {

    @Autowired
    private TeacherMapper teacherMapper;

    @RequestMapping("/login-page")
    public String loginPage(HttpServletRequest request) {
        String loginInfo = request.getParameter("loginInfo");
        if (!StringUtils.isEmpty(loginInfo)) {
            request.setAttribute("loginInfo", loginInfo);
        }
        return "teacher/login-page";
    }

    @RequestMapping("/login-check")
    public String loginCheck(HttpServletRequest request, @RequestParam("account") String account, @RequestParam("password") String password) throws UnsupportedEncodingException {
        String retInfo = "";
        // 根据用户名获得用户信息
        Teacher teacher = teacherMapper.getByAccount(account);
        if (teacher != null && password.equals(teacher.getPassword())) {
            // 登录成功跳转到首页面
            request.getSession().setAttribute("teacher_id", teacher.getId());
            return "redirect:/teacher/main-page";
        } else {
            retInfo = "账号或密码不正确，请重新输入";
            return "redirect:/teacher/login-page?loginInfo=" + URLEncoder.encode(retInfo,"UTF-8");
        }
    }

    @RequestMapping("/main-page")
    public String mainPage(HttpServletRequest request) {
        String teacherId = (String) request.getSession().getAttribute("teacher_id");
        // 获得个人信息
        Teacher teacher = teacherMapper.getById(teacherId);
        request.setAttribute("teacher", teacher);
        return "teacher/main-page";
    }

    @ResponseBody
    @RequestMapping("/logout")
    public String logout(HttpServletRequest request){
        HttpSession session = request.getSession(true);
        session.removeAttribute("teacher_id");
        return "SUCCESS";
    }

}
