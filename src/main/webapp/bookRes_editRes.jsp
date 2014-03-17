<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.math.BigInteger" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.*" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String ctx = request.getContextPath();

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubDdv ddv = ddvDao.findByDdvCode(new BigInteger(vs.findString("bookRes.format")));
String resFormatName = "";
if (ddv != null) {
	resFormatName = ddv.getValue();
}
String mode = request.getParameter("mode");
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<title>修改资源</title>
</head>
<body>

	<div class="widget-box">
		<div class="widget-title">
			<span class="icon"><i class="icon-align-justify"></i></span>
			<h5>输入资源信息</h5>
		</div>
		<security:phoenixSec purviewCode="BOOK_RES_UPLOAD">
		<div class="widget-box">
			<div class="widget-content">
				<div class="fileinput fileinput-new" data-provides="fileinput">
					<form id="uploadResFrm" action="<%=ctx%>/book/uploadBookRes.do" onsubmit="checkfile()" method="POST" enctype="multipart/form-data">
						<span class="btn btn-default btn-file">
							<span class="fileinput-new">选择资源文件</span>
							<span class="fileinput-exists">重新选择资源文件</span>
							<input id="resFile" type="file" name="resFile">
						</span>
						<span class="fileinput-filename"></span>
						<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
						<input type="hidden" name="bookRes.bookId" value="<s:property value="bookRes.bookId"/>" />
						<input type="hidden" name="bookRes.resId" value="<s:property value="bookRes.resId"/>" />
						<input type="hidden" name="bookRes.isUpload" value="<s:property value="bookRes.isUpload"/>" />
						<input type="hidden" name="bookRes.cataAddr" value="<s:property value="bookRes.cataAddr"/>" />
						<input type="hidden" name="bookInfo.isAudit" value="<%=mode %>" />
						<input id="uploadBtn" type="submit" class="btn" onclick="return checkfile();" name="submit" value="上传"/>						
					</form>
				</div>
			</div>
		</div>
		</security:phoenixSec>
		<div class="widget-content nopadding">
			<form id="editRes" class="form-horizontal" method="POST" action="#">
				<input type="hidden" name="bookRes.resId" value="<s:property value="bookRes.resId"/>"/>
				<input type="hidden" name="bookRes.parentResId" value="<s:property value="bookRes.parentResId"/>"/>
				<div class="control-group">
					<label class="control-label">资源名称</label>
					<div class="controls">
						<input type="text" name="bookRes.name" value="<s:property value="bookRes.name"/>"/ readonly="readonly">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">格式</label>
					<div class="controls">
						<input type="hidden" name="bookRes.format" value="<s:property value="bookRes.format"/>"/>
						<input type="text" name="resFormat" value="<%=resFormatName %>" readonly="readonly" />
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">资源目录地址</label>
					<div class="controls">
						<input type="text" name="bookRes.cataAddr" value="<s:property value="bookRes.cataAddr"/>" readonly="readonly"/>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">备注</label>
					<div class="controls">
						<input type="text" name="bookRes.notes" value="<s:property value="bookRes.notes"/>">
					</div>
				</div>
				
				
				<div class="form-actions">
					<secutiry:phoenixSec purviewCode="BOOK_RES_UPDATE">
					<button class="btn btn-primary" type="button"  onclick="saveRes();">保存</button>
					</secutiry:phoenixSec>
					<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">取消</button>
				</div>
				
			</form>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function checkfile() {
	if(jQuery("#resFile").val().length == 0) {
		alert("请先选择文件！");
		return false;
	}
	return true;
}

function cancel() {
	self.close();
}

function saveRes() {
	jQuery.ajax({
		url: "<%=ctx%>/book/bookRes_saveRes.do",
		type: "post",
		data: jQuery("#editRes").serialize(),
		async: "false",
		timeout: 30000,
		success: function() {
			alert("保存资源成功！");
			if (window.opener != null) {
				window.opener.location.href = "<%=ctx%>/book/bookRes_getAll.do?bookInfo.isAudit=<%=mode%>&bookRes.bookId=<s:property value="bookRes.bookId"/>";
			}
			self.close();
		},
		error: function() {
			alert("保存资源失败！");
		}
	});
}

$(function() {
	jQuery("select").each(function(idx) {
		jQuery(this).val(this.getAttribute("value"));
	});
	
	var isUpload = jQuery("input[name='bookRes.isUpload']")[0].value;
	if (isUpload != null && isUpload == 1) {
		jQuery("#uploadBtn").val("更新");
	}
});

</script>

</html>