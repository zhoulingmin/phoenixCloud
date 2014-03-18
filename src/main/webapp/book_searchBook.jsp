<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="com.phoenixcloud.dao.ctrl.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
IAgencyMgmtService iAgencyMgmt = (IAgencyMgmtService)SpringUtils.getBean("agencyMgmtServiceImpl");

List<RBook> bookList = (List<RBook>)request.getAttribute("bookList");
if (bookList == null) {
	bookList = new ArrayList<RBook>();
}

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> subjectList = ddvDao.findByTblAndField("r_book", "SUBJECT_ID");
List<PubDdv> stuSegList = ddvDao.findByTblAndField("r_book", "STU_SEG_ID");
List<PubDdv> classList = ddvDao.findByTblAndField("r_book", "CLASS_ID");
PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);
List<PubPress> pressList = pressDao.getAll();

%>


<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	
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
		<security:phoenixSec purviewCode="BOOK_MANAGE">
		<div class="widget-box">
			<div class="widget-content">
				<form id="searchBook" action="<%=ctx %>/book/searchBook.do" method="post">
					<input type="hidden" name="bookInfo.isAudit" value="-2" >
					书名:
					<input type="text" name="bookInfo.name" />
					学段:
					<select name="bookInfo.stuSegId">
						<option value="0" selected="selected">全部</option>
						<%for (PubDdv stu : stuSegList) { %>
						<option value="<%=stu.getDdvId()%>"><%=stu.getValue() %></option>
						<%} %>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;学科:
					<select name="bookInfo.subjectId">
						<option value="0">全部</option>
						<%for (PubDdv sub: subjectList) {%>
						<option value="<%=sub.getDdvId() %>"><%=sub.getValue() %></option>
						<%} %>
					</select>
					<br />
					年级:
					<select name="bookInfo.classId">
						<option value="0" selected="selected">全部</option>
						<%for (PubDdv cls : classList) { %>
						<option value="<%=cls.getDdvId()%>"><%=cls.getValue() %></option>
						<%} %>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;出版社:
					<select name="bookInfo.pressId">
						<option value="0" selected="selected">全部</option>
						<%for (PubPress press : pressList) { %>
						<option value="<%=press.getPressId() %>"><%=press.getName() %></option>
						<%} %>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn" value="搜索" type="submit" style="margin-bottom:10px;width:50px;"/>
				</form>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="viewBook" onclick="viewBook();" value="详情"/>
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
							<th style="width:1%;">
								<div id="uniform-title-table-checkbox" class="checker">
									<span class="">
										<input id="title-table-checkbox" type="checkbox" name="title-table-checkbox" style="opacity: 0;">
									</span>
								</div>
							</th>
							<th style="width:5%;">标识</th>
							<th>书名</th>
							<th>书籍编码</th>
							<th>隶属机构</th>
							<th>上传状态</th>
							<th>审核状态</th>
							<th>创建人</th>
							<th>创建时间</th>
							<th>更新时间</th>
							<th>备注</th>
							<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<%
							SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
							for (RBook book : bookList) {
								PubOrg org = iAgencyMgmt.findOrgById(book.getOrgId().toString());
								String orgName = "无"; 
								if (org != null) {
									orgName = org.getOrgName();
								}
								String createTime = sdf.format(book.getCreateTime());
								String updateTime = sdf.format(book.getUpdateTime());
								SysStaff staff = staffDao.find(book.getStaffId().toString());
							%>
							<tr>
								<td style="width:1%">
									<div id="uniform-undefined" class="checker">
										<span class="">
											<input type="checkbox" style="opacity: 0;" value="<%=book.getId()%>">
										</span>
									</div>
								</td>
								<td style="width:5%;"><%=book.getId() %></td>
								<td><a href="<%=ctx%>/book/book_viewBook.do?bookInfo.bookId=<%=book.getId()%>"><%=book.getName() %></a></td>
								<td><%=book.getBookNo() %></td>
								<td><%=orgName %></td>
								<td><%if (book.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
								<td>
								<%if (book.getIsAudit() == (byte)-1) { %>
								制作中
								<%} else if (book.getIsAudit() == (byte)0){ %>
								待审核
								<%} else if (book.getIsAudit() == (byte)1){ %>
								待发布
								<%} else if (book.getIsAudit() == (byte)2){ %>
								已发布
								<%} %>
								</td>
								<td><%=staff.getName() %></td>
								<td><%=createTime%></td>
								<td><%=updateTime%></td>
								<td><%=book.getNotes() %></td>
								<td>
								<%if (book.getIsUpload() == (byte)1) {%>
								<a class="tip-top" data-original-title="下载" href="<%=ctx%>/book/book_download.do?bookInfo.bookId=<%=book.getId()%>"><i class="icon-download-alt"></i></a>
								<%} %>
								</td>
							</tr>
							<%} %>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		</security:phoenixSec>
	</div>

	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">


function viewBook() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_viewBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

</script>

</html>