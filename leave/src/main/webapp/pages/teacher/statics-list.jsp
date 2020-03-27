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
            <h4 class="page-title">请假统计</h4>
        </div>
        <div class="col-2 d-flex no-block align-items-center">
            <button type="button" onclick="exportData()" class="btn btn-sm btn-success">列表导出</button>
        </div>
    </div>
</div>
<div class="row">
    <table id="zero_config" class="table table-hover">
        <thead>
        <tr class="bg-info text-white">
            <th>编号</th>
            <th>学生姓名</th>
            <th>请假天数</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${staticsList}" var="arr" varStatus="status">
            <c:if test="${status.index / 2 == 0}"><tr class="table-warning"></c:if>
            <c:if test="${status.index / 2 != 0}"><tr class="table-danger"></c:if>
            <td>${status.index + 1}</td>
            <td>${arr.studentName}</td>
            <td>${arr.count}</td>
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

    function exportData() {
        window.open("/leave/teacher/export");
    }
</script>
</body>

</html>
