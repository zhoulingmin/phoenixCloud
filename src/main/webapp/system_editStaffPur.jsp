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
	
	<title>设置功能权限</title>
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
				<h5>设置功能权限</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="addStaffPur" class="form-horizontal" method="POST" action="#">
					<input type="hidden" name="staffPur.staPurId" value="<s:property value="staffPur.staPurId"/>"/>
					<input type="hidden" name="staffPur.createTime" value="<s:date name="staffPur.createTime" format="yyyy/MM/dd HH:mm:ss"/>"/>
					<div class="control-group">
						<label class="control-label">账号标识</label>
						<div class="controls">
							<input type="text" name="staffPur.staffId" value="<s:property value="staffPur.staffId"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">权限点标识</label>
						<div class="controls">
							<input type="text" name="staffPur.purviewId" value="<s:property value="staffPur.purviewId"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">配置账号</label>
						<div class="controls">
							<input type="text" name="staffPur.cfgStaffId" value="<s:property value="staffPur.cfgStaffId"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="staffPur.notes" value="<s:property value="staffPur.notes"/>">
						</div>
					</div>

					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="addStaffPur();">创建</button>
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
	location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=staffPurTab";
}

function addStaffPur() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_addStaffPur.do",
		data: jQuery("#addStaffPur").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("添加权限成功！");
			location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=staffPurTab";
		},
		error: function() {
			alert("添加权限失败！");
		}
	});
}

</script>
</html>