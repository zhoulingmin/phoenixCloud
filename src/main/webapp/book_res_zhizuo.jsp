<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="sec"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.dao.res.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="java.util.*" %>

<%
String ctx = request.getContextPath();

SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getStaffId().toString());

RBook book = (RBook)request.getAttribute("book");
List<RBookRe> resList = (List<RBookRe>)request.getAttribute("resList");
if (resList == null) {
	resList = new ArrayList<RBookRe>();
}
RBookDao bookDao = (RBookDao)SpringUtils.getBean("RBookDao");
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);

%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />

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
			<img src="<%=ctx%>/image/home_icon.jpg">&nbsp;书籍查询&gt;首页
		</div>
	
		<div class="widget-box">
			<div class="widget-content">
				<form id="searchBook" action="<%=ctx %>/book/searchResNew.do" method="post">
					<input type="hidden" name="bookRes.isAudit" value="-1">
					<input type="hidden" name="bookInfo.isAudit" value="-1">
					起始页码:
					<input type="text" name="startPage" />
					结束页码:
					<input type="text" name="endPage" />
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn" value="搜索" type="submit" style="margin-bottom:10px;width:50px;"/>
				</form>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content">
				<security:phoenixSec purviewCode="BOOK_RES_ADD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addRes" onclick="addRes();" value="新建"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_UPDATE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="editRes" onclick="editRes();" value="修改"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_DELETE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeRes" onclick="removeRes();" value="删除"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_UPLOAD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="uploadRes" onclick="uploadRes();" value="上传资源附件"/>
				</security:phoenixSec>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="viewRes" onclick="viewRes();" value="详情"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="back" onclick="history.back();;" value="返回"/>
			</div>
		</div>

		<div class="widget-box" style="overflow:scroll">
			<table class="list_table" style="margin-top:0px">
				<thead>
					<tr>
						<th style="width:1%"><input type="checkbox" onchange="checkAll(this);"></th>
						<th>书名</th>
						<th>资源名称</th>
						<th>格式</th>
						<th>是否上传</th>
						<th>关联页码</th>
						<th>备注</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id="bookResTblBody">
					<%if (resList.size() == 0) { %>
					<tr><td colspan="8">请选择输入起始页码和结束页码，搜索本图书资源！</td></tr>
					<%} else { 
						SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
						RBookPageResDao pgRsdao = (RBookPageResDao)SpringUtils.getBean("RBookPageResDao");
						for (RBookRe res : resList) {
							PubDdv fmDdv = ddvDao.find(res.getFormat().toString());
							String relatedPages = pgRsdao.getResRelatedPages(new java.math.BigInteger(res.getId()));
							
					%>
					<tr>
						<td style="width:1%"><input type="checkbox" value="<%=res.getId()%>"/></td>
						<td><%=book.getName() %></td>
						<td><%=res.getName() %></td>
						<td><%=fmDdv.getValue() %></td>
						<td><%if (res.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
						<td><%=relatedPages %></td>
						<td><%=res.getNotes() %></td>
						<td>
							<%if (res.getIsUpload() == (byte)0) {%>
							<security:phoenixSec purviewCode="BOOK_RES_UPLOAD">
							<a class="tip-top" data-original-title="上传" href="#" onclick="return editResFromIcon(<%=res.getId()%>)"><i class="icon-upload"></i></a>
							</security:phoenixSec>
							<%} %>
							
							<a cla1ss="tip-top" data-original-title="详情" href="<%=ctx%>/book/bookRes_viewRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-eye-open"></i></a>
							
							<security:phoenixSec purviewCode="BOOK_RES_UPDATE">
							<a class="tip-top" data-original-title="修改" href="#" onclick="return editResFromIcon(<%=res.getId()%>)"><i class="icon-edit"></i></a>
							</security:phoenixSec>

							<%if (res.getIsUpload() == (byte)1) {%>
							<a class="tip-top" data-original-title="下载" href="<%=res.getAllAddr()%>"><i class="icon-download-alt"></i></a>
							<%} %>
							
							<security:phoenixSec purviewCode="BOOK_RES_DELETE">
							<a name="removeRes" class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
							</security:phoenixSec>
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


</script>

</html>
