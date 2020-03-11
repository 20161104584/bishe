package com.student.leave.controller;

import com.student.leave.dao.ApprovalMapper;
import com.student.leave.dao.LeaderMapper;
import com.student.leave.dao.TeacherMapper;
import com.student.leave.model.Approval;
import com.student.leave.model.Leader;
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
import java.util.List;

@Controller
@RequestMapping("/teacher")
public class TeacherController {

    @Autowired
    private TeacherMapper teacherMapper;
    @Autowired
    private ApprovalMapper approvalMapper;
    @Autowired
    private LeaderMapper leaderMapper;

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

    @RequestMapping("/approval-list")
    public String approvalList(HttpServletRequest request) {
        String teacherId = (String) request.getSession().getAttribute("teacher_id");
        // 获得个人所有的请假数据
        List<Approval> approvalList = approvalMapper.getByTeacherCheck(teacherId);
        request.setAttribute("approvalList", approvalList);
        // 获得所有的老师信息
        List<Leader> leaderList = leaderMapper.getAllLeader();
        request.setAttribute("leaderList", leaderList);
        return "teacher/approval-list";
    }

    @ResponseBody
    @RequestMapping("/agree")
    public String agree(String id) {
        approvalMapper.teacherAgree(id);
        return "SUCCESS";
    }

    @ResponseBody
    @RequestMapping("/next-step")
    public String nextStep(String id, String leaderId) {
        approvalMapper.teacherNextStep(id, leaderId);
        return "SUCCESS";
    }

    @ResponseBody
    @RequestMapping("/refuse")
    public String refuse(String id, String reason) {
        approvalMapper.teacherRefuse(id, reason);
        return "SUCCESS";
    }

}
