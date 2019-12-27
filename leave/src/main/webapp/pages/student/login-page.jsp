<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>学生登录页面</title>
    <link rel="stylesheet" href="/leave/statics/css/bootstrap.min.css">
    <link rel="stylesheet" href="/leave/statics/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="/leave/statics/css/font-icon-style.css">
    <link rel="stylesheet" href="/leave/statics/css/style.default.css" id="theme-stylesheet">
    <link rel="stylesheet" href="/leave/statics/css/pages/login.css">
</head>

<body>
<%
    String loginInfo = (String) request.getAttribute("loginInfo");
    if (loginInfo == null) {
        loginInfo = "";
    }
%>
<section class="hero-area">
    <div class="overlay"></div>
    <div class="container">
        <div class="row">
            <div class="col-md-12 ">
                <div class="contact-h-cont">
                    <h3 class="text-center" style="color:#2196f3">师范大学请假系统-学生登录</h3><br>
                    <form>
                        <div class="form-group">
                            <label for="number">Number</label>
                            <input type="text" class="form-control" id="number" placeholder="Enter Number">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input class="form-control" type="password" placeholder="Enter Password" id="password">
                        </div>
                        <div class="form-group" style="float:right">
                            <a style="font-size:12px;color:#2196f3;" onclick="openRegister()">Register</a>
                        </div>
                        <button class="btn btn-general btn-blue" type="button" onclick="login()"><i fa fa-right-arrow></i>Login</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
<input type="hidden" id="loginInfo" value="<%=loginInfo%>" />
<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">学生注册</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="register_account" class="col-form-label">学号:</label>
                        <input type="text" class="form-control" id="register_account">
                    </div>
                    <div class="form-group">
                        <label for="register_name" class="col-form-label">名称:</label>
                        <input type="text" class="form-control" id="register_name">
                    </div>
                    <div class="form-group">
                        <label for="register_password" class="col-form-label">密码:</label>
                        <input type="text" class="form-control" id="register_password">
                    </div>
                    <div class="form-group">
                        <input type="file" id="img" name="img" onchange="sendChange()">
                        <input type="submit" style="opacity:0" id="send">
                        <img id="imageShow" src="/leave/student/upload/1.png" width="40px" height="40px"/>
                        <input type="hidden" id="register_avatar" value="1.png"/>
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
<!--Global Javascript -->
<script src="/leave/statics/js/jquery.min.js"></script>
<script src="/leave/statics/js/tether.min.js"></script>
<script src="/leave/statics/js/popper/popper.min.js"></script>
<script src="/leave/statics/js/bootstrap.min.js"></script>
<script type="text/javascript">
    function openRegister() {
        $('#registerModal').modal("show");
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
            url: '/leave/student/multiUpload',
            type: 'POST',
            cache: false,
            data: formData,
            processData: false,
            contentType: false,
            success:function(data){
                if (data != "ERROR") {
                    $("#imageShow").attr("src", "/leave/student/upload/" + data);
                    $("#avatar").val(data);
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
        var num = $("#register_account").val();
        var name = $("#register_name").val();
        var password = $("#register_password").val();
        var avatar = $("#register_avatar").val();
        if (num == "" || name == "" || password == "" || avatar == "") {
            alert("请全部填写");
            return;
        }
        $.ajax({
            url: "/leave/student/register",
            type: "POST",
            dataType: "text",
            data: {
                num: num,
                name: name,
                password: password,
                avatar: avatar
            },
            success: function(ret) {
                if (ret == "SUCCESS") {
                    alert("注册成功");
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

    // 判断是否需要在登陆页面给提示
    $(document).ready(function() {
        var loginInfo = $("#loginInfo").val();
        if (loginInfo != undefined && loginInfo != "") {
            alert(loginInfo);
            $("#loginInfo").val("");
        }
    });
    // 登陆校验
    function login() {
        var number = $("#number").val();
        var password = $("#password").val();
        if (number == "" || password == "") {
            alert("学号或密码不能为空");
            return;
        }
        window.location.href = "/leave/student/login-check?number="
            + number + "&password=" + password;
    }
</script>
</body>

</html>
