<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<%
	String ctx = (String) request.getContextPath();
	String msg = (String)request.getAttribute("msg");
%>
<head>
<title>凤凰云端管理 </title>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.login.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script>
	function init() {
		document.getElementById('registerBox').style.display = "none";
		document.getElementById('loginbox').style.display = "";

	}

	function register() {
		document.getElementById('registerBox').style.display = "";
		document.getElementById('loginbox').style.display = "none";
	}

	function login() {
		document.getElementById('registerBox').style.display = "none";
		document.getElementById('loginbox').style.display = "";
	}

	function check() {

		var username = document.getElementById("username").value;
		if (username == "") {
			alert("username is null!");
			return false;
		}
		var password = document.getElementById("password").value;
		if (password == "") {
			alert("password is null!");
			return false;
		}

		return true;
	}
	
	function setInfo(obj){
		var url="<%=ctx%>/user/findPassword.do?username=";
		var username = document.getElementById('username').value;
		obj.href=url+username;
	}
</script>
<script src="<%=ctx%>/js/jquery.min.js"></script>
<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
<script src="<%=ctx%>/js/bootstrap.min.js"></script>
<script src="<%=ctx%>/js/jquery.validate.js"></script>
<script src="<%=ctx%>/js/jquery.wizard.js"></script>
<script src="<%=ctx%>/js/unicorn.js"></script>
<script src="<%=ctx%>/js/unicorn.wizard.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// Form Validation
		$("#basic_validate").validate({
			rules : {

				username : {
					required : true,

				},
				firstname : {
					required : true,

				},
				lastname : {
					required : true,

				},
				email : {
					required : true,
					email : true
				},
				telephone : {
					required : true,
					number : true
				},
				fax : {
					required : true,

				},
				password : {
					required : true,
					minlength : 6,
					maxlength : 20
				},
				password2 : {
					required : true,
					minlength : 6,
					maxlength : 20,
					
				}
			},

		});

	});
</script>
</head>
<body onload="init();">
	<div id="logo" align="center">
		<p><font size="6px" color="red">凤凰云端后台管理系统</font></p>
	</div>

	<div id="loginbox">
		<form id="loginform" class="form-vertical" method="GET"
			onSubmit="return check();" action="<%=ctx%>/system/login.do">
			<span style="color:red"><%=msg==null?"":msg%></span>
			<br>
			<br>
			<div class="control-group">
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-user"></i></span><input
							id="username" name="staff.code" type="text" placeholder="登陆名" />
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-lock"></i></span><input
							id="password" name="staff.password" type="password"
							placeholder="密码" />
					</div>
				</div>
			</div>
			<div class="form-actions">
				<span style="display:none" class="pull-left"><a href="#" class="flip-link"
					id="to-recover" onclick="register();">注册</a>&nbsp;&nbsp;&nbsp;</span><span
					class="pull-left"><a href="#" onclick="setInfo(this);" >忘记密码?</a></span> <span
					class="pull-right"><input type="submit"
					class="btn btn-inverse" value="登陆" /></span>
			</div>
		</form>
	</div>
	<div id="registerBox">
		<form id="basic_validate" class="form-vertical" method="post"
			action="<%=ctx%>/user/register.do" />
		<br>
		
	 	<div class="control-group">
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-envelope"></i></span><input
						id="email" type="text" placeholder="电子邮箱" name="email" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-pencil"></i></span><input
						id="telephone" type="text" placeholder="手机号码"
						name="telephone" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-user"></i></span><input
						id="username" type="text" placeholder="用户名" name="username" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-lock"></i></span><input
						id="password" type="password" placeholder="密码"
						name="password" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">

				<div class="input-prepend">
					<span class="add-on"><i class="icon-lock"></i></span><input
						id="password2" type="password" placeholder="确认密码"
						name="password2" />
				</div>
			</div>
		</div>
		
		
		<div class="form-actions">
			<span class="pull-left"><a href="#" class="flip-link"
				id="to-login" onclick="login();">&lt; 返回</a></span> <span
				class="pull-right"><input type="submit"
				class="btn btn-inverse" value="注册" /></span>
		</div>
		</form>
	</div>

</body>
</html>
