<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.dao.res.*"%>
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

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
PubDdv ddv = ddvDao.find(vs.findString("bookRes.format"));
String resFormatName = "";
if (ddv != null) {
	resFormatName = ddv.getValue();
}
RBookPageResDao pgRsDao = (RBookPageResDao)SpringUtils.getBean("RBookPageResDao");
String pages = pgRsDao.getResRelatedPages(new java.math.BigInteger(vs.findString("bookRes.resId")));

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
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍制作&gt;修改资源
		</div>
		
		<div class="widget-box">
			<div class="widget-content">
				<div class="fileinput fileinput-new" data-provides="fileinput">
					<form id="uploadResFrm" action="<%=ctx%>/book/uploadBookResNew.do" onsubmit="checkfile()" method="POST" enctype="multipart/form-data">
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
						<input type="hidden" name="bookInfo.isAudit" value="-1" />
						<input id="uploadBtn" type="submit" class="btn" onclick="return checkfile();" name="submit" value="上传"/>						
					</form>
				</div>
			</div>
		</div>

		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>资源信息</h5>
			</div>
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
					
					<div class="control-group" style="display:none">
						<label class="control-label">资源目录地址</label>
						<div class="controls">
							<input type="text" name="bookRes.cataAddr" value="<s:property value="bookRes.cataAddr"/>" readonly="readonly"/>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">引用资源页码(如:2,50,99 用逗号隔开)</label>
						<div class="controls">
							<input type="text" name="pages" value="<%=pages %>" placeholder="2,50,99,..."/>
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
						<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">取消</button>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">

function checkfile() {
	if(jQuery("#bookFile").val().length == 0) {
		alert("请先选择文件！");
		return false;
	}
	return true;
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
			window.location.href = "<%=ctx%>/book/bookRes.do?bookInfo.isAudit=-1&bookRes.bookId=<s:property value="bookRes.bookId"/>";
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
