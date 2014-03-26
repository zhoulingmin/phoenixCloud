<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="sec"%>
<%@page import="com.phoenixcloud.bean.*" %>

<%
String ctx = request.getContextPath();
SysStaff staff = (SysStaff)session.getAttribute("user");
%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />
<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>

</head>

<body>
	<div class="free">
		<img src="<%=ctx %>/image/free_down.png">
	</div>
	<div class="left_main">
		<h3 class="margin_top_20">
			<a href="#">个人信息管理</a>
		</h3>
		<ul>
			<li><a href="<%=ctx %>/system/editUser.do?staff.staffId=<%=staff.getStaffId() %>" target="f_r" class="curr">个人资料</a></li>
			<li><a href="<%=ctx %>/system/modifyPass.do?staff.staffId=<%=staff.getStaffId() %>" target="f_r">修改密码</a></li>
			<sec:phoenixSec purviewCode="HARDWARE_MANAGE_MENU">
			<li><a href="<%=ctx %>/sq_info.jsp" target="f_r">授权信息</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="ORG_MANAGE">
			<li><a href="<%=ctx %>/jggl.jsp" target="f_r">机构管理</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="STAFF_MANAGE_MENU">
			<li><a href="<%=ctx %>/zhgl.jsp" target="f_r">账号管理</a></li>
			</sec:phoenixSec>

		</ul>
		<sec:phoenixSec purviewCode="BOOK_MANAGE">
			<h3>
				<a href="#">书籍管理</a>
			</h3>
			<ul>
				<li><a href="book_search.html" target="f_r" class="curr">书籍制作</a></li>
				<li><a href="book_search.html" target="f_r" class="curr">书籍审核</a></li>
				<li><a href="book_search.html" target="f_r" class="curr">书籍发布</a></li>
				<li><a href="sjzcmgl.html" target="f_r">注册码</a></li>
				<li><a href="book_jggj.html" target="_blank">书籍打包</a></li>
				<li><a href="book_search.html" target="f_r" class="curr">书籍查询</a></li>
			</ul>
		</sec:phoenixSec>
		<span class="arr"></span>
		<h3>
			<a href="#">资源管理</a>
		</h3>
		<ul>
			<li><a href="resour_search.html" target="f_r" class="curr">资源查询</a></li>
			<li><a href="resour_search.html" target="f_r" class="curr">资源审核</a></li>
			<li><a href="resour_search.html" target="f_r" class="curr">资源发布</a></li>
		</ul>
	</div>
</body>
</html>
