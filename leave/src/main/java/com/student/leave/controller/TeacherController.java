package com.student.leave.controller;

import com.student.leave.dao.ApprovalMapper;
import com.student.leave.dao.LeaderMapper;
import com.student.leave.dao.StudentMapper;
import com.student.leave.dao.TeacherMapper;
import com.student.leave.dto.StaticsDTO;
import com.student.leave.model.Approval;
import com.student.leave.model.Leader;
import com.student.leave.model.Student;
import com.student.leave.model.Teacher;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/teacher")
public class TeacherController {

    @Autowired
    private StudentMapper studentMapper;
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
        request.setAttribute("approvalList", deal(approvalList));
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

    @RequestMapping("/finish-list")
    public String finishList(HttpServletRequest request) {
        String teacherId = (String) request.getSession().getAttribute("teacher_id");
        // 获得个人所有的请假数据
        List<Approval> approvalList = approvalMapper.getByTeacherFinish(teacherId);
        request.setAttribute("approvalList", approvalList);
        return "teacher/finish-list";
    }

    @ResponseBody
    @RequestMapping("/write-off-agree")
    public String writeOffAgree(String id) {
        // 核销成功
        approvalMapper.writeOffAgree(id);
        return "SUCCESS";
    }

    @ResponseBody
    @RequestMapping("/write-off-refuse")
    public String writeOffRefuse(String id, String reason) {
        approvalMapper.writeOffRefuse(id, reason);
        return "SUCCESS";
    }

    private List<Approval> deal(List<Approval> approvalList) {
        List<Approval> retList = new ArrayList<>();
        for (Approval approval : approvalList) {
            String studentId = approval.getStudentId();
            // 获得今年该学生的请假天数
            Integer count = approvalMapper.getSum(studentId);
            approval.setHadDays(count == null ? 0 : count);
            retList.add(approval);
        }
        return retList;
    }

    @RequestMapping("/statics-list")
    public String staticslList(HttpServletRequest request) {
        String teacherId = (String) request.getSession().getAttribute("teacher_id");
        // 获得该老师下所有学生的id
        request.setAttribute("staticsList", getStaticsData(teacherId));
        return "teacher/statics-list";
    }

    private List<StaticsDTO> getStaticsData(String teacherId) {
        List<StaticsDTO> staticsList = new ArrayList<>();
        List<String> studentIdList = approvalMapper.getAllStudentByTeacherId(teacherId);
        for (String studentId : studentIdList) {
            // 获得学生名称
            Student student = studentMapper.getById(studentId);
            Integer count = approvalMapper.getSum(studentId);
            StaticsDTO staticsDTO = new StaticsDTO();
            staticsDTO.setStudentName(student.getName());
            staticsDTO.setCount(count);
            staticsList.add(staticsDTO);
        }
        return staticsList;
    }

    @RequestMapping("/export")
    public void export(HttpServletRequest request, HttpServletResponse response) {
        String teacherId = (String) request.getSession().getAttribute("teacher_id");
        List<StaticsDTO> staticsList = getStaticsData(teacherId);
        try {
            exportExcel(response, staticsList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportExcel(HttpServletResponse response, List<StaticsDTO> staticsList)
            throws UnsupportedEncodingException {
        String filename= new String("请假汇总表.xls".getBytes(),"iso-8859-1");//中文文件名必须使用此句话

        response.setContentType("application/octet-stream");
        response.setContentType("application/OCTET-STREAM;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename="+filename );

        //导出列顺序和类中成员顺序一致
        try {
            OutputStream out = new BufferedOutputStream(response.getOutputStream());

            // 第一步，创建一个webbook，对应一个Excel文件
            HSSFWorkbook wb = new HSSFWorkbook();
            // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
            HSSFSheet sheet = wb.createSheet("请假汇总表");
            sheet.setColumnWidth(0, 5*256);
            sheet.setColumnWidth(1, 25*256);
            sheet.setColumnWidth(2, 10*256);
            // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
            HSSFRow row = sheet.createRow((int) 0);

            HSSFCell cell = row.createCell((short) 0);
            cell.setCellValue("编号");
            cell = row.createCell((short) 1);
            cell.setCellValue("学生名称");
            cell = row.createCell((short) 2);
            cell.setCellValue("请假天数");

            if (staticsList != null && staticsList.size() > 0) {
                // 第五步，写入实体数据 实际应用中这些数据从数据库得到，
                for (int i = 0; i < staticsList.size(); i++) {
                    row = sheet.createRow((int) i + 1);
                    StaticsDTO statistics = staticsList.get(i);
                    // 第四步，创建单元格，并设置值
                    row.createCell((short) 0).setCellValue(i+1);
                    row.createCell((short) 1).setCellValue(statistics.getStudentName());
                    row.createCell((short) 2).setCellValue(statistics.getCount());
                }
            }
            wb.write(out);
            out.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
