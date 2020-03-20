<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生首页 </title>
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
            <h4 class="page-title">请假列表</h4>
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
            <th>开始时间</th>
            <th>结束时间</th>
            <th>天数</th>
            <th>理由</th>
            <th>审核老师</th>
            <th>审核院长</th>
            <th>审核说明</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${approvalList}" var="arr" varStatus="status">
            <c:if test="${arr.days < 3}"><tr class="table-warning"></c:if>
            <c:if test="${arr.days >= 3}"><tr class="table-danger"></c:if>
            <td>${status.index + 1}</td>
            <td><fmt:formatDate value="${arr.startTime}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${arr.endTime}" pattern="yyyy-MM-dd"/></td>
            <td>${arr.days}</td>
            <td>${arr.reason}</td>
            <td>${arr.teacherName}</td>
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
            <td>
                <c:if test="${arr.status == 0}"><button type="button" onclick="editApproval('${arr.id}')" class="btn btn-sm btn-info">编辑</button></c:if>
                <c:if test="${arr.status == 2 || arr.status == -3}"><button type="button" onclick="writeOff('${arr.id}')" class="btn btn-sm btn-danger">核销</button></c:if>
            </td>
        </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</div>
<div class="modal fade" id="addApproval" style="z-index: 10000;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">请假申请</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="startTime" class="col-form-label">开始时间:</label>
                        <input type="text" class="form-control" id="startTime" placeholder="日期格式如：2019/01/22">
                    </div>
                    <div class="form-group">
                        <label for="endTime" class="col-form-label">结束时间:</label>
                        <input type="text" class="form-control" id="endTime" placeholder="日期格式如：2019/01/22">
                    </div>
                    <div class="form-group">
                        <label for="reason" class="col-form-label">理由:</label>
                        <input type="text" class="form-control" id="reason" placeholder="输入请假理由">
                    </div>
                    <div class="form-group">
                        <label for="teacherId" class="col-form-label">选择老师:</label>
                        <select class="form-control" id="teacherId">
                            <c:forEach items="${teacherList}" var="arr" varStatus="status">
                                <option value="${arr.id}">${arr.name}</option>
                            </c:forEach>
                        </select>
                        <input type="text" class="form-control" id="teacherInputName" disabled>
                    </div>
                    <input type="hidden" id="approvalId"/>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="save()">保存</button>
            </div>
        </div>
    </div>
</div>

<script src="/leave/statics/js/jquery.min.js"></script>
<script src="/leave/statics/js/popper/popper.min.js"></script>
<script src="/leave/statics/js/bootstrap.min.js"></script>
<script src="/leave/statics/js/datatables/js/datatables.js"></script>
<script src="/leave/statics/js/jquery.validate.min.js"></script>
<script language="JavaScript">
    $('#zero_config').DataTable({ordering:false});

    function addApproval() {
        $("#approvalId").val("");
        $("#startTime").val("");
        $("#endTime").val("");
        $("#reason").val("");
        $("#teacherId").val("");
        $("#teacherInputName").hide();
        $('#addApproval').modal("show");
    }

    function editApproval(obj) {
        // 获得该条请假信息
        $.ajax({
            url: "/leave/student/get-approval",
            type: "POST",
            dataType: "text",
            data: {
                id: obj
            },
            success: function(ret) {
                if (ret == "ERROR") {
                    alert("获得数据失败");
                } else {
                    var data = JSON.parse(ret);
                    $("#approvalId").val(data.id);
                    $("#startTime").val(getyyyyMMdd(data.startTime));
                    $("#endTime").val(getyyyyMMdd(data.endTime));
                    $("#reason").val(data.reason);
                    $("#teacherId").hide();
                    $("#teacherInputName").val(data.teacherName);
                    $('#addApproval').modal("show");
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
        $('#addApproval').modal("show");
    }

    function save() {
        // 获得数据
        var id = $("#approvalId").val();
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        var reason = $("#reason").val();
        var teacherId = $("#teacherId").val();
        if (startTime == "" || endTime == "" || reason == "" || teacherId == "") {
            alert("请全部填写");
            return;
        }
        $.ajax({
            url: "/leave/student/save-approval",
            type: "POST",
            dataType: "text",
            data: {
                id: id,
                startTime: new Date(startTime),
                endTime: new Date(endTime),
                reason: reason,
                teacherId: teacherId,
            },
            success: function(ret) {
                if (ret == "SUCCESS") {
                    alert("保存成功");
                    window.location.reload();
                } else {
                    alert(ret);
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
    }

    function writeOff(obj) {
        $.ajax({
            url: "/leave/student/write-off",
            type: "POST",
            dataType: "text",
            data: {
                id: obj
            },
            success: function(ret) {
                if (ret == "SUCCESS") {
                    alert("核销申请成功");
                    window.location.reload();
                } else {
                    alert(ret);
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
    }

    function getyyyyMMdd(date){
        var d = new Date(date);
        var curr_date = d.getDate();
        var curr_month = d.getMonth() + 1;
        var curr_year = d.getFullYear();
        String(curr_month).length < 2 ? (curr_month = "0" + curr_month): curr_month;
        String(curr_date).length < 2 ? (curr_date = "0" + curr_date): curr_date;
        var yyyyMMdd = curr_year + "/" + curr_month +"/"+ curr_date;
        return yyyyMMdd;
    }
</script>
</body>

</html>
