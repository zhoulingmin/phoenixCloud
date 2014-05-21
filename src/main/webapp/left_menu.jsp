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
		<sec:phoenixSec purviewCode="PERSONAL_INFO_MGT_MENU">
		<h3 class="margin_top_20">
			<a href="#">个人信息管理</a>
		</h3>
		<ul>
			<sec:phoenixSec purviewCode="PERSONAL_INFO_MENU">
			<li><a href="<%=ctx %>/system/editUser.do?staff.staffId=<%=staff.getStaffId() %>" target="f_r">个人资料</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="PERSONAL_INFO_UPDATE_PWD">
			<li><a href="<%=ctx %>/system/modifyPass.do?staff.staffId=<%=staff.getStaffId() %>" target="f_r">修改密码</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="AUTH_INFO_MENU">
			<li><a href="<%=ctx%>/system/searchHw.do" target="f_r">授权信息</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="ACNT_MGMT_MENU">
			<li><a href="<%=ctx %>/zhgl.jsp" target="f_r">账号管理</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="ORG_MGMT_MENU">
			<li><a href="<%=ctx %>/jggl.jsp" target="f_r">机构管理</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="PRIVILEGE_MGMT_MENU">
			<li><a href="<%=ctx %>/qxgl.jsp" target="f_r">权限管理</a></li>
			</sec:phoenixSec>
		</ul>
		</sec:phoenixSec>
		<sec:phoenixSec purviewCode="BOOK_MGMT_MENU">
			<h3>
				<a href="#">书籍管理</a>
			</h3>
			<ul>
				<sec:phoenixSec purviewCode="BOOK_MAKE_MENU">
				<li><a href="<%=ctx %>/book_zhizuo.jsp" target="f_r">书籍制作</a></li>
				</sec:phoenixSec>
				<sec:phoenixSec purviewCode="BOOK_AUDIT_MENU">
				<li><a href="<%=ctx %>/book_audit.jsp" target="f_r">书籍审核</a></li>
				</sec:phoenixSec>
				<sec:phoenixSec purviewCode="BOOK_RELEASE_MENU">
				<li><a href="<%=ctx %>/book_release.jsp" target="f_r" >书籍发布</a></li>
				</sec:phoenixSec>
				<sec:phoenixSec purviewCode="BOOK_REG_CODE_MGMT_MENU">
				<li><a href="<%=ctx %>/sjzcmgl.jsp" target="f_r">注册码</a></li>
				</sec:phoenixSec>
				<li style="display:none"><a href="book_jggj.html" target="_blank">书籍打包</a></li>
				<sec:phoenixSec purviewCode="BOOK_SEARCH_MENU">
				<li><a href="<%=ctx %>/book_query.jsp" target="f_r">书籍查询</a></li>
				</sec:phoenixSec>
			</ul>
		</sec:phoenixSec>
		<span style="display:none" class="arr"></span>
		<sec:phoenixSec purviewCode="RES_MGMT_MENU">
		<h3>
			<a href="#">资源管理</a>
		</h3>
		<ul>
			<sec:phoenixSec purviewCode="RES_MAKE_MENU">
			<li><a href="<%=ctx %>/resour_make.jsp" target="f_r">资源制作</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="RES_AUDIT_MENU">
			<li><a href="<%=ctx %>/resour_audit.jsp" target="f_r">资源审核</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="RES_RELEASE_MENU">
			<li><a href="<%=ctx %>/resour_release.jsp" target="f_r">资源发布</a></li>
			</sec:phoenixSec>
			<sec:phoenixSec purviewCode="RES_SEARCH_MENU">
			<li><a href="<%=ctx %>/resour_search.jsp" target="f_r">资源查询</a></li>
			</sec:phoenixSec>
		</ul>
		</sec:phoenixSec>
	</div>
</body>
</html>
