<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.common.*" %>

<%
String ctx = request.getContextPath();

SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getStaffId().toString());

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

PhoenixProperties prop = PhoenixProperties.getInstance();
String schema = prop.getProperty("protocol_file_transfer");
if (schema == null || schema.isEmpty()) {
	schema = "http";
}
String resCtx = prop.getProperty("res_server_appname");
if (resCtx == null || resCtx.isEmpty()) {
	resCtx = "resserver";
}
PubServerAddrDao addrDao = (PubServerAddrDao)SpringUtils.getBean(PubServerAddrDao.class);
PubServerAddr inAddr = addrDao.findByOrgId(staff.getOrgId(), Constants.IN_NET);
String inHost = "";
int inHostPort = 0;
if (inAddr != null) {
	inHost = inAddr.getBookSerIp();
	inHostPort = inAddr.getBookSerPort();
}

PubServerAddr outAddr = addrDao.findByOrgId(staff.getOrgId(), Constants.OUT_NET);
String outHost = "";
int outHostPort = 0;
if (outAddr != null) {
	outHost = outAddr.getBookSerIp();
	outHostPort = outAddr.getBookSerPort();
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>

<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>

<style>
tr td,th{
white-space:nowrap;
}

</style>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx%>/image/home_icon.jpg">&nbsp;书籍查询
		</div>
	
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				<form id="searchBook" action="<%=ctx %>/book/searchBookNew.do" method="post">
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
					<security:phoenixSec purviewCode="BOOK_QUERY">
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn btn-primary" value="搜索" type="submit" style="margin-bottom:10px;width:50px;"/>
					</security:phoenixSec>
				</form>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				<security:phoenixSec purviewCode="BOOK_DETAIL">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="viewBook" onclick="viewBook();" value="详情"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_SEARCH_DIR">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="editBookDire" onclick="editBookDire();" value="目录"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_SEARCH_RES">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="editBookRes" onclick="editBookRes();" value="资源"/>
				</security:phoenixSec>
			</div>
		</div>

		<div class="widget-box" style="overflow:scroll">
			<table class="list_table" style="margin-top:0px">
				<thead>
					<tr>
						<th style="width:1%"><input type="checkbox" onchange="checkAll(this);"></th>
						<th>书名</th>
						<th>书籍编码</th>
						<th>隶属机构</th>
						<th>上传状态</th>
						<th>书籍大小(字节)</th>
						<th>审核状态</th>
						<th>学科</th>
						<th>学段</th>
						<th>年级</th>
						<th>出版社</th>
		                <th>册别</th>
						<th>创建人</th>
						<th>备注</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id="bookTblBody">
					<%if (bookList.size() == 0) { %>
					<tr><td colspan="13">请选择条件搜索图书！</td></tr>
					<%} else { 
						SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
						for (RBook book : bookList) {
							PubOrg orgTmp = orgDao.find(book.getOrgId().toString());
							PubDdv subTmp = ddvDao.find(book.getSubjectId().toString());
							PubDdv stuTmp = ddvDao.find(book.getStuSegId().toString());
							PubDdv clsTmp = ddvDao.find(book.getClassId().toString());
							PubDdv kindTmp = ddvDao.find(book.getKindId().toString());
							PubPress psTmp = pressDao.find(book.getPressId().toString());
							SysStaff staffTmp = staffDao.find(book.getStaffId().toString());
							
							String isAudit = "";
							byte audit = book.getIsAudit();
							if (audit == (byte)-1) {
								isAudit = "制作中";
							} else if (audit == (byte)0) {
								isAudit = "审核中";
							} else if (audit == (byte)1) {
								isAudit = "待上架";
							} else if (audit == (byte)2) {
								isAudit = "已上架";
							} else if (audit == (byte)3) {
								isAudit = "已下架";
							}
					%>
					<tr>
						<td style="width:1%"><input type="checkbox" value="<%=book.getBookId()%>"/></td>
						<td><%=book.getName() %></td>
						<td><%=book.getBookNo() %></td>
						<td><%=orgTmp.getOrgName() %></td>
						<td><%if (book.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
						<td><%=book.getBeatifySize() %></td>
						<td><%=isAudit %></td>
						<td><%=subTmp.getValue() %></td>
						<td><%=stuTmp.getValue() %></td>
						<td><%=clsTmp.getValue() %></td>
						<td><%=psTmp.getName() %></td>
		                <td><%=kindTmp.getValue() %></td>
						<td><%=staffTmp.getName() %></td>
						<td><%=book.getNotes() %></td>
						<td>
							<security:phoenixSec purviewCode="BOOK_DETAIL">
							<a class="tip-top" title="详情" href="<%=ctx%>/book/viewBook.do?bookInfo.bookId=<%=book.getId()%>" ><i class="icon-eye-open"></i></a>
							</security:phoenixSec>
							<security:phoenixSec purviewCode="BOOK_SEARCH_DIR">
							<a class="tip-top" title="目录" href="<%=ctx%>/book/bookDireQuery.do?mode=-2&bookId=<%=book.getId()%>"><i class="icon-th-list"></i></a>
							</security:phoenixSec>
							<security:phoenixSec purviewCode="BOOK_SEARCH_RES">
							<a class="tip-top" title="资源" href="<%=ctx%>/book/bookResQuery.do?bookRes.bookId=<%=book.getId()%>&bookInfo.isAudit=-2"><i class="icon-file"></i></a>
							</security:phoenixSec>
							<%if (book.getIsUpload() == (byte)1) {%>
							<security:phoenixSec purviewCode="BOOK_DOWNLOAD">
							<a class="tip-top" title="下载" href="#" onclick="return downloadBook('<%=book.getAllAddrInNet()%>','<%=book.getAllAddrOutNet()%>','<%=schema%>','<%=inHost%>','<%=inHostPort%>','<%=outHost%>','<%=outHostPort%>','<%=resCtx%>')"><i class="icon-download-alt"></i></a>
							</security:phoenixSec>
							<%} %>
						</td>
					</tr>
					<%}
					}%>
				</tbody>
			</table>
			
			<div class="page_info" style="display:none">
				<div class="left_info">共有数据 423 条 每页20条 当前 1/22 页</div>
				<div class="page">
					<a href="#"> 首页 </a>&nbsp;<a href="#"> 上一页 </a> &nbsp;
					<select>
						<option>1</option>
						<option>2</option>
					</select> <a href="#"> 下一页 </a>&nbsp;<a href="#"> 尾页 </a>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function checkAll(which) {
	if (which.checked) {
		jQuery("#bookTblBody tr td input").attr("checked", "checked");
	} else {
		jQuery("#bookTblBody tr td input").removeAttr("checked", "checked");
	}
}

function editBookDire() {
	var checkedItems = jQuery("#bookTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/bookDireQuery.do?mode=-2&bookId=" + checkedItems[0].value;
}

function editBookRes() {
	var checkedItems = jQuery("#bookTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/bookResQuery.do?bookInfo.isAudit=-2&bookRes.bookId=" + checkedItems[0].value;
}

function viewBook() {
	var checkedItems = jQuery("#bookTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/viewBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

function downloadBook(inAddr,outAddr,schema,inHost,inHostPort,outHost,outHostPort,resCtx) {
	var isAvailable = false;
	if (outAddr != null) {
		var outURI = schema + "://" + outHost + ":" + outHostPort + "/" + resCtx + "/"; // "/" 后缀必须加上
		jQuery.ajax({
			url: outURI,
			type: "GET",
			timeout: 3000,
			async: false,
			headers: {Origin:"*"}, // used for cross domain access
			statusCode: {
				200: function() {
					isAvailable = true;
					window.location.href = outAddr;
				}
			}
		});
	}
	if (!isAvailable && inAddr != null) {
		var inURI = schema + "://" + inHost + ":" + inHostPort + "/" + resCtx + "/"; // "/" 后缀必须加上
		jQuery.ajax({
			url: inURI,
			type: "GET",
			timeout: 3000,
			async: false,
			headers: {Origin:"*"}, // used for cross domain access
			statusCode: {
				200: function() {
					window.location.href = inAddr;
				}
			}
		});
	}
	return false;
}

</script>

</html>
