<%@page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@taglib uri="/struts-tags" prefix="s"%>

<%
ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff curStaff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(curStaff.getOrgId().toString());

String ctx = (String) request.getContextPath();


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
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍日志管理&gt;日志详情
		</div>
		
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"></span>
				<h5>日志信息</h5>
			</div>
			<div class="widget-content">
			    <div class="line_info margin_top_5">
					<font class="blue">操作编号: </font>
					<font color="black"><s:property value="systemlog[0]"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">操作用户: </font>
					<font color="black"><s:property value="systemlog[1]"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">操作类型: </font>
					<font color="black"><s:property value="systemlog[2]"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">操作方法: </font>
					<font color="black"><s:property value="systemlog[3]"/></font>
				</div>
				
				<div class="line_info margin_top_5">
					<font class="blue">操作内容: </font>
					<font color="black"><s:property value="systemlog[6]"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">操作时间: </font>
					<font color="black"><s:property value="systemlog[4]"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">操作地址: </font>
					<font color="black"><s:property value="systemlog[5]"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">操作结果: </font>
					<font color="black">成功</font>
				</div>
				<div class="line_info margin_top_5">
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">返回</button>
				</div>
			</div>
		</div>

	</div>
</body>

</html>


