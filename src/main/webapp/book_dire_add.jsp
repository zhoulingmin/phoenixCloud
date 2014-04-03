<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<%
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getStaffId().toString());
String ctx = request.getContextPath();

String bookId = request.getParameter("bookId");
String parentId = request.getParameter("parentId");
String level = request.getParameter("level");
if (level == null || "null".equalsIgnoreCase(level)) {
	level = "0";
}

%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>

<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍制作&gt;书籍目录&gt;创建
		</div>

		<div class="widget-box">
		<div class="widget-title">
			<span class="icon"><i class="icon-align-justify"></i></span>
			<h5>输入书籍目录信息</h5>
		</div>
		<div class="widget-content nopadding">
			<form id="addDire" class="form-horizontal" method="POST" action="#">
				
				<input type="hidden" name="bookDire.bookId" value="<%=bookId%>"/>
				<input type="hidden" name="bookDire.parentDireId" value="<%=parentId%>"/>
				
				<div class="control-group" style="display:none">
					<label class="control-label">目录名称</label>
					<div class="controls">
						<input type="text" name="bookDire.name" value="书籍目录">
					</div>
				</div>
				
				<div class="control-group" style="display:none">
					<label class="control-label">账号Id</label>
					<div class="controls">
						<input type="text" name="bookDire.staffId" value="1">
					</div>
				</div>
				
				<div class="control-group" style="display:none">
					<label class="control-label">级别</label>
					<div class="controls">
						<input type="text" name="bookDire.level" value="<%=level%>">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">数目</label>
					<div class="controls">
						<input type="text" name="num" value="1">
					</div>
				</div>
				
				<div class="form-actions">
					<security:phoenixSec purviewCode="BOOK_EDIT_DIR">
					<button class="btn btn-primary" type="button"  onclick="addDire();">创建</button>
					</security:phoenixSec>
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">取消</button>
				</div>
			</form>
		</div>
	</div>
	</div>

</body>
<script type="text/javascript">

var isAdding = false;
function addDire() {
	
	if (isAdding) {
		alert("正在创建，请稍后！");
		return;
	}
	
	isAdding = true;
	jQuery.ajax({
		url: "<%=ctx%>/book/bookDire_addDire.do",
		type: "post",
		data: jQuery("#addDire").serialize(),
		async: "false",
		timeout: 30000,
		success: function() {
			alert("创建目录成功！");
			window.location.href = "<%=ctx%>/book/bookDire.do?mode=-1&bookId=<%=bookId%>";
		},
		error: function() {
			alert("创建目录失败！");
			isAdding = false;
		}
	});
	
}

</script>
</html>
