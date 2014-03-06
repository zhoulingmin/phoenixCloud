<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.math.*" %>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.system.service.ISysService" %>
<%@page import="com.phoenixcloud.util.SpringUtils, com.phoenixcloud.dao.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
		WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
ISysService iSysService = (ISysService)context.getBean("sysServiceImpl");
List<PubHw> hwList = (List<PubHw>)request.getAttribute("hwList");
if (hwList == null) {
	hwList = new ArrayList<PubHw>();
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
	
<title>硬件管理</title>
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
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addHw" onclick="addHw();" value="新建"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="modifyHw" onclick="modifyHw();" value="修改"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeHw" onclick="removeHws();" value="删除"/>
			</div>
		</div>
		
		<!-- 显示硬件列表  -->
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-hdd"></i></span>
				<h5>硬件列表</h5>
			</div>
			<div class="widget-content nopadding">
				<table id="hwTable" class="table table-bordered data-table">
					<thead>
						<tr>
							<th>
								<div id="uniform-title-table-checkbox" class="checker">
									<span class="">
										<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
									</span>
								</div>
							</th>
							<th>硬件类型</th>
							<th>硬件序列号</th>
							<th>绑定账号</th>
							<th>创建时间</th>
							<th>更新时间</th>
							<th>备注</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<%
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					for (PubHw hw : hwList) {
						String staffName = "未绑定"; 
						BigInteger staffId = hw.getStaffId();
						if (staffId != null && staffId != BigInteger.ZERO) {
							SysStaff staff = iSysService.findStaffById(staffId.toString());
							if (staff != null) {
								staffName = staff.getName();
							}
						}
						String createTime = sdf.format(hw.getCreateTime());
						String updateTime = sdf.format(hw.getUpdateTime());
						
						PubDdv hwType = ddvDao.find(hw.getHwType().toString());
						String hwTypeTmp = "";
						if (hwType != null) {
							hwTypeTmp = hwType.getValue();
						}
					%>
						<tr>
							<td>
								<div id="uniform-undefined" class="checker">
									<span class="">
										<input type="checkbox" style="opacity: 0;" value="<%=hw.getId()%>">
									</span>
								</div>
							</td>
							<td><%=hwTypeTmp %></td>
							<td><%=hw.getCode() %></td>
							<td><%=staffName %></td>
							<td><%=createTime %></td>
							<td><%=updateTime %></td>
							<td><%=hw.getNotes() %></td>
							<td>
								<a class="tip-top" data-original-title="修改" href="<%=ctx%>/system/system_editHw.do?hw.hwId=<%=hw.getId()%>"><i class="icon-edit"></i></a>
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

function modifyHw() {
	var checkedItems = jQuery("#hwTable tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 0) {
		alert("请选择要修改的硬件！");
		return;
	}
	
	window.loaction.href = "<%=ctx%>/system/system_editHw.do?hw.hwId=" + checkedItems[0].value;
}

function removeHws() {
	var ids = "";
	var checkedItems = jQuery("#hwTable tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length == 0) {
		alert("请选择要删除的硬件！");
		return;
	}
	for (var i = 0; i < checkedItems.length; i++) {
		ids += checkedItems[i].value;
		if (i != (checkedItems.length - 1)) {
			ids += ",";
		}
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/system/system_removeHw.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {hwIdArr:ids},
		success: function() {
			alert("删除成功！");
			window.location.href = "<%=ctx%>/system/system_getAllHw.do";
		},
		error: function() {
			alert("删除失败！");
		}
	});
}

function addHw() {
	location.href = "<%=ctx%>/addHw.jsp";
}

jQuery(document).ready(function() {
	jQuery("td a.tip-top:nth-child(2)").on("click", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeHw.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {hwIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllHw.do";
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