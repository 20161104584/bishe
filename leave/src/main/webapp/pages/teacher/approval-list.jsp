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
            <th>操作</th>
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
            <td>
                <c:if test="${arr.status == 0}">
                    <button type="button" onclick="approvalAgree('${arr.id}', ${arr.days})" class="btn btn-sm btn-info">同意</button>
                    <button type="button" onclick="approvalRefuse('${arr.id}')" class="btn btn-sm btn-danger">拒绝</button>
                </c:if>
            </td>
        </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</div>
<div class="modal fade" id="nextCheck" style="z-index: 10000;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">进行下一步审批</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="leaderId" class="col-form-label">选择院领导:</label>
                        <select class="form-control" id="leaderId">
                            <c:forEach items="${leaderList}" var="arr" varStatus="status">
                                <option value="${arr.id}">${arr.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </form>
                <input type="hidden" id="approvalId"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="nextStep()">提交</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="refuseModal" style="z-index: 10000;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="refuseModalLabel">拒绝说明</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="leaderId" class="col-form-label">拒绝理由:</label>
                        <textarea id="reason" cols="3" class="form-control"></textarea>
                    </div>
                </form>
                <input type="hidden" id="refuseApprovalId"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="refuse()">提交</button>
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

    function approvalAgree(obj, days) {
        if (days < 3) {
            // 直接审核状态改为：2-待核销
            $.ajax({
                url: "/leave/teacher/agree",
                type: "POST",
                dataType: "text",
                data: {
                    id: obj
                },
                success: function(ret) {
                    if (ret == "SUCCESS") {
                        alert("审核通过成功");
                        window.location.reload();
                    } else {
                        alert("审核通过失败");
                    }
                },
                error: function(res){
                    alert("操作失败，请重新操作！");
                }
            });
        } else {
            $("#approvalId").val(obj);
            // 打开弹出框，选择具体的院长信息
            $('#nextCheck').modal("show");
        }
    }

    function nextStep() {
        // 获得领导的id
        var leaderId = $("#leaderId").val();
        var approvalId = $("#approvalId").val();
        if (leaderId == "") {
            alert("请选择院领导");
            return;
        }
        $.ajax({
            url: "/leave/teacher/next-step",
            type: "POST",
            dataType: "text",
            data: {
                id: approvalId,
                leaderId: leaderId
            },
            success: function(ret) {
                if (ret == "SUCCESS") {
                    alert("审核通过成功");
                    window.location.reload();
                } else {
                    alert("审核通过失败");
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
    }

    function approvalRefuse(obj) {
        $("#refuseApprovalId").val(obj);
        // 打开弹出框，选择具体的院长信息
        $('#refuseModal').modal("show");
    }

    function refuse() {
        // 获得领导的id
        var reason = $("#reason").val();
        var approvalId = $("#refuseApprovalId").val();
        if (reason == "") {
            alert("请填写拒绝理由");
            return;
        }
        $.ajax({
            url: "/leave/teacher/refuse",
            type: "POST",
            dataType: "text",
            data: {
                id: approvalId,
                reason: reason
            },
            success: function(ret) {
                if (ret == "SUCCESS") {
                    alert("拒绝操作成功");
                    window.location.reload();
                } else {
                    alert("拒绝操作失败");
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
    }

</script>
</body>

</html>
