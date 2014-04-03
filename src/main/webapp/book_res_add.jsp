<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
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
String bookId = request.getParameter("bookId");
String parentId = request.getParameter("parentId");
if (parentId == null || "null".equalsIgnoreCase(parentId)) {
	parentId = "0";
}

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> formatList = ddvDao.findByTblAndField("r_book_res", "FORMAT");

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
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍制作&gt;书籍资源&gt;创建
		</div>

		<div class="widget-box">
		<div class="widget-title">
			<span class="icon"><i class="icon-align-justify"></i></span>
			<h5>输入资源信息</h5>
		</div>
		<div class="widget-content nopadding">
			<form id="addRes" class="form-horizontal" method="POST" action="#">
				
				<input type="hidden" name="bookRes.bookId" value="<%=bookId%>"/>
				<input type="hidden" name="bookRes.parentResId" value="<%=parentId%>"/>
				
				<div class="control-group" style="display:none">
					<label class="control-label">资源名称</label>
					<div class="controls">
						<input type="hidden" name="bookRes.name" value="资源">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">格式</label>
					<div class="controls">
						<select name="bookRes.format">
							<%for (PubDdv format : formatList) { %>
							<option value="<%=format.getDdvId()%>"><%=format.getValue() %></option>
							<%} %>
						</select>
					</div>
				</div>
				
				<div class="control-group" style="display:none">
					<label class="control-label">资源目录地址</label>
					<div class="controls">
						<input type="text" name="bookRes.cataAddr" value="" />
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">引用资源页码(如:2,50,99 用逗号隔开)</label>
					<div class="controls">
						<input type="text" name="pages" value="" placeholder="2,50,99,..."/>
					</div>
				</div>
				
				<div class="control-group" style="display:none">
					<label class="control-label">备注</label>
					<div class="controls">
						<input type="text" name="bookRes.notes" value="">
					</div>
				</div>
				
				<div class="control-group" >
					<label class="control-label">数目</label>
					<div class="controls">
						<input type="text" name="num" value="1">
					</div>
				</div>
				
				<div class="form-actions">
					<security:phoenixSec purviewCode="RES_ADD">
					<button class="btn btn-primary" type="button"  onclick="addRes();">创建</button>
					</security:phoenixSec>
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">取消</button>
				</div>
			</form>
		</div>
	</div>
	</div>

</body>
<script type="text/javascript">
var isAdding = false;
function addRes() {
	if (isAdding) {
		alert("正在创建资源，请稍后！");
		return;
	}
	isAdding = true;
	jQuery.ajax({
		url: "<%=ctx%>/book/addRes.do",
		type: "post",
		data: jQuery("#addRes").serialize(),
		async: "false",
		timeout: 30000,
		success: function() {
			alert("创建资源成功！");
			window.location.href = "<%=ctx%>/book/bookRes.do?bookInfo.isAudit=-1&bookRes.bookId=<%=bookId%>";
		},
		error: function() {
			alert("创建资源失败！");
			isAdding = false;
		}
	});
	
}

</script>
</html>
