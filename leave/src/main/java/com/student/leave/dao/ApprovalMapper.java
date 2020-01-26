package com.student.leave.dao;

import com.student.leave.model.Approval;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ApprovalMapper {
    List<Approval> getByStudentId(String studentId);
}
