<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="java.util.List" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> hwTypeList = ddvDao.findByTblAndField("pub_hardware", "HW_TYPE");
ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
String staffName = "";
SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
SysStaff staff = staffDao.find(vs.findString("hw.staffId"));
if (staff != null) {
	staffName = staff.getName();
}
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	
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
					<input type="hidden" name="hw.createTime" value="<s:date name="hw.createTime" format="yyyy/MM/dd HH:mm:ss" />"/>
					<div class="control-group">
						<label class="control-label">硬件类型</label>
						<div class="controls">
							<select name="hw.hwType" value="<s:property value="hw.hwType"/>">
							<%for (PubDdv hwType : hwTypeList) { %>
								<option value="<%=hwType.getDdvId()%>"><%=hwType.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">序列号</label>
						<div class="controls">
							<input type="text" name="hw.code" value="<s:property value="hw.code"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">绑定的账号</label>
						<div class="controls">
							<input type="hidden" name="hw.staffId" value="<s:property value="hw.staffId"/>">
							<input type="text" name="staffName" value="<%=staffName %>" onfocus="onfocusStaff()"/>
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
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


function onfocusStaff() {
	jQuery("#agencyTree").css("display", "block");
}

var zTreeObj,
setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getStaff.do",
		autoParam: ["type", "selfId"]
	},
	callback: {
		onClick: onSelStaff
	}
},
zTreeNodes = [];

function onSelStaff(event, treeId, treeNode, clickFlag) {
	if (treeNode != null && !treeNode.isParent) {
		// 1. set org field value
		jQuery(jQuery("input[name='hw.staffId']")[0]).val(treeNode.selfId);
		jQuery(jQuery("input[name='staffName']")[0]).val(treeNode.name);
		// 2. hide
		jQuery("#agencyTree").css("display", "none");
	}
}

jQuery(document).ready(function(){
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
	
	jQuery("select").each(function() {
		jQuery(this).val(this.getAttribute("value"));
	});
});

</script>
</html>