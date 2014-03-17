<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> staffTypeList = ddvDao.findByTblAndField("sys_staff", "STAFF_TYPE_ID");

%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-datetimepicker.min.css"/>
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	
	<title>新建账号</title>
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
				<h5>录入账号信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="addUser" class="form-horizontal" method="POST" action="#">
				
					<div class="control-group">
						<label class="control-label">账号编码 (登陆名)</label>
						<div class="controls">
							<input type="text" name="staff.code" onchange="checkExists()">
						</div>
					</div>
				
					<div class="control-group">
						<label class="control-label">账号名称 (昵称)</label>
						<div class="controls">
							<input type="text" name="staff.name" value="">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号密码</label>
						<div class="controls">
							<input type="password" name="staff.password" value="">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">机构标识</label>
						<div class="controls">
							<input type="text" name="orgNameTmp" onfocus="onfocusOrg()" >
							<input type="hidden" name="staff.orgId" >
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号类型标识</label>
						<div class="controls">
							<select name="staff.staffTypeId">
							<%for (PubDdv staffType : staffTypeList) { %>
								<option value="<%=staffType.getDdvId() %>"><%=staffType.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div id="datetimepicker1" class="control-group input-append date">
						<label class="control-label">有效期</label>
						<div class="controls">
							<input data-format="yyyy/MM/dd" type="text" name="staff.validDate">
							<span class="add-on">
						      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
						      </i>
						    </span>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="staff.notes">
						</div>
					</div>
					
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="addUser();">创建</button>
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
	location.href = "<%=ctx%>/system/system_getAllUser.do";
}

function addUser() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_addUser.do",
		data: jQuery("#addUser").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("创建账号成功！");
			location.href = "<%=ctx%>/system/system_getAllUser.do";
		},
		error: function() {
			alert("创建账号失败！");
		}
	});
}

function onfocusOrg() {
	jQuery("#agencyTree").css("display", "block");
}

var zTreeObj,
setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getAgency.do",
		autoParam: ["type", "selfId"]
	},
	callback: {
		onClick: onSelOrg
	}
},
zTreeNodes = [];

function onSelOrg(event, treeId, treeNode, clickFlag) {
	if (treeNode != null && !treeNode.isParent) {
		// 1. set org field value
		jQuery(jQuery("input[name='staff.orgId']")[0]).val(treeNode.selfId);
		jQuery(jQuery("input[name='orgNameTmp']")[0]).val(treeNode.name);
		// 2. hide
		jQuery("#agencyTree").css("display", "none");
	}
}

jQuery(document).ready(function(){
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
	
	jQuery("#datetimepicker1").datetimepicker({
		language : 'pt-BR'
	});
	$($(".add-on")[0]).on("click", "i", function(e){
		$($(".bootstrap-datetimepicker-widget")[0]).css("top", $(e.target.parentNode).offset().top);
		$($(".bootstrap-datetimepicker-widget")[0]).css("left", $(e.target.parentNode).offset().left + $(e.target.parentNode).width());
	});
});

</script>
</html>