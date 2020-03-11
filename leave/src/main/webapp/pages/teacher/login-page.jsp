<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>教师登录页面</title>
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
                    <h3 class="text-center" style="color:#2196f3">师范大学请假系统-教师登录</h3><br>
                    <form>
                        <div class="form-group">
                            <label for="account">账号</label>
                            <input type="text" class="form-control" id="account" placeholder="请输入账号">
                        </div>
                        <div class="form-group">
                            <label for="password">密码</label>
                            <input class="form-control" type="password" placeholder="请输入密码" id="password">
                        </div>
                        <button class="btn btn-general btn-blue" type="button" onclick="login()"><i fa fa-right-arrow></i>登录</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
<input type="hidden" id="loginInfo" value="<%=loginInfo%>" />
<!--Global Javascript -->
<script src="/leave/statics/js/jquery.min.js"></script>
<script src="/leave/statics/js/tether.min.js"></script>
<script src="/leave/statics/js/popper/popper.min.js"></script>
<script src="/leave/statics/js/bootstrap.min.js"></script>
<script type="text/javascript">
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
        var account = $("#account").val();
        var password = $("#password").val();
        if (account == "" || password == "") {
            alert("账号或密码不能为空");
            return;
        }
        window.location.href = "/leave/teacher/login-check?account="
            + account + "&password=" + password;
    }
</script>
</body>

</html>
