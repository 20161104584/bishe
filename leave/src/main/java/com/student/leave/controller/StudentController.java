package com.student.leave.controller;

import com.alibaba.fastjson.JSON;
import com.student.leave.dao.ApprovalMapper;
import com.student.leave.dao.StudentMapper;
import com.student.leave.dao.TeacherMapper;
import com.student.leave.model.Approval;
import com.student.leave.model.Student;
import com.student.leave.model.Teacher;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentMapper studentMapper;
    @Autowired
    private ApprovalMapper approvalMapper;
    @Autowired
    private TeacherMapper teacherMapper;

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

    @RequestMapping("/approval-list")
    public String approvalList(HttpServletRequest request) {
        String studentId = (String) request.getSession().getAttribute("student_id");
        // 获得个人所有的请假数据
        List<Approval> approvalList = approvalMapper.getByStudentId(studentId);
        request.setAttribute("approvalList", approvalList);
        // 获得所有的老师信息
        List<Teacher> teacherList = teacherMapper.getAllTeacher();
        request.setAttribute("teacherList", teacherList);
        return "student/approval-list";
    }

    @ResponseBody
    @RequestMapping("/save-approval")
    public String saveApproval(HttpServletRequest request, Approval approval) throws ParseException {
        int days = getDays(approval.getStartTime(), approval.getEndTime());
        approval.setDays(days+1);
        // 通过student是否有id，来判断是新增还是更新
        if (StringUtils.isEmpty(approval.getId())) {
            // 新增操作
            approval.setId(UUID.randomUUID().toString());
            String studentId = (String) request.getSession().getAttribute("student_id");
            approval.setStudentId(studentId);
            approvalMapper.insert(approval);
        } else {
            // 更新操作
            approvalMapper.updateApprovalInfo(approval);
        }
        return "SUCCESS";
    }

    @ResponseBody
    @RequestMapping("/get-approval")
    public String getApproval(HttpServletRequest request, String id) {
        Approval approval = approvalMapper.getById(id);
        return JSON.toJSONString(approval);
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

    /**
     * 得到两个日志的差值
     * @param startTime
     * @param endTime
     * @return
     * @throws ParseException
     */
    private int getDays(Date startTime, Date endTime) throws ParseException {
        long betweenDate = (endTime.getTime() - startTime.getTime())/(60*60*24*1000);
        return (int) betweenDate;
    }

}
