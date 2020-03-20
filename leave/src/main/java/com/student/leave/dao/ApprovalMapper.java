package com.student.leave.dao;

import com.student.leave.model.Approval;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ApprovalMapper {
    List<Approval> getByStudentId(String studentId);

    void insert(Approval approval);

    void updateApprovalInfo(Approval approval);

    Approval getById(String id);

    void writeOf(String id);

    List<Approval> getByTeacherCheck(String teacherId);

    void teacherAgree(String id);

    void teacherNextStep(@Param("id") String id, @Param("leaderId") String leaderId);

    void teacherRefuse(@Param("id") String id, @Param("reason") String reason);

    List<Approval> getByTeacherFinish(String teacherId);

    void writeOffAgree(String id);

    void writeOffRefuse(@Param("id") String id, @Param("reason") String reason);
}
