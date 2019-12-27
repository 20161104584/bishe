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
    public String mainPage() {
        return "student/main-page";
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
    @RequestMapping(value="/multiUpload", method= RequestMethod.POST)
    public String multiUpload(@RequestParam(value = "file") MultipartFile file) {
        if (file.isEmpty()) {
            System.out.println("文件为空空");
        }
        String fileName = file.getOriginalFilename();  // 文件名
        String suffixName = fileName.substring(fileName.lastIndexOf("."));  // 后缀名
        String filePath = "D://images//"; // 上传后的路径
        fileName = UUID.randomUUID() + suffixName; // 新文件名
        File dest = new File(filePath + fileName);
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            file.transferTo(dest);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return fileName;
    }

    @RequestMapping(value = "/upload/{fileName}")
    public void downloadFile(@PathVariable("fileName") String fileName, HttpServletResponse res) {
        try {
            //设置响应头
            res.setContentType("application/force-download");// 设置强制下载不打开
            res.addHeader("Content-Disposition", "attachment;fileName=" +
                    new String(fileName.getBytes("gbk"), "iso8859-1"));// 设置文件名
            res.setHeader("Context-Type", "application/xmsdownload");

            //判断文件是否存在
            File file = new File("D://images/" + fileName);
            if (file.exists()) {
                byte[] buffer = new byte[1024];
                FileInputStream fis = null;
                BufferedInputStream bis = null;
                try {
                    fis = new FileInputStream(file);
                    bis = new BufferedInputStream(fis);
                    OutputStream os = res.getOutputStream();
                    int i = bis.read(buffer);
                    while (i != -1) {
                        os.write(buffer, 0, i);
                        i = bis.read(buffer);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (bis != null) {
                        try {
                            bis.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    if (fis != null) {
                        try {
                            fis.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
