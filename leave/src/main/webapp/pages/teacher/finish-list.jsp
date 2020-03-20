<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>教师首页</title>
    <link rel="stylesheet" href="/leave/statics/js/datatables/css/dataTables.bootstrap4.css">
    <link rel="stylesheet" href="/leave/statics/css/bootstrap.min.css">
    <link rel="stylesheet" href="/leave/statics/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="/leave/statics/css/font-icon-style.css">
    <link rel="stylesheet" href="/leave/statics/css/style.default.css" id="theme-stylesheet">
    <link rel="stylesheet" href="/leave/statics/css/style.css">

</head>

<body>
<div class="content-inner">
<div style="width:100%;height:50px;">
    <div class="row">
        <div class="col-10 d-flex no-block align-items-center">
            <h4 class="page-title">请假审核</h4>
        </div>
        <div class="col-2 d-flex no-block align-items-center">
            <button type="button" onclick="addApproval()" class="btn btn-sm btn-success">请假申请</button>
        </div>
    </div>
</div>
<div class="row">
    <table id="zero_config" class="table table-hover">
        <thead>
        <tr class="bg-info text-white">
            <th>编号</th>
            <th>学号</th>
            <th>学生</th>
            <th>开始时间</th>
            <th>天数</th>
            <th>理由</th>
            <th>审核院长</th>
            <th>审核说明</th>
            <th>状态</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${approvalList}" var="arr" varStatus="status">
            <c:if test="${arr.days < 3}"><tr class="table-warning"></c:if>
            <c:if test="${arr.days >= 3}"><tr class="table-danger"></c:if>
            <td>${status.index + 1}</td>
            <td>${arr.studentNumber}</td>
            <td>${arr.studentName}</td>
            <td><fmt:formatDate value="${arr.startTime}" pattern="yyyy-MM-dd"/></td>
            <td>${arr.days}</td>
            <td>${arr.reason}</td>
            <td>${arr.leaderName}</td>
            <td>${arr.result}</td>
            <td>
                <c:if test="${arr.status == -4}">违规</c:if>
                <c:if test="${arr.status == -3}">核销审批失败</c:if>
                <c:if test="${arr.status == -2}">院长审核未通过</c:if>
                <c:if test="${arr.status == -1}">老师审核未通过</c:if>
                <c:if test="${arr.status == 0}">待老师审批</c:if>
                <c:if test="${arr.status == 1}">待院长审批</c:if>
                <c:if test="${arr.status == 2}">待核销</c:if>
                <c:if test="${arr.status == 3}">待老师核销确认</c:if>
                <c:if test="${arr.status == 4}">已完成</c:if>
            </td>
        </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</div>

<script src="/leave/statics/js/jquery.min.js"></script>
<script src="/leave/statics/js/popper/popper.min.js"></script>
<script src="/leave/statics/js/bootstrap.min.js"></script>
<script src="/leave/statics/js/datatables/js/datatables.js"></script>
<script src="/leave/statics/js/jquery.validate.min.js"></script>
<script language="JavaScript">
    $('#zero_config').DataTable({ordering:false});
</script>
</body>

</html>
