<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>学生首页 </title>
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
                    <span>内蒙古师范大学请假系统</span>
                </div>
            </div>
            <ul class="nav-menu list-unstyled d-flex flex-md-row align-items-md-center">
                <li class="nav-item dropdown">
                    <a id="profile" class="nav-link logout" data-target="#" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <img src="/leave/head/upload/${student.avatar}" class="img-fluid rounded-circle" style="height: 30px; width: 30px;">
                    </a>
                    <ul aria-labelledby="profile" class="dropdown-menu profile">
                        <li>
                            <a rel="nofollow" class="dropdown-item">
                                <div class="notification">
                                    <div class="notification-content" onclick="openRegister()"><i class="fa fa-user "></i>个人信息</div>
                                </div>
                            </a>
                        </li>
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
            <div class="avatar"><img src="/leave/head/upload/${student.avatar}" class="img-fluid rounded-circle" style="height: 50px; width: 50px;"></div>
            <div class="title">
                <h1 class="h4">${student.name}</h1>
            </div>
        </div>
        <hr>
        <ul class="list-unstyled">
            <li> <a onclick="openUrl('/leave/student/approval-list')"> <i class="fa fa-bar-chart"></i>请假列表 </a></li>
        </ul>
    </nav>

        <iframe id="mainFrame" name="mainFrame" frameborder="no"
                scrolling="no" src="/leave/student/approval-list"></iframe>
</div>
<div class="modal fade" id="registerModal" style="z-index: 10000;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">个人信息</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="register_account" class="col-form-label">学号:</label>
                        <input type="text" class="form-control" id="register_account" disabled value="${student.num}">
                    </div>
                    <div class="form-group">
                        <label for="register_name" class="col-form-label">名称:</label>
                        <input type="text" class="form-control" id="register_name" value="${student.name}">
                    </div>
                    <div class="form-group">
                        <label for="register_password" class="col-form-label">密码:</label>
                        <input type="password" class="form-control" id="register_password" value="${student.password}">
                    </div>
                    <div class="form-group">
                        <input type="file" id="img" name="img" onchange="sendChange()">
                        <input type="submit" style="opacity:0" id="send">
                        <img id="imageShow" src="/leave/head/upload/${student.avatar}" width="40px" height="40px"/>
                        <input type="hidden" id="register_avatar" value="${student.avatar}"/>
                        <input type="hidden" id="register_id" value="${student.id}"/>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="register()">保存</button>
            </div>
        </div>
    </div>
</div>

<script src="/leave/statics/js/jquery.min.js"></script>
<script src="/leave/statics/js/popper/popper.min.js"></script>
<script src="/leave/statics/js/bootstrap.min.js"></script>
<script src="/leave/statics/js/jquery.validate.min.js"></script>
<script language="JavaScript">

    function openRegister() {
        $('#registerModal').modal("show");
    }

    function logout() {
        $.ajax({
            url: "/leave/student/logout",
            type: "POST",
            dataType: "text",
            data: {
            },
            success: function(ret) {
                if (ret == "ERROR") {
                    alert("退出失败");
                } else {
                    window.location.href = "/leave/student/login-page";
                }
            },
            error: function(res){
                alert("操作失败，请重新操作！");
            }
        });
    }

    function sendChange(){
        fileUpload();
    }

    function fileUpload() {
        var formData = new FormData();
        formData.append('file',  $('#img')[0].files[0]);
        if(!validate_img($('#img'))){
            return;
        }
        $.ajax({
            url: '/leave/head/multiUpload',
            type: 'POST',
            cache: false,
            data: formData,
            processData: false,
            contentType: false,
            success:function(data){
                if (data != "ERROR") {
                    $("#imageShow").attr("src", "/leave/head/upload/" + data);
                    $("#register_avatar").val(data);
                } else {
                    alert("上传失败");
                }
            },
            error:function(){
                alert("系统异常，请稍后再试");
            }
        });
    }
    //限制上传文件的类型和大小
    function validate_img(ele){
        // 返回 KB，保留小数点后两位
        //alert((ele.files[0].size/(1024*1024)).toFixed(2));
        var file = ele.val();
        if(!/.(gif|jpg|jpeg|png|GIF|JPG|bmp)$/.test(file)){

            alert("图片类型必须是.gif,jpeg,jpg,png,bmp中的一种");
            return false;
        }else{
            //alert((ele.files[0].size).toFixed(2));
            //返回Byte(B),保留小数点后两位
            if(((ele[0].files[0].size).toFixed(2))>=(2*1024*1024)){

                alert("请上传小于2M的图片");
                return false;
            }else  return true;
        }
        return false;
    }

    function register() {
        // 获得数据
        var id = $("#register_id").val();
        var num = $("#register_account").val();
        var name = $("#register_name").val();
        var password = $("#register_password").val();
        var avatar = $("#register_avatar").val();
        if (id == "" || num == "" || name == "" || password == "" || avatar == "") {
            alert("请全部填写");
            return;
        }
        $.ajax({
            url: "/leave/student/save-info",
            type: "POST",
            dataType: "text",
            data: {
                id: id,
                num: num,
                name: name,
                password: password,
                avatar: avatar
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

    function openUrl(url) {
        $("#mainFrame").attr("src", url);
    }
</script>
</body>

</html>
