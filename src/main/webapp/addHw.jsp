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
	
	<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	
	<title>添加硬件</title>
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
				<h5>录入硬件信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="addHw" class="form-horizontal" method="POST" action="#">
					<div class="control-group">
						<label class="control-label">硬件类型</label>
						<div class="controls">
							<input type="text" name="hw.hwType">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">序列号</label>
						<div class="controls">
							<input type="text" name="hw.code">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">绑定账号的ID</label>
						<div class="controls">
							<input type="text" name="hw.staffId">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="hw.notes">
						</div>
					</div>
					
					<!-- 
					<div id="datetimepicker1" class="control-group input-append date">
						<label class="control-label">有效期</label>
						<div class="controls">
							<input data-format="yyyy/MM/dd hh:mm:ss" type="text" name="hw.validDate">
							<span class="add-on">
						      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
						      </i>
						    </span>
						</div>
					</div>
					 -->
				
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="addHw();">创建</button>
						<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">取消</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
<script type="text/javascript">
function cancel() {
	location.href = "<%=ctx%>/system/system_getAllHw.do";
}

function addHw() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_addHw.do",
		data: jQuery("#addHw").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("添加硬件成功！");
			location.href = "<%=ctx%>/system/system_getAllHw.do";
		},
		error: function() {
			alert("添加硬件失败！");
		}
	});
}

</script>
</html>