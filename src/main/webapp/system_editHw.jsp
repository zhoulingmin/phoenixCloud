<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
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
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	
	<title>修改硬件信息</title>
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
				<h5>修改硬件信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="editHw" class="form-horizontal" method="POST" action="#">
					<input type="hidden" name="hw.hwId" value="<s:property value="hw.hwId"/>" />
					<div class="control-group">
						<label class="control-label">硬件类型</label>
						<div class="controls">
							<input type="text" name="hw.hwType" readonly="readonly" value="<s:property value="hw.hwType"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">序列号</label>
						<div class="controls">
							<input type="text" name="hw.code" value="<s:property value="hw.code"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">绑定账号的ID</label>
						<div class="controls">
							<input type="text" name="hw.staffId" value="<s:property value="hw.staffId"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="hw.notes" value="<s:property value="hw.notes"/>">
						</div>
					</div>
					
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="saveHw();">保存</button>
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

function saveHw() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_saveHw.do",
		data: jQuery("#editHw").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("修改硬件信息成功！");
			location.href = "<%=ctx%>/system/system_getAllHw.do";
		},
		error: function() {
			alert("修改硬件信息失败！");
		}
	});
}

</script>
</html>