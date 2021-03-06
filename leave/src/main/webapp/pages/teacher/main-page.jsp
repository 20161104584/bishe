<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>教师首页</title>
    <link rel="stylesheet" href="/leave/statics/css/bootstrap.min.css">
    <link rel="stylesheet" href="/leave/statics/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="/leave/statics/css/font-icon-style.css">
    <link rel="stylesheet" href="/leave/statics/css/style.default.css" id="theme-stylesheet">

    <link rel="stylesheet" href="/leave/statics/css/ui-elements/card.css">
    <link rel="stylesheet" href="/leave/statics/css/style.css">
    <style type="text/css">
        #mainFrame {
            border:0;
            width:100%;
            height:800px;
        }
    </style>
</head>

<body>
<header class="header">
    <nav class="navbar navbar-expand-lg ">
        <div class="container-fluid ">
            <div class="navbar-holder d-flex align-items-center justify-content-between">
                <div class="navbar-header">
                    <h5>内蒙古师范大学请假系统</h5>
                </div>
            </div>
            <ul class="nav-menu list-unstyled d-flex flex-md-row align-items-md-center">
                <li class="nav-item dropdown">
                    <a id="profile" class="nav-link logout" data-target="#" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <img src="/leave/head/upload/avatar-3.jpg" class="img-fluid rounded-circle" style="height: 30px; width: 30px;">
                    </a>
                    <ul aria-labelledby="profile" class="dropdown-menu profile">
                        <li>
                            <a rel="nofollow" class="dropdown-item">
                                <div class="notification">
                                    <div class="notification-content" onclick="logout()"><i class="fa fa-power-off"></i>退出</div>
                                </div>
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>

<div class="page-content d-flex align-items-stretch">
    <nav class="side-navbar">
        <div class="sidebar-header d-flex align-items-center">
            <div class="avatar"><img src="/leave/head/upload/avatar-3.jpg" class="img-fluid rounded-circle" style="height: 50px; width: 50px;"></div>
            <div class="title">
                <h6>${teacher.name}教师</h6>
            </div>
        </div>
        <hr>
        <ul class="list-unstyled">
            <li> <a onclick="openUrl('/leave/teacher/approval-list')"> <i class="fa fa-bar-chart"></i>请假审批 </a></li>
            <li> <a onclick="openUrl('/leave/teacher/finish-list')"> <i class="fa fa-map-o"></i>已审批 </a></li>
            <li> <a onclick="openUrl('/leave/teacher/statics-list')"> <i class="fa fa-file-o"></i>请假统计 </a></li>
        </ul>
    </nav>

        <iframe id="mainFrame" name="mainFrame" frameborder="no"
                scrolling="no" src="/leave/teacher/approval-list"></iframe>
</div>

<script src="/leave/statics/js/jquery.min.js"></script>
<script src="/leave/statics/js/popper/popper.min.js"></script>
<script src="/leave/statics/js/bootstrap.min.js"></script>
<script src="/leave/statics/js/jquery.validate.min.js"></script>
<script language="JavaScript">

    function logout() {
        $.ajax({
            url: "/leave/teacher/logout",
            type: "POST",
            dataType: "text",
            data: {
            },
            success: function(ret) {
                if (ret == "ERROR") {
                    alert("退出失败");
                } else {
                    window.location.href = "/leave/teacher/login-page";
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
    }

    function openUrl(url) {
        $("#mainFrame").attr("src", url);
    }
</script>
</body>

</html>
