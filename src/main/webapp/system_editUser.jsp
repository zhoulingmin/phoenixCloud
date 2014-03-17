<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.List" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> staffTypeList = ddvDao.findByTblAndField("sys_staff", "STAFF_TYPE_ID");

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
String orgId = vs.findString("staff.orgId");
String orgName = "";
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg orgBean = orgDao.find(orgId);
if (orgBean != null) {
	orgName = orgBean.getOrgName();
}

Date date = (Date)vs.findValue("staff.validDate");
String validate = new SimpleDateFormat("yyyy/MM/dd").format(date);

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
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script src="<%=ctx%>/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	
	<title>修改账号</title>
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
				<h5>修改账号信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="editUser" class="form-horizontal" method="POST" action="#">
					<input type="hidden" name="staff.staffId" value="<s:property value="staff.staffId"/>" />
					<input type="hidden" name="staff.createTime" value="<s:date name="staff.createTime" format="yyyy/MM/dd HH:mm:ss" />"/>
					
					<div class="control-group">
						<label class="control-label">账号编码 (登陆名)</label>
						<div class="controls">
							<input type="text" name="staff.code" readonly="readonly" value="<s:property value="staff.code"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号名称 (昵称)</label>
						<div class="controls">
							<input type="text" name="staff.name" readonly="readonly" value="<s:property value="staff.name"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号密码</label>
						<div class="controls">
							<input type="password" name="staff.password" value="<s:property value="staff.password"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">机构标识</label>
						<div class="controls">
							<input type="text" name="orgNameTmp" onfocus="onfocusOrg()" value="<%=orgName %>">
							<input type="hidden" name="staff.orgId" value="<s:property value="staff.orgId"/>">
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号类型标识</label>
						<div class="controls">
							<select name="staff.staffTypeId" value="<s:property value="staff.staffTypeId"/>">
							<%for (PubDdv staffType : staffTypeList) { %>
								<option value="<%=staffType.getDdvId() %>"><%=staffType.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div id="datetimepicker1" class="control-group input-append date">
						<label class="control-label">有效期</label>
						<div class="controls">
							<input data-format="yyyy/MM/dd" type="text" name="staff.validDate" value="<%=validate%>">
							<span class="add-on">
						      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
						      </i>
						    </span>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="staff.notes" value="<s:property value="staff.notes"/>">
						</div>
					</div>
				
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="saveUser();">保存</button>
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

function saveUser() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_saveUser.do",
		data: jQuery("#editUser").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("修改账号成功！");
			location.href = "<%=ctx%>/system/system_getAllUser.do";
		},
		error: function() {
			alert("修改账号失败！");
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

$(function() {
	$("#datetimepicker1").datetimepicker({
		language : 'pt-BR'
	});
	$($(".add-on")[0]).on("click", "i", function(e){
		$($(".bootstrap-datetimepicker-widget")[0]).css("top", $(e.target.parentNode).offset().top);
		$($(".bootstrap-datetimepicker-widget")[0]).css("left", $(e.target.parentNode).offset().left + $(e.target.parentNode).width());
	});
	
	jQuery("select").each(function(idx) {
		jQuery(this).val(this.getAttribute("value"));
	});
	
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
});


</script>
</html>