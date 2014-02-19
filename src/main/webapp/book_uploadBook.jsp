<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.phoenixcloud.bean.RBook" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
RBook book = (RBook)request.getAttribute("book");
%>

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
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
	
	<title>上传书籍</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<div class="widget-box">
			<div class="widget-content">
				<div class="fileinput fileinput-new" data-provides="fileinput">
					<form id="uploadBookFrm" action="<%=ctx%>/book/uploadBook.do" method="POST" enctype="multipart/form-data">
						<span class="btn btn-default btn-file">
							<span class="fileinput-new">选择书籍文件</span>
							<span class="fileinput-exists">重新选择书籍文件</span>
							<input id="bookFile" type="file" name="bookFile">
						</span>
						<span class="fileinput-filename"></span>
						<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
						<input type="hidden" name="bookId" value="<%=book.getId()%>" />
						<%if (book.getIsUpload() == (byte)0) {%>
						<input type="submit" class="btn" name="submit" value="上传"/>
						<%} else {%>
						<input type="submit" class="btn" name="submit" value="更新" />
						<%} %>
					</form>
				</div>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content">
				
			</div>
		</div>
		
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
</html>