<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.List" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");

String orgId = vs.findString("bookInfo.orgId");
String orgName = "";
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg orgBean = orgDao.find(orgId);
if (orgBean != null) {
	orgName = orgBean.getOrgName();
}

String pressName = "";
PubPress press = pressDao.find(vs.findString("bookInfo.pressId"));
if (press != null) {
	pressName = press.getName();
}

String subName = "";
PubDdv ddv = ddvDao.find(vs.findString("bookInfo.subjectId"));
if (ddv != null) {
	subName = ddv.getValue();
}

String stuName = "";
ddv = ddvDao.find(vs.findString("bookInfo.stuSegId"));
if (ddv != null) {
	stuName = ddv.getValue();
}

String clsName = "";
ddv = ddvDao.find(vs.findString("bookInfo.classId"));
if (ddv != null) {
	clsName = ddv.getValue();
}

String kindName = "";
ddv = ddvDao.find(vs.findString("bookInfo.kindId"));
if (ddv != null) {
	kindName = ddv.getValue();
}

String cataAddr = "";
ddv = ddvDao.find(vs.findString("bookInfo.cataAddrId"));
if (ddv != null) {
	cataAddr = ddv.getValue();
}

String staffName = "";
SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
SysStaff staff = staffDao.find(vs.findString("bookInfo.staffId"));
if (staff != null) {
	staffName = staff.getName();
}

String isUpload = "未上传";
if ((Byte)vs.findValue("bookInfo.isUpload") == (byte)1) {
	isUpload = "已上传";
}

byte mode = (Byte)vs.findValue("bookInfo.isAudit");

%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	
	<style type="text/css">
	
	.margin_top_5 {
	    margin-top: 5px;
	}
	
	.black {
	    color: #666666;
	}
	
	.blue {
	    color: #5585D7;
	}
	</style>
	
	<title>书籍详情</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-book"></i></span>
				<h5>书籍信息</h5>
			</div>
			<div class="widget-content">
				<div class="margin_top_5">
					<font class="blue">书籍名称: </font>
					<font class="black"><s:property value="bookInfo.name"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">机构: </font>
					<font class="black"><%=orgName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">出版社名称: </font>
					<font class="black"><%=pressName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">学科: </font>
					<font class="black"><%=subName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">学段: </font>
					<font class="black"><%=stuName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">年级: </font>
					<font class="black"><%=clsName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">册别: </font>
					<font class="black"><%=kindName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">页数: </font>
					<font class="black"><s:property value="bookInfo.pageNum"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">资源目录地址: </font>
					<font class="black"><%=cataAddr %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">服务器IP: </font>
					<font class="black"><s:property value="bookInfo.ipAddr"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">书全地址: </font>
					<font class="black"><s:property value="bookInfo.allAddr"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">是否上传: </font>
					<font class="black"><%=isUpload %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">创建时间: </font>
					<font class="black"><s:date name="bookInfo.createTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">更新时间: </font>
					<font class="black"><s:date name="bookInfo.updateTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">账号: </font>
					<font class="black"><%=staffName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">备注: </font>
					<font class="black"><s:property value="bookInfo.notes"/></font>
				</div>
				<div class="margin_top_5">
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">返回</button>
				</div>
				
			</div>
			
		</div>
	</div>
	
	<jsp:include page="footer.jsp" flush="true" />
</body>


</html>