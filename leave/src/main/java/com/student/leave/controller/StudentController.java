package com.student.leave.controller;

import com.student.leave.dao.StudentMapper;
import com.student.leave.model.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.util.UUID;

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentMapper studentMapper;

    @RequestMapping("/login-page")
    public String loginPage(HttpServletRequest request) {
        String loginInfo = request.getParameter("loginInfo");
        if (!StringUtils.isEmpty(loginInfo)) {
            request.setAttribute("loginInfo", loginInfo);
        }
        return "student/login-page";
    }

    @RequestMapping("/login-check")
    public String loginCheck(HttpServletRequest request, @RequestParam("number") String number, @RequestParam("password") String password) throws UnsupportedEncodingException {
        String retInfo = "";
        // 根据用户名获得用户信息
        Student student = studentMapper.getByNum(number);
        if (student != null && password.equals(student.getPassword())) {
            // 登录成功跳转到首页面
            request.getSession().setAttribute("student_id", student.getId());
            return "redirect:/student/main-page";
        } else {
            retInfo = "学号或密码不正确，请重新输入";
            return "redirect:/student/login-page?loginInfo=" + URLEncoder.encode(retInfo,"UTF-8");
        }
    }

    @RequestMapping("/main-page")
    public String mainPage(HttpServletRequest request) {
        String studentId = (String) request.getSession().getAttribute("student_id");
        // 获得个人信息
        Student student = studentMapper.getById(studentId);
        request.setAttribute("student", student);
        return "student/main-page";
    }

    @ResponseBody
    @RequestMapping("/logout")
    public String logout(HttpServletRequest request){
        HttpSession session = request.getSession(true);
        session.removeAttribute("student_id");
        return "SUCCESS";
    }

    @ResponseBody
    @RequestMapping("/register")
    public String register(Student student) {
        student.setId(UUID.randomUUID().toString());
        // 判断学号是否已经存在
        Student s = studentMapper.getByNum(student.getName());
        if (s != null) {
            return "学号已存在，请确认后输入";
        }
        studentMapper.insert(student);
        return "SUCCESS";
    }

    @ResponseBody
    @RequestMapping("/save-info")
    public String saveInfo(Student student) {
        studentMapper.saveInfo(student);
        return "SUCCESS";
    }



}
