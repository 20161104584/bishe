package com.student.leave.dao;

import com.student.leave.model.Teacher;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TeacherMapper {
    List<Teacher> getAllTeacher();
}
