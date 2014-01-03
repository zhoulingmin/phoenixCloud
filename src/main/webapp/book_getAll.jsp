<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.bean.PubOrg"%>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.RBook" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
		WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
//IRBookMgmtService iBookService = (IRBookMgmtService)context.getBean("bookMgmtServiceImpl");
IAgencyMgmtService iAgencyMgmt = (IAgencyMgmtService)context.getBean("agencyMgmtServiceImpl");

List<RBook> bookList = (List<RBook>)request.getAttribute("bookList");
if (bookList == null) {
	bookList = new ArrayList<RBook>();
}

%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/fullcalendar.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/select2.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/excanvas.min.js"></script>
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/select2.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.tables.js"></script>
	<script src="<%=ctx%>/js/global.js"></script>
	
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
			<div class="widget-box">
				<div class="widget-content">
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addBook" onclick="addBook();" value="新建"/>
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeBook" onclick="removeBooks();" value="删除"/>
				</div>
			</div>

			<div><!-- this div node is just used to let $(this).parents('.widget-box') find only one node -->
			<div class="widget-box">
				<div class="widget-title">
					<span class="icon"><i class="icon-eye-open"></i></span>
					<h5>书籍列表</h5>
				</div>
				<div class="widget-content nopadding">
					<table id="bookContent" class="table table-bordered data-table">
						<thead>
							<tr>
							<th>
								<div id="uniform-title-table-checkbox" class="checker">
									<span class="">
										<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
									</span>
								</div>
							</th>
							<th>书籍名称</th>
							<th>隶属机构</th>
							<th>上传状态</th>
							<th>备注</th>
							<th>创建时间</th>
							<th>更新时间</th>
							<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<%
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
							for (RBook book : bookList) {
								PubOrg org = iAgencyMgmt.findOrgById(book.getOrgId().toString());
								String orgName = "无"; 
								if (org != null) {
									orgName = org.getOrgName();
								}
								String createTime = sdf.format(book.getCreateTime());
								String updateTime = sdf.format(book.getUpdateTime());
							%>
							<tr>
								<td>
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=book.getId()%>">
										</span>
									</div>
								</td>
								<td><a href="<%=ctx%>/book/bookDire_getAll.do?bookId=<%=book.getId()%>"><%=book.getName() %></a></td>
								<td><%=orgName %></td>
								<td><%if (book.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
								<td><%=book.getNotes() %></td>
								<td><%=createTime%></td>
								<td><%=updateTime%></td>
								<td>
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/book/book_editBook.do?bookInfo.bookId=<%=book.getId()%>"><i class="icon-edit"></i></a>
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
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function addBook() {
	window.location.href = "<%=ctx%>/addBook.jsp";
}

function removeBooks() {
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
	jQuery("td a.tip-top:nth-child(2)").on("click", function(e) {
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