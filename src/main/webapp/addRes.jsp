<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.math.BigInteger" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String ctx = request.getContextPath();
String bookId = request.getParameter("bookId");
String parentId = request.getParameter("parentId");
if (parentId == null || "null".equalsIgnoreCase(parentId)) {
	parentId = "0";
}

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> formatList = ddvDao.findByTblAndField("r_book_res", "FORMAT");


%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<title>创建资源</title>
</head>
<body>

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
				
				<div class="control-group">
					<label class="control-label">资源目录地址</label>
					<div class="controls">
						<input type="text" name="bookRes.cataAddr" value="" />
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
						<input type="text" name="num">
					</div>
				</div>
				
				
				<div class="form-actions">
					<button class="btn btn-primary" type="button"  onclick="addRes();">创建</button>
					<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">取消</button>
				</div>
				
			</form>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function cancel() {
	self.close();
}

function addRes() {
	jQuery.ajax({
		url: "<%=ctx%>/book/bookRes_addRes.do",
		type: "post",
		data: jQuery("#addRes").serialize(),
		async: "false",
		timeout: 30000,
		success: function() {
			alert("创建资源成功！");
			if (window.opener != null) {
				window.opener.location.href = "<%=ctx%>/book/bookRes_getAll.do?bookRes.bookId=<%=bookId%>";
			}
			self.close();
		},
		error: function() {
			alert("创建资源失败！");
		}
	});
	
}

</script>

</html>