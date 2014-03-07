<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.RRegCode" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
		WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
IRBookMgmtService iBookService = (IRBookMgmtService)context.getBean("bookMgmtServiceImpl");
List<RRegCode> codeList = (List<RRegCode>)request.getAttribute("codeList");
if (codeList == null) {
	codeList = new ArrayList<RRegCode>();
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
	
<title>书籍注册码管理</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<security:phoenixSec purviewCode="manageRegcode">
		<div class="widget-box">
			<div class="widget-content">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addRegCode" onclick="addRegCode();" value="新建"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeCodes" onclick="removeCodes();" value="删除"/>
			</div>
		</div>
		</security:phoenixSec>
		<div><!-- this div node is just used to let $(this).parents('.widget-box') find only one node -->
			<div class="widget-box">
				<div class="widget-title">
					<span class="icon"><i class="icon-list-alt"></i></span>
					<h5>注册码列表</h5>
				</div>
				<div class="widget-content nopadding">
					<table id="regCodeContent" class="table table-bordered data-table">
						<thead>
							<tr>
							<th style="width:1%;">
								<div id="uniform-title-table-checkbox" class="checker">
									<span class="">
										<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
									</span>
								</div>
							</th>
							<th style="width:5%;">标识</th>
							<th>书籍标识</th>
							<th>注册码</th>
							<th>是否有效</th>
							<th>失效日期</th>
							<th>创建时间</th>
							<th>更新时间</th>
							<th>账号</th>
							<th>备注</th>
							<security:phoenixSec purviewCode="manageRegcode">
							<th>操作</th>
							</security:phoenixSec>
							</tr>
						</thead>
						<tbody>
							<%
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
							for (RRegCode code : codeList) {
								String createTime = sdf.format(code.getCreateTime());
								String updateTime = sdf.format(code.getUpdateTime());
								String expireDate = new SimpleDateFormat("yyyy/MM/dd").format(code.getValidDate());
								String isValid = "否";
								if (code.getIsValid() == (byte)1) {
									isValid = "是";
								}
							%>
							<tr>
								<td style="width:1%">
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=code.getId()%>">
										</span>
									</div>
								</td>
								<td style="width:5%;"><%=code.getId() %></td>
								<td><%=code.getBookId() %></td>
								<td><%=code.getCode() %></td>
								<td><%=isValid %></td>
								<td><%=expireDate %></td>
								<td><%=createTime%></td>
								<td><%=updateTime%></td>
								<td><%=code.getStaffId() %></td>
								<td><%=code.getNotes() %></td>
								<security:phoenixSec purviewCode="manageRegcode">
								<td>
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/book/bookRegCode_edit.do?regCode.regCodeId=<%=code.getId()%>"><i class="icon-edit"></i></a>
									<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
								</td>
								</security:phoenixSec>
							</tr>
							<%} %>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function addRegCode() {
	window.location.href = "<%=ctx%>/addRegCode.jsp";
}

function removeCodes() {
	var ids = "";
	
	var checkedItems = jQuery("#regCodeContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length == 0) {
		alert("请选择要删除的注册码！");
		return;
	}
	for (var i = 0; i < checkedItems.length; i++) {
		ids += checkedItems[i].value;
		if (i != (checkedItems.length - 1)) {
			ids += ",";
		}
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/book/bookRegCode_remove.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {regCodeIdArr:ids},
		success: function() {
			alert("删除成功！");
			window.location.href = "<%=ctx%>/book/bookRegCode_getAll.do";
		},
		error: function() {
			alert("删除失败！");
		}
	});

}

jQuery(document).ready(function() {
	jQuery("td a.tip-top:nth-child(2)").on("click", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/bookRegCode_remove.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {regCodeIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/book/bookRegCode_getAll.do";
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