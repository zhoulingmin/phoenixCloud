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

String bookId = vs.findString("bookRes.bookId");
RBookReDao resDao = (RBookReDao)SpringUtils.getBean("rBookReDao");

String staffName = "";
SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
SysStaff staff = staffDao.find(vs.findString("bookRes.staffId"));
if (staff != null) {
	staffName = staff.getName();
}

String auditStatus = "制作中";
String auditStaffName = "无";
if ((Byte)vs.findValue("bookRes.isAudit") != (byte)-1) {
	staff = staffDao.find(vs.findString("bookRes.auditStaffId"));
	if (staff != null) {
		auditStaffName = staff.getName();
	}
	if ((Byte)vs.findValue("bookRes.isAudit") == 0) {
		auditStatus = "审核中";
	} else if ((Byte)vs.findValue("bookRes.isAudit") == 1){
		auditStatus = "待上架";
	} else if ((Byte)vs.findValue("bookRes.isAudit") == 2){
		auditStatus = "已上架";
	} else if ((Byte)vs.findValue("bookRes.isAudit") == 3){
		auditStatus = "已下架";
	}
}

String isUpload = "未上传";
if ((Byte)vs.findValue("bookRes.isUpload") == (byte)1) {
	isUpload = "已上传";
}

String parentResName = "无";
RBookRe parentRes = resDao.find(vs.findString("bookRes.parentResId"));
if (parentRes != null) {
	parentResName = parentRes.getName();
}

String cataAddr = "";
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
PubDdv ddvFmt = ddvDao.find(vs.findString("bookRes.format"));
if (ddvFmt != null) {
	cataAddr = ddvFmt.getValue();
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
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;资源详情
		</div>
		
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-book"></i></span>
				<h5>资源信息</h5>
			</div>
			<div class="widget-content">
				<div class="line_info margin_top_5">
					<font class="blue">资源名称: </font>
					<font color="black"><s:property value="bookRes.name"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">父资源名称: </font>
					<font color="black"><%=parentResName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">服务器IP: </font>
					<font color="black"><s:property value="bookRes.ipAddr"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">资源目录地址: </font>
					<font color="black"><%=cataAddr %></font>
				</div>
				<div class="margin_top_line_info margin_top_55">
					<font class="blue">资源全地址: </font>
					<font color="black"><s:property value="bookRes.allAddr"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">是否上传: </font>
					<font color="black"><%=isUpload %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">创建时间: </font>
					<font color="black"><s:date name="bookRes.createTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">更新时间: </font>
					<font color="black"><s:date name="bookRes.updateTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">审核状态: </font>
					<font color="black"><%=auditStatus %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">审核人: </font>
					<font color="black"><%=auditStaffName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">备注: </font>
					<font color="black"><s:property value="bookRes.notes"/></font>
				</div>
				<div class="line_info margin_top_5">
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">返回</button>
				</div>
			</div>
		</div>

	</div>
</body>

</html>


