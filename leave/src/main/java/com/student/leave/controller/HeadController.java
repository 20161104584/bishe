package com.student.leave.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/head")
public class HeadController {

    @RequestMapping("/page")
    public String page() {
        return "head";
    }

}
