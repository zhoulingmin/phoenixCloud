<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.math.*" %>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.system.service.ISysService" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
		WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
ISysService iSysService = (ISysService)context.getBean("sysServiceImpl");
IRBookMgmtService iBookService = (IRBookMgmtService)context.getBean("bookMgmtServiceImpl");
List<SysPurview> purviewList = (List<SysPurview>)request.getAttribute("purviewList");
if (purviewList == null) {
	purviewList = new ArrayList<SysPurview>();
}
List<SysStaffPurview> staffPurList = (List<SysStaffPurview>)request.getAttribute("staffPurList");
if (staffPurList == null) {
	staffPurList = new ArrayList<SysStaffPurview>();
}

List<SysStaffRegCode> staffRegCodeList = (List<SysStaffRegCode>)request.getAttribute("staffRegCodeList");
if (staffRegCodeList == null) {
	staffRegCodeList = new ArrayList<SysStaffRegCode>();
}

String tabId = (String)request.getAttribute("tabId");
if (tabId == null || tabId.isEmpty()) {
	tabId = "purviewTabTable";
}
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
	
<title>权限管理</title>
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
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addItem" onclick="addItem();" value="新建"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeItems" onclick="removeItems();" value="删除"/>
			</div>
		</div>
		
		<div class="widget-box">
			
			<div class="widget-title">
				<ul class="nav nav-tabs">
					<li class="">
						<a href="#purviewTab" data-toggle="tab">权限列表</a>
					</li>
					<li class="">
						<a href="#staffPurTab" data-toggle="tab">功能权限配置</a>
					</li>
					<li class="">
						<a href="#staffRegCodeTab" data-toggle="tab">图书下载权限配置</a>
					</li>
				</ul>
			</div>
			
			<div class="widget-content tab-content" style="padding: 0px; border-left-width: 0px;">
				<!-- 权限列表 -->
				<div id="purviewTab" class="tab-pane">
					<table id="purviewTabTable" class="table table-bordered data-table">
						<thead>
							<tr>
								<th style="width:1%">
									<div id="uniform-title-table-checkbox" class="checker">
										<span class="">
											<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
										</span>
									</div>
								</th>
								<th style="width:5%">标识</th>
								<th>权限名称</th>
								<th>编码</th>
								<th>创建时间</th>
								<th>更新时间</th>
								<th>备注</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
						<%
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
						for (SysPurview pur : purviewList) {
							String createTime = sdf.format(pur.getCreateTime());
							String updateTime = sdf.format(pur.getUpdateTime());
						
						%>
							<tr>
								<td style="width:1%">
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=pur.getId()%>">
										</span>
									</div>
								</td>
								<td style="width:5%"><%=pur.getId() %></td>
								<td><%=pur.getName() %></td>
								<td><%=pur.getCode() %></td>
								<td><%=createTime %></td>
								<td><%=updateTime %></td>
								<td><%=pur.getNotes() %></td>
								<td>
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/system/system_editPurview.do?purview.purviewId=<%=pur.getId()%>"><i class="icon-edit"></i></a>
									<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
								</td>
							</tr>
						<%} %>
						</tbody>
					</table>				
				</div>
				
				<!-- 功能权限配置 -->
				<div id="staffPurTab" class="tab-pane">
					<table id="staffPurTabTable" class="table table-bordered data-table">
						<thead>
							<tr>
								<th style="width:1%">
									<div id="uniform-title-table-checkbox" class="checker">
										<span class="">
											<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
										</span>
									</div>
								</th>
								<th style="width:5%">标识</th>
								<th>账号</th>
								<th>权限点标识</th>
								<th>创建时间</th>
								<th>更新时间</th>
								<th>备注</th>
								<th>配置账号</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
						<%
						for (SysStaffPurview staffPur : staffPurList) {
							String createTime = sdf.format(staffPur.getCreateTime());
							String updateTime = sdf.format(staffPur.getUpdateTime());
							String acntName = "无";
							SysStaff staff = iSysService.findStaffById(staffPur.getStaffId().toString());
							if (staff != null) {
								acntName = staff.getName();
							}
						%>
							<tr>
								<td style="width:1%">
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=staffPur.getId()%>">
										</span>
									</div>
								</td>
								<td style="width:5%"><%=staffPur.getId() %></td>
								<td><%=acntName %></td>
								<td><%=staffPur.getPurviewId() %></td>
								<td><%=createTime %></td>
								<td><%=updateTime %></td>
								<td><%=staffPur.getNotes() %></td>
								<td><%=staffPur.getCfgStaffId() %></td>
								<td>
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/system/system_editStaffPur.do?staffPur.staPurId=<%=staffPur.getId()%>"><i class="icon-edit"></i></a>
									<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
								</td>
							</tr>
						<%} %>
						</tbody>
					</table>
				</div>
				
				<!-- 图书下载权限配置 -->
				<div id="staffRegCodeTab" class="tab-pane">
					<table id="staffRegCodeTabTable" class="table table-bordered data-table">
						<thead>
							<tr>
								<th style="width:1%">
									<div id="uniform-title-table-checkbox" class="checker">
										<span class="">
											<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
										</span>
									</div>
								</th>
								<th style="width:5%">标识</th>
								<th>账号</th>
								<th>书籍标识</th>
								<th>注册码</th>
								<th>失效日期</th>
								<th>是否有效</th>
								<th>创建时间</th>
								<th>更新时间</th>
								<th>备注</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
						<%
						for (SysStaffRegCode regCode : staffRegCodeList) {
							String createTime = sdf.format(regCode.getCreateTime());
							String updateTime = sdf.format(regCode.getUpdateTime());
							String acntName = "无";
							SysStaff staff = iSysService.findStaffById(regCode.getStaffId().toString());
							if (staff != null) {
								acntName = staff.getName();
							}
							String codeVal = "无";
							String expireDate = "无";
							String isValid = "否";
							RRegCode bookRgcode = iBookService.findRegCode(regCode.getRegCodeId().toString());
							if (bookRgcode != null) {
								codeVal = bookRgcode.getCode();
								expireDate = new SimpleDateFormat("yyyy/MM/dd").format(bookRgcode.getValidDate());
								if (bookRgcode.getIsValid() == (byte)1) {
									isValid = "是";
								}
							}
						%>
							<tr>
								<td style="width:1%">
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=regCode.getId()%>">
										</span>
									</div>
								</td>
								<td style="width:5%"><%=regCode.getId() %></td>
								<td><%=acntName %></td>
								<td><%=regCode.getBookId() %></td>
								<td><%=codeVal %></td>
								<td><%=expireDate %></td>
								<td><%=isValid %></td>
								<td><%=createTime %></td>
								<td><%=updateTime %></td>
								<td><%=regCode.getNotes() %></td>
								<td>
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/system/system_editStaffRegCode.do?staffRegCode.ssrcId=<%=regCode.getId()%>"><i class="icon-edit"></i></a>
									<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
								</td>
							</tr>
						<%} %>
						</tbody>
					</table>		
				</div>
			</div>
			<div class="widget-content nopadding">
				
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
<script type="text/javascript">

function removeItems() {
	var ids = "";
	var tabId = jQuery(".tab-content > div").filter(".active")[0].id;
	var checkedItems = jQuery("#" + tabId +" tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length == 0) {
		alert("请选择要删除的项目！");
		return;
	}
	for (var i = 0; i < checkedItems.length; i++) {
		ids += checkedItems[i].value;
		if (i != (checkedItems.length - 1)) {
			ids += ",";
		}
	}
	
	if (tabId == "purviewTab") {
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removePurview.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {purIdArr:ids},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=" + tabId;
			},
			error: function() {
				alert("删除失败！");
			}
		});
	} else if (tabId == "staffPurTab") {
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeStaffPur.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {staffPurIdArr:ids},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=" + tabId;
			},
			error: function() {
				alert("删除失败！");
			}
		});
	} else if (tabId == "staffRegCodeTab") {
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeStaffRegCode.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {staffRegCodeIdArr:ids},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=" + tabId;
			},
			error: function() {
				alert("删除失败！");
			}
		});
	}
}

function addItem() {
	var tabId = jQuery(".tab-content > div").filter(".active")[0].id;
	if (tabId == "purviewTab") {
		location.href = "<%=ctx%>/addPurview.jsp";
	} else if (tabId == "staffPurTab") {
		location.href = "<%=ctx%>/addStaffPur.jsp";
	} else if (tabId == "staffRegCodeTab") {
		location.href = "<%=ctx%>/addStaffRegCode.jsp";
	}
}

jQuery(document).ready(function() {
	// 设置激活tab
	var activeTabId = "<%=tabId%>";
	jQuery("#" + activeTabId).addClass("active");
	if (activeTabId == "purviewTab") {
		jQuery(".nav-tabs > li:eq(0)").addClass("active");
	} else if (activeTabId == "staffPurTab") {
		jQuery(".nav-tabs > li:eq(1)").addClass("active");
	} else if (activeTabId == "staffRegCodeTab") {
		jQuery(".nav-tabs > li:eq(2)").addClass("active");
	}
	
	// 删除权限
	jQuery("#purviewTabTable").on("click", "td a.tip-top:nth-child(2)", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removePurview.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {purIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=purviewTab";
			},
			error: function() {
				alert("删除失败！");
			}
		});
		return false;
	});
	
	// 删除权限配置
	jQuery("#staffPurTabTable").on("click", "td a.tip-top:nth-child(2)", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeStaffPur.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {staffPurIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=staffPurTab";
			},
			error: function() {
				alert("删除失败！");
			}
		});
		return false;
	});
	
	// 删除注册码
	jQuery("#staffRegCodeTabTable").on("click", "td a.tip-top:nth-child(2)", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/system/system_removeStaffRegCode.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {staffRegCodeIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/system/system_getAllPurview.do?tabId=staffRegCodeTab";
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