<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.util.*" %>

<!DOCTYPE html>
<html>
<%
	String ctx = (String) request.getContextPath();
	String msg = (String) request.getParameter("reason");
	String promptDisplay = "display:none";
	String prompt = "";
	if ("existed".equalsIgnoreCase(msg)) {
		prompt = "用户已注册，请选用其它登陆名！";
		promptDisplay = "";
	}
	
	String teacherTypeId = "";
	PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
	PubDdv ddv = ddvDao.findClientUserDdv();
	if (ddv != null) {
		teacherTypeId = ddv.getDdvId();
	}
%>
<head>
<title>教师用户注册</title>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.login.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<script src="<%=ctx%>/js/jquery.min.js"></script>
<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
<script src="<%=ctx%>/js/bootstrap.min.js"></script>
<script src="<%=ctx%>/js/jquery.validate.js"></script>
<script src="<%=ctx%>/js/jquery.wizard.js"></script>
<script src="<%=ctx%>/js/unicorn.js"></script>
<script src="<%=ctx%>/js/unicorn.wizard.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
<%if ("success".equalsIgnoreCase(msg)) { %>
<script type="text/javascript">
	alert("注册成功！");
</script>
<%} %>
</head>
<body>
	
	<form id="basic_validate" class="form-vertical" onsubmit="return check();" method="post" action="<%=ctx%>/system/register.do" >
		<input type="hidden" name="staff.notes" value="" />
		<input type="hidden" name="staff.staffTypeId" value="<%=teacherTypeId %>" />
		<input type="hidden" name="staff.deleteState" value="0" />
		<div id="registerBox" style="margin-top:100px;">
		
			<div class="control-group" style="padding-top: 20px; <%=promptDisplay%>">
				<div class="controls">
					<div style="color:red">
						<%=prompt %>
					</div>
				</div>
			</div>
		
			<div class="control-group" <%if (!promptDisplay.isEmpty()) { out.print("style='padding-top: 20px;'");}%>>
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-user"></i></span><input
							id="code" type="text" placeholder="登录名" name="staff.code" />
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-lock"></i></span><input
							id="password" type="password" placeholder="密码"
							name="staff.password" />
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
	
					<div class="input-prepend">
						<span class="add-on"><i class="icon-lock"></i></span><input
							id="confirm_pass" type="password" placeholder="确认密码"
							name="confirm_pass" />
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-envelope"></i></span><input
							id="nickname" type="text" placeholder="昵称"
							name="staff.name" />
					</div>
				</div>
			</div>
	
			<div class="control-group">
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-envelope"></i></span><input
							id="email" type="text" placeholder="Email" name="staff.email" />
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on"><i class="icon-home"></i></span>
						<input type="hidden" name="staff.orgId" >
						<input id="orgId" type="text" name="orgNameTmp" placeholder="机构" onfocus="onfocusOrg()" >
						<div id="agencyTree" class="ztree" style="display:none; margin-left:auto; margin-right:auto; width:50%">
						</div>
					</div>
				</div>
			</div>
		
			<div class="form-actions">
				<span class="pull-left"><a href="<%=ctx %>/login.jsp" class="flip-link"
					id="to-login" onclick="register();">&lt; 云端登陆</a></span> <span
					class="pull-right"><input type="submit"
					class="btn btn-inverse" value="Register" /></span>
			</div>
		</div>
	</form>
</body>

<script type="text/javascript">

function onfocusOrg() {
	jQuery("#agencyTree").css("display", "block");
}

var zTreeObj,
setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getAgency.do",
		autoParam: ["type", "selfId"]
	},
	callback: {
		onClick: onSelOrg
	}
},
zTreeNodes = [];

function onSelOrg(event, treeId, treeNode, clickFlag) {
	if (treeNode != null && !treeNode.isParent) {
		// 1. set org field value
		jQuery(jQuery("input[name='staff.orgId']")[0]).val(treeNode.selfId);
		jQuery(jQuery("input[name='orgNameTmp']")[0]).val(treeNode.name);
		// 2. hide
		jQuery("#agencyTree").css("display", "none");
	}
}

$(function() {
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
});

function check() {
	if (jQuery("#code").val().trim().length == 0) {
		alert("登陆名不能为空!");
		jQuery("#code").focus();
		return false;
	}
	
	if (jQuery("#password").val().trim().length == 0) {
		alert("密码不能为空！");
		jQuery("#password").focus();
		return false;
	}
	
	if (jQuery("#password").val() != jQuery("#confirm_pass").val()) {
		alert("两次输入的密码不同！");
		jQuery("#password").focus();
		return false;
	}
	
	if (jQuery("input[name='staff.orgId']")[0].value.trim().length == 0) {
		alert("机构不能为空！");
		return false;
	}
	return true;
}
</script>

</html>
