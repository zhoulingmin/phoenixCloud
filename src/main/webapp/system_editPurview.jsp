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
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	
	<title>修改权限</title>
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
				<h5>权限信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="savePur" class="form-horizontal" method="POST" action="#">
					<input type="hidden" name="purview.purviewId" value="<s:property value="purview.purviewId"/>"/>
					<input type="hidden" name="purview.createTime" value="<s:date name="purview.createTime" format="yyyy/MM/dd HH:mm:ss" />"/>
					<div class="control-group">
						<label class="control-label">权限名称</label>
						<div class="controls">
							<input type="text" name="purview.name" value="<s:property value="purview.name"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">编码</label>
						<div class="controls">
							<input type="text" name="purview.code" value="<s:property value="purview.code"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="purview.notes" value="<s:property value="purview.notes"/>">
						</div>
					</div>

					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="savePurview();">保存</button>
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
	location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=purviewTab";
}

function savePurview() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_savePurview.do",
		data: jQuery("#savePur").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("修改权限成功！");
			location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=purviewTab";
		},
		error: function() {
			alert("修改权限失败！");
		}
	});
}

</script>
</html>