<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.res.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*" %>
<%@page import="com.phoenixcloud.system.service.ISysService" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>
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
				<security:phoenixSec purviewCode="STAFF_ADD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addUser" onclick="addUser();" value="新建"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="STAFF_UPDATE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="modifyUser" onclick="modifyUser();" value="修改"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="STAFF_DELETE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeUser" onclick="removeUsers();" value="删除"/>
				</security:phoenixSec>
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
							<security:phoenixSec purviewCode="manageUser">
							<th>操作</th>
							</security:phoenixSec>
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
								<security:phoenixSec purviewCode="STAFF_UPDATE">
								<a class="tip-top" data-original-title="修改" href="<%=ctx%>/system/system_editUser.do?staff.staffId=<%=staff.getId()%>"><i class="icon-edit"></i></a>
								</security:phoenixSec>
								<security:phoenixSec purviewCode="STAFF_DELETE">
								<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
								</security:phoenixSec>
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
<security:phoenixSec purviewCode="STAFF_DELETE">
var chkItems = null;
function removeUsers() {
	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	var ids = "";
	chkItems = jQuery("#userTable tbody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要删除的账号！");
		chkItems = null;
		return;
	}
	for (var i = 0; i < chkItems.length; i++) {
		ids += chkItems[i].value;
		if (i != (chkItems.length - 1)) {
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
			jQuery(chkItems).parents("tr").remove();
			chkItems = null;
		},
		error: function() {
			alert("删除失败！");
			chkItems = null;
		}
	});
}
</security:phoenixSec>
<security:phoenixSec purviewCode="STAFF_ADD">
function addUser() {
	location.href = "<%=ctx%>/addUser.jsp";
}
</security:phoenixSec>
<security:phoenixSec purviewCode="STAFF_UPDATE">
function modifyUser() {
	var checkedItems = jQuery("#userTable tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择要修改的账号！");
		return;
	}
	window.location.href = "<%=ctx%>/system/system_editUser.do?staff.staffId=" + checkedItems[0].value;
}
</security:phoenixSec>

jQuery(document).ready(function() {
	<security:phoenixSec purviewCode="STAFF_DELETE">
	jQuery("td a.tip-top:last-child").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeUser.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {userIdArr: id},
			success: function() {
				alert("删除成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("删除失败！");
				chkItems = null;
			}
		});
		return false;
	});
	</security:phoenixSec>
});
</script>
</html>