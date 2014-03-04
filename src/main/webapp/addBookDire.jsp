<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.math.BigInteger" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String ctx = request.getContextPath();
String bookId = request.getParameter("bookId");
String parentId = request.getParameter("parentId");
String level = request.getParameter("level");
if (level == null || "null".equalsIgnoreCase(level)) {
	level = "0";
}
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
	<title>创建书籍目录</title>
</head>
<body>

	<div class="widget-box">
		<div class="widget-title">
			<span class="icon"><i class="icon-align-justify"></i></span>
			<h5>输入书籍目录信息</h5>
		</div>
		<div class="widget-content nopadding">
			<form id="addDire" class="form-horizontal" method="POST" action="#">
				
				<input type="hidden" name="bookDire.bookId" value="<%=bookId%>"/>
				<input type="hidden" name="bookDire.parentDireId" value="<%=parentId%>"/>
				
				<div class="control-group" style="display:none">
					<label class="control-label">目录名称</label>
					<div class="controls">
						<input type="text" name="bookDire.name" value="书籍目录">
					</div>
				</div>
				<!--
				<div class="control-group">
					<label class="control-label">描述</label>
					<div class="controls">
						<input type="text" name="bookDire.notes">
					</div>
				</div>
				 
				<div class="control-group">
					<label class="control-label">起始页码</label>
					<div class="controls">
						<input type="text" name="bookDire.bPageNum">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">结束页码</label>
					<div class="controls">
						<input type="text" name="bookDire.ePageNum">
					</div>
				</div>
				 -->
				<div class="control-group" style="display:none">
					<label class="control-label">账号Id</label>
					<div class="controls">
						<input type="text" name="bookDire.staffId" value="1">
					</div>
				</div>
				
				<div class="control-group" style="display:none">
					<label class="control-label">级别</label>
					<div class="controls">
						<input type="text" name="bookDire.level" value="<%=level%>">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">数目</label>
					<div class="controls">
						<input type="text" name="num" value="1">
					</div>
				</div>
				
				<div class="form-actions">
					<button class="btn btn-primary" type="button"  onclick="addDire();">创建</button>
					<button class="btn btn-primary" style="margin-left:50px" onclick="self.close();">取消</button>
				</div>
				
			</form>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function addDire() {
	jQuery.ajax({
		url: "<%=ctx%>/book/bookDire_addDire.do",
		type: "post",
		data: jQuery("#addDire").serialize(),
		async: "false",
		timeout: 30000,
		success: function() {
			alert("创建目录成功！");
			if (window.opener != null) {
				window.opener.location.href = "<%=ctx%>/book/bookDire_getAll.do?bookId=<%=bookId%>";
			}
			self.close();
		},
		error: function() {
			alert("创建目录失败！");
		}
	});
	
}

</script>

</html>