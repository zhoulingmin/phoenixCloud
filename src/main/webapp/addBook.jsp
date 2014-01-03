<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
%>

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
	
<title>书籍管理界面</title>
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
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>录入书籍信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="bookForm" class="form-horizontal" method="POST" action="#">
					<div class="control-group">
						<label class="control-label">书籍名称</label>
						<div class="controls">
							<input type="text" name="bookInfo.name">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">机构</label>
						<div class="controls">
							<input type="text" name="bookInfo.orgId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">出版社标识</label>
						<div class="controls">
							<input type="text" name="bookInfo.pressId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">学科标识</label>
						<div class="controls">
							<input type="text" name="bookInfo.subjectId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">学段标识</label>
						<div class="controls">
							<input type="text" name="bookInfo.stuSegId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">年级标识</label>
						<div class="controls">
							<input type="text" name="bookInfo.classId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">册别标识</label>
						<div class="controls">
							<input type="text" name="bookInfo.kindId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">资源目录地址</label>
						<div class="controls">
							<input type="text" name="bookInfo.cataAddrId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">服务器IP</label>
						<div class="controls">
							<input type="text" name="bookInfo.ipAddr">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">书全地址</label>
						<div class="controls">
							<input type="text" name="bookInfo.allAddr">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">是否上传</label>
						<div class="controls">
							<input type="text" name="bookInfo.isUpload">
						</div>
					</div>
					<!--
					<div class="control-group">
						<label class="control-label">创建时间</label>
						<div class="controls">
							<input type="text" name="bookInfo.orgId">
						</div>
					</div>
					 
					<div class="control-group">
						<label class="control-label">更新时间</label>
						<div class="controls">
							<input type="text" name="bookInfo.createTime">
						</div>
					</div>
					-->
					<div class="control-group">
						<label class="control-label">账号</label>
						<div class="controls">
							<input type="text" name="bookInfo.staffId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="bookInfo.notes">
						</div>
					</div>
				
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="addBook();">创建</button>
						<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();">取消</button>
					</div>
				</form>
			</div>
			
		</div>
	</div>
	
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function addBook() {
	jQuery.ajax({
		url: "<%=ctx%>/book/book_addBook.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: jQuery("#bookForm").serialize(),
		dataType: "json",
		success: function() {
			alert("创建书籍成功！");
			location.href = "<%=ctx%>/book/book_getAll.do";
		},
		error: function() {
			alert("创建书籍失败！");
		}
	})
}

function cancel() {
	location.href = "<%=ctx%>/book/book_getAll.do";
}
</script>

</html>