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
RBookReDao resDao = (RBookReDao)SpringUtils.getBean("rBookReDao");

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");

String bookId = vs.findString("bookRes.bookId");

String staffName = "";
SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
SysStaff staff = staffDao.find(vs.findString("bookRes.staffId"));
if (staff != null) {
	staffName = staff.getName();
}

String auditStatus = "未审核";
String auditStaffName = "无";
if ((Byte)vs.findValue("bookRes.isAudit") != (byte)-1) {
	staff = staffDao.find(vs.findString("bookRes.auditStaffId"));
	if (staff != null) {
		auditStaffName = staff.getName();
	}
	if ((Byte)vs.findValue("bookRes.isAudit") == 0) {
		auditStatus = "审核不通过";
	} else {
		auditStatus = "审核通过";
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
				<h5>资源信息</h5>
			</div>
			<div class="widget-content">
				<div class="margin_top_5">
					<font class="blue">资源名称: </font>
					<font class="black"><s:property value="bookRes.name"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">父资源名称: </font>
					<font class="black"><%=parentResName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">服务器IP: </font>
					<font class="black"><s:property value="bookRes.ipAddr"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">资源目录地址: </font>
					<font class="black"><s:property value="bookRes.cataAddr"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">资源全地址: </font>
					<font class="black"><s:property value="bookRes.allAddr"/></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">是否上传: </font>
					<font class="black"><%=isUpload %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">创建时间: </font>
					<font class="black"><s:date name="bookRes.createTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">更新时间: </font>
					<font class="black"><s:date name="bookRes.updateTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">审核状态: </font>
					<font class="black"><%=auditStatus %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">审核人: </font>
					<font class="black"><%=auditStaffName %></font>
				</div>
				<div class="margin_top_5">
					<font class="blue">备注: </font>
					<font class="black"><s:property value="bookRes.notes"/></font>
				</div>
				<div class="margin_top_5">
					<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">返回</button>
				</div>
				
			</div>
			
		</div>
	</div>
	
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function cancel() {
	location.href = "<%=ctx%>/book/bookRes_getAll.do?bookRes.bookId=<%=bookId%>";
}

</script>

</html>