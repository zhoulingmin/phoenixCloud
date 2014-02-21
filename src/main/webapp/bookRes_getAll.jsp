<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();

RBook book = (RBook)request.getAttribute("book");
List<RBookRe> resList = (List<RBookRe>)request.getAttribute("resList");

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
	
<title>书籍管理界面</title>
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
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addBook" onclick="addRes();" value="新建"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeBook" onclick="editRes();" value="修改"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeBook" onclick="removeRes();" value="删除"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="uploadBook" onclick="uploadRes();" value="上传资源"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="viewBook" onclick="viewRes();" value="详情"/>
			</div>
		</div>

		<div><!-- this div node is just used to let $(this).parents('.widget-box') find only one node -->
			<div class="widget-box">
				<div class="widget-title">
					<span class="icon"><i class="icon-eye-open"></i></span>
					<h5><%=book.getName() %>--资源列表</h5>
				</div>
				<div class="widget-content nopadding">
					<table id="bookContent" class="table table-bordered data-table">
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
							<th>资源名称</th>
							<th>格式</th>
							<th>是否上传</th>
							<th>创建时间</th>
							<th>更新时间</th>
							<th>审核状态</th>
							<th>备注</th>
							<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<%
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
							for (RBookRe res : resList) {
								String createTime = sdf.format(res.getCreateTime());
								String updateTime = sdf.format(res.getUpdateTime());
								
								String format = "";
								PubDdv ddv = ddvDao.find(res.getFormat().toString());
								if (ddv != null) {
									format = ddv.getValue();
								}
								
								String auditStatus = "未知状态";
								if (res.getIsAudit() == (byte)-1) {
									auditStatus = "未审核";
								} else if (res.getIsAudit() == (byte)1) {
									auditStatus = "审核通过";
								} else if (res.getIsAudit() == (byte)0) {
									auditStatus = "审核不通过";
								}
							%>
							<tr>
								<td style="width:1%">
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=res.getId()%>">
										</span>
									</div>
								</td>
								<td style="width:5%;"><%=res.getId() %></td>
								<td><%=res.getName() %></a></td>
								<td><%=format %></td>
								<td><%if (res.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
								<td><%=createTime%></td>
								<td><%=updateTime%></td>
								<td><%=auditStatus %></td>
								<td><%=res.getNotes() %></td>
								<td>
									<%if (res.getIsUpload() == (byte)0) {%>
									<a class="tip-top" data-original-title="上传" href="<%=ctx%>/book/bookRes_editRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-upload"></i></a>
									<%} %>
									<a class="tip-top" data-original-title="详情" href="<%=ctx%>/book/bookRes_viewRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-eye-open"></i></a>
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/book/bookRes_editRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-edit"></i></a>
									<%if (res.getIsAudit() == (byte)0) {%>
									<a class="tip-top" data-original-title="" href="<%=ctx%>/book/bookRes_doAudit.do?bookRes.resId=<%=res.getId()%>&flag=1"><i class="icon-ok-circle"></i></a>
									<a class="tip-top" data-original-title="" href="<%=ctx%>/book/bookRes_doAudit.do?bookRes.resId=<%=res.getId()%>&flag=-1"><i class="icon-ban-circle"></i></a>
									<%} %>
									<a class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
								</td>
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

function addRes() {
	window.location.href = "<%=ctx%>/addRes.jsp";
}

function editRes() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_editBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

function uploadRes() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_editBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

function viewRes() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_viewBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

function removeRes() {
	var ids = "";
	
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length == 0) {
		alert("请选择要删除的书籍！");
		return;
	}
	for (var i = 0; i < checkedItems.length; i++) {
		ids += checkedItems[i].value;
		if (i != (checkedItems.length - 1)) {
			ids += ",";
		}
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/book/book_removeBook.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {bookIdArr:ids},
		success: function() {
			alert("删除成功！");
			window.location.href = "<%=ctx%>/book/book_getAll.do";
		},
		error: function() {
			alert("删除失败！");
		}
	});

}

jQuery(document).ready(function() {
	jQuery("td a.tip-top:last-child").on("click", function(e) {
		var id = jQuery(this.parentNode.parentNode).find("input:first-child").val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/book_removeBook.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {bookIdArr: id},
			success: function() {
				alert("删除成功！");
				window.location.href = "<%=ctx%>/book/book_getAll.do";
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