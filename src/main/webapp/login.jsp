
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!doctype html>
<html>
<%
	if (session != null) {
		Object user = session.getAttribute("user");
		if (user != null) {
			session.invalidate();
		}
	}

	String msg = (String) request.getParameter("reason");
	String prompt = "";
	String promptDisplay = "display:none";
	if ("clientUser".equalsIgnoreCase(msg)) {
		prompt = "客户端用户，不能登录云端！";
		promptDisplay = "";
	} else if ("NotFound".equalsIgnoreCase(msg)) {
		prompt = "无此用户！";
		promptDisplay = "";
	} else if ("ErrorPass".equalsIgnoreCase(msg)) {
		prompt = "密码不正确！";
		promptDisplay = "";
	} else if ("Expired".equalsIgnoreCase(msg)) {
		prompt = "非法用户！";
		promptDisplay = "";
	}

	String ctx = request.getContextPath();
%>

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title>凤凰书城-登陆</title>
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/login.css" />
<script src="<%=ctx%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>

</head>

<body>
	<div class="login_main">
		<div class="login">
			<div class="logo">
				<img src="<%=ctx%>/image/logo.png">
			</div>
			<form id="loginFrm" name="loginFrm"
				action="<%=ctx%>/system/login.do" method="POST">
				<div id="prompt" class="line" style="<%=promptDisplay%>">
					<font color="red"><%=prompt%></font>
				</div>
				<div class="line">
					<a href="javascript:void(0)"><img
						src="<%=ctx%>/image/login_icon.jpg" class="icon"><input
						type="text" id="username" name="staff.code" class="line_txt"
						placeholder="账号/邮箱"></a>
				</div>
				<div class="line">
					<a href="javascript:void(0)"><img
						src="<%=ctx%>/image/login_icon1.jpg" class="icon"> <input
						type="password" id="password" name="staff.password"
						class="line_txt" placeholder="密码"></a><span><a href="#">忘记密码</a></span>
				</div>
				<div class="line margin_top_20">
					<img src="<%=ctx%>/image/login_btn.jpg" onclick="login();">&nbsp;&nbsp;<img
						src="<%=ctx%>/image/exit_btn.jpg" onclick="self.close();">
				</div>
				<div class="line margin_top_20">
					<span
						style="width: 120px; height: 40px; display: inline; margin-left: 88px;"><a
						style="width: 120px; font-size: 18px; font-weight: bold;" href="<%=ctx%>/register.jsp">教师用户注册</a></span>
				</div>
			</form>
			<div class="line_tips">
				江苏凤凰数字传媒有限公司 荣誉出品<br> 江苏凤凰数字传媒有限公司 研发
			</div>

		</div>
	</div>
</body>

<script type="text/javascript">
	function check() {
		var username = document.getElementById("username").value;
		if (username == "") {
			alert("登陆名不能为空！");
			return false;
		}
		var password = document.getElementById("password").value;
		if (password == "") {
			alert("密码不能为空！");
			return false;
		}

		return true;
	}
	function login() {
		if (!check()) {
			return;
		}
		jQuery("#loginFrm").submit();
	}

	jQuery(document).ready(function() {
		document.getElementById("username").value = "";
		document.getElementById("password").value = "";
	});
</script>
</html>
