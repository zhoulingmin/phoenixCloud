<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.*"%>
<%@page import="com.phoenixcloud.system.service.ISysService" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
ISysService userService = (ISysService)SpringUtils.getBean("sysServiceImpl");
IAgencyMgmtService iAgencyMgmt = (IAgencyMgmtService)SpringUtils.getBean("agencyMgmtServiceImpl");
List<SysStaff> staffList = (List<SysStaff>)request.getAttribute("staffList");
if (staffList == null) {
	staffList = new ArrayList<SysStaff>();
}

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/select2.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/select2.min.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.tables.js"></script>
	
<title>账号管理</title>
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
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addUser" onclick="addUser();" value="新建"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="modifyUser" onclick="modifyUser();" value="修改"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeUser" onclick="removeUsers();" value="删除"/>
			</div>
		</div>
		
		<!-- 显示账号列表  -->
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-user"></i></span>
				<h5>账号列表</h5>
			</div>
			<div class="widget-content nopadding">
				<table id="userTable" class="table table-bordered data-table">
					<thead>
						<tr>
							<th>
								<div id="uniform-title-table-checkbox" class="checker">
									<span class="">
										<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
									</span>
								</div>
							</th>
							<th>账号ID</th>
							<th>账号名</th>
							<th>隶属机构</th>
							<th>账号类型</th>
							<th>账号编码</th>
							<th>有效期</th>
							<th>创建时间</th>
							<th>更新时间</th>
							<th>备注</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<%
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					for (SysStaff staff : staffList) { 
						PubOrg org = iAgencyMgmt.findOrgById(staff.getOrgId().toString());
						String orgName = "无"; 
						if (org != null) {
							orgName = org.getOrgName();
						}
						String createTime = sdf.format(staff.getCreateTime());
						String updateTime = sdf.format(staff.getUpdateTime());
						PubDdv staffType = ddvDao.find(staff.getStaffTypeId().toString());
						String type = "";
						if (staffType != null) {
							type = staffType.getValue();
						}
					
					%>
						<tr>
							<td>
								<div id="uniform-undefined" class="checker">
									<span class="">
										<input type="checkbox" style="opacity: 0;" value="<%=staff.getId()%>">
									</span>
								</div>
							</td>
							<td><%=staff.getId() %></td>
							<td><%=staff.getName() %></td>
							<td><%=orgName %></td>
							<td><%=type %></td>
							<td><%=staff.getCode() %></td>
							<td><%=staff.getValidDate() %></td>
							<td><%=createTime %></td>
							<td><%=updateTime %></td>
							<td><%=staff.getNotes() %></td>
							<td>
								<a class="tip-top" data-original-title="修改" href="<%=ctx%>/system/system_editUser.do?staff.staffId=<%=staff.getId()%>"><i class="icon-edit"></i></a>
								<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
							</td>
						</tr>
					<%} %>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
<script type="text/javascript">

function removeUsers() {
	var ids = "";
	var checkedItems = jQuery("#userTable tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length == 0) {
		alert("请选择要删除的账号！");
		return;
	}
	for (var i = 0; i < checkedItems.length; i++) {
		ids += checkedItems[i].value;
		if (i != (checkedItems.length - 1)) {
			ids += ",";
		}
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/system/system_removeUser.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {userIdArr:ids},
		success: function() {
			alert("删除成功！");
			window.location.href = "<%=ctx%>/system/system_getAllUser.do";
		},
		error: function() {
			alert("删除失败！");
		}
	});
}

function addUser() {
	location.href = "<%=ctx%>/addUser.jsp";
}

function modifyUser() {
	var checkedItems = jQuery("#userTable tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择要修改的账号！");
		return;
	}
	window.location.href = "<%=ctx%>/system/system_editUser.do?staff.staffId=" + checkedItems[0].value;
}

jQuery(document).ready(function() {
	jQuery("td a.tip-top:last-child").on("click", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeUser.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {userIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllUser.do";
			},
			error: function() {
				alert("删除失败！");
			}
		});
		return false;
	});
});
</script>
</html>