package com.student.leave.dao;

import com.student.leave.model.Student;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StudentMapper {
    void insert(Student student);

    Student getByNum(String number);
}
