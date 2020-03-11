package com.student.leave.dao;

import com.student.leave.model.Leader;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LeaderMapper {
    List<Leader> getAllLeader();
}
