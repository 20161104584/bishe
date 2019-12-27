package com.student.leave.filter;

import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Component
public class LeaveFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        String path = req.getContextPath();
        String basePath = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + path;
        HttpSession session = req.getSession(true);
        String url = req.getRequestURL().toString();
        
        if (url.indexOf("/student/") > -1) {
            // 进入管理员请求：稍后编写处理方式
            if(url.indexOf("/student/login-") > -1 || url.indexOf("/student/register") > -1) {
                // 登录的话，不进行拦截
                filterChain.doFilter(req, resp);
            } else {
                String studentId = (String) session.getAttribute("student_id");
                if (StringUtils.isEmpty(studentId)) {
                    resp.setHeader("Cache-Control", "no-store");
                    resp.setDateHeader("Expires", 0);
                    resp.setHeader("Prama", "no-cache");
                    resp.sendRedirect(basePath + "/student/login-page");
                } else {
                    filterChain.doFilter(req, resp);
                }
            }
        } else if (url.indexOf("/teacher/") > -1) {
            // 进入老师请求
            if(url.indexOf("/teacher/login-") > -1) {
                // 登录的话，不进行拦截
                filterChain.doFilter(req, resp);
            } else {
                String teacherId = (String) session.getAttribute("teacher_id");
                if (StringUtils.isEmpty(teacherId)) {
                    resp.setHeader("Cache-Control", "no-store");
                    resp.setDateHeader("Expires", 0);
                    resp.setHeader("Prama", "no-cache");
                    resp.sendRedirect(basePath + "/teacher/login-page");
                } else {
                    filterChain.doFilter(req, resp);
                }
            }
        } else if (url.indexOf("/leader/") > -1) {
            // 进入领导请求
            if(url.indexOf("/leader/login-") > -1) {
                // 登录的话，不进行拦截
                filterChain.doFilter(req, resp);
            } else {
                String leaderId = (String) session.getAttribute("leader_id");
                if (StringUtils.isEmpty(leaderId)) {
                    resp.setHeader("Cache-Control", "no-store");
                    resp.setDateHeader("Expires", 0);
                    resp.setHeader("Prama", "no-cache");
                    resp.sendRedirect(basePath + "/leader/login-page");
                } else {
                    filterChain.doFilter(req, resp);
                }
            }
        } else {
            filterChain.doFilter(req, resp);
        }
    }

    @Override
    public void destroy() {
    }
}
