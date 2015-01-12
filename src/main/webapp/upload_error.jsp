<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@taglib uri="/struts-tags" prefix="s"%>

<%
String ctx = request.getContextPath();
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff curStaff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(curStaff.getOrgId().toString());
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
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />

<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>

</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;服务器出错
		</div>
		
		<div class="widget-box" style="border-bottom: 2px solid #CCCCCC;">
			<div class="widget-title">
				<span class="icon"><i class="icon-book"></i></span>
				<h5>错误信息</h5>
			</div>
			<div class="widget-content" style="margin-left:20px">
				<div class="line_info margin_top_5">
					<font color="black"><s:property value="errInfo"/></font>
				</div>
				<div class="line_info margin_top_5">
					<input class="btn btn-primary" style="margin-top:10px;width:28px;" onclick="history.back();return false;" value="返回" />
				</div>
			</div>
		</div>

	</div>
</body>

</html>


