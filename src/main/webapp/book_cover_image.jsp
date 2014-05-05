<%@page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%
	SysStaff staff = (SysStaff) session.getAttribute("user");
	PubOrgDao orgDao = (PubOrgDao) SpringUtils.getBean(PubOrgDao.class);
	PubOrg org = orgDao.find(staff.getStaffId().toString());
	String ctx = request.getContextPath();

	String bookId = request.getParameter("bookId");
	if (bookId == null) {
		bookId = "";
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
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>
<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>

</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName()%></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx%>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍制作&gt;书籍封面
		</div>

		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>上传书籍封面</h5>
			</div>
			<div class="widget-content">
				<br>
				<security:phoenixSec purviewCode="BOOK_UPLOAD_COVER">
				<div class="fileinput fileinput-new" data-provides="fileinput">
					<form id="uploadCoverFrm"
						action="<%=ctx%>/book/uploadBookCoverPic.do"
						onsubmit="checkfile()" method="POST" enctype="multipart/form-data">
						<span class="btn btn-default btn-file"> <span
							class="fileinput-new">请选择封面图片</span> <span
							class="fileinput-exists">重新选择封面图片</span> <input id="coverFile"
							type="file" name="coverFile">
						</span> <span class="fileinput-filename"></span> <a href="#"
							class="close fileinput-exists" data-dismiss="fileinput"
							style="float: none">&times;</a> 
						<input type="hidden" name="bookId" value="<%=bookId%>" /> 
						<input id="uploadBtn" type="submit" class="btn btn-primary" onclick="return checkfile();" name="submit" value="上传" />
						<input type="button" onclick="history.back();return false;" style="margin-left:50px" class="btn btn-primary" value="返回" />
					</form>
				</div>
				</security:phoenixSec>
				<br>
				<div class="fileinput-preview thumbnail" style="width: 102px; height: 141px; line-height: 150px;">
					<img src="<%=ctx%>/book/showBookConver.do?bookInfo.bookId=<%=bookId%>" alt="没有封面图片"/>
				</div>
				<br><br>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">
	function checkfile() {
		var fileName = jQuery("#coverFile").val();
		if (fileName.length == 0) {
			alert("请先选择文件！");
			return false;
		}
		var regImgFile = /.(jpg|jpeg|png|gif|bmp|tiff)$/;
		
		if (!regImgFile.test(fileName)) {
			alert("请上传图片作为封面，目前支持格式: jpg, jpeg, png, bmp, tiff");
			return false;
		} 
		
		return true;
	}
</script>
</html>
