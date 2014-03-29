<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
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
			<img src="<%=ctx%>/image/home_icon.jpg">&nbsp;书籍查询&gt;首页
		</div>
	
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				<form id="searchBook" action="<%=ctx %>/book/searchResByPages.do" method="post">
					<input type="hidden" name="bookRes.bookId" value="<%=book.getId()%>">
					<input type="hidden" name="bookRes.isAudit" value="-1">
					<input type="hidden" name="bookInfo.isAudit" value="-1">
					起始页码:
					<input type="text" name="start" value="0" onchange="checkNum(this)"/>
					结束页码:
					<input type="text" name="end" value="<%=book.getPageNum()%>" onchange="checkNum(this)"/>
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn" value="搜索" type="submit" style="margin-bottom:10px;width:50px;"/>
				</form>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
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
				<security:phoenixSec purviewCode="BOOK_RES_ADUIT_UP">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="commitRes" onclick="commitRes();" value="提交审核"/>
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
							<a class="tip-top" data-original-title="上传" href="<%=ctx%>/book/modifyBookRes.do?mode=-1&bookRes.resId=<%=res.getId()%>"><i class="icon-upload"></i></a>
							</security:phoenixSec>
							<%} %>
							
							<a cla1ss="tip-top" data-original-title="详情" href="<%=ctx%>/book/viewRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-eye-open"></i></a>
							
							<security:phoenixSec purviewCode="BOOK_RES_UPDATE">
							<a class="tip-top" data-original-title="修改" href="<%=ctx%>/book/modifyBookRes.do?mode=-1&bookRes.resId=<%=res.getId()%>" ><i class="icon-edit"></i></a>
							</security:phoenixSec>

							<%if (res.getIsUpload() == (byte)1) {%>
							<a class="tip-top" data-original-title="下载" href="<%=res.getAllAddr()%>"><i class="icon-download-alt"></i></a>
							<%} %>
							
							<security:phoenixSec purviewCode="BOOK_RES_ADUIT_UP">
							<a name="commitRes" class="tip-top" data-original-title="提交审核" href="#"><i class="icon-arrow-up"></i></a>
							</security:phoenixSec>
							
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

function checkNum(which) {
	if (!jQuery.isNumeric(which.value)) {
		alert("页码必须为数字！");
		jQuery(this).focus();
	}
}

function checkAll(which) {
	if (which.checked) {
		jQuery("#bookResTblBody tr td input").attr("checked", "checked");
	} else {
		jQuery("#bookResTblBody tr td input").removeAttr("checked", "checked");
	}
}

function batchUploadRes() {
	var checkedItems = jQuery("#bookResTblBody").find("input:checked");
	if (checkedItems != null && checkedItems.length > 1) {
		alert("请只选择一个资源后，再批量上传子资源！");
		return;
	}
	var parentId = 0;
	if (checkedItems != null && checkedItems.length == 1) {
		parentId = checkedItems[0].value;
	}
	window.location.href = "<%=ctx%>/book_res_batchUpload.jsp?mode=<%=book.getIsAudit()%>&bookId=<%=book.getBookId()%>&parentId=" + parentId;
}

function addRes() {
	var checkedItems = jQuery("#bookResTblBody").find("input:checked");
	if (checkedItems != null && checkedItems.length > 1) {
		alert("请只选择一个资源后，创建子资源！");
		return;
	}
	var parentId = 0;
	if (checkedItems != null && checkedItems.length == 1) {
		parentId = checkedItems[0].value;
	}
	window.location.href = "<%=ctx%>/book_res_add.jsp?mode=-1&bookId=<%=book.getBookId()%>&parentId=" + parentId;
}

function editRes() {
	var checkedItems = jQuery("#bookResTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一个资源后重试！");
		return;
	}
	
	window.location.href = "<%=ctx%>/book/modifyBookRes.do?mode=-1&bookRes.resId=" + checkedItems[0].value;
}

function uploadRes() {
	var checkedItems = jQuery("#bookResTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		batchUploadRes();
		return;
	}
	
	window.location.href = "<%=ctx%>/book/modifyBookRes.do?mode=-1&bookRes.resId=" + checkedItems[0].value;
}

function viewRes() {
	var checkedItems = jQuery("#bookResTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一个资源后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/viewRes.do?bookRes.resId=" + checkedItems[0].value;
}

var chkItems = null;
<security:phoenixSec purviewCode="BOOK_RES_DELETE">
function removeRes() {
	
	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	
	var ids = "";
	var chkItems = jQuery("#bookResTblBody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要删除的资源！");
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
		url: "<%=ctx%>/book/bookRes_removeRes.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {resIdArr:ids},
		success: function() {
			alert("删除成功！");
			if (ret == null) {
				alert("操作失败！");
				return;
			}
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

<security:phoenixSec purviewCode="BOOK_RES_ADUIT_UP">
function commitRes() {
	
	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	
	var ids = "";
	chkItems = jQuery("#bookResTblBody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要操作的资源！");
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
		url: "<%=ctx%>/book/bookRes_changeAuditStatus.do?flag=0",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {resIdArr:ids},
		success: function() {
			alert("提交审核成功！");
			jQuery(chkItems).parents("tr").remove();
			chkItems = null;
		},
		error: function() {
			alert("提交审核失败！");
			chkItems = null;
		}
	});
}
</security:phoenixSec>

jQuery(document).ready(function() {
	<security:phoenixSec purviewCode="BOOK_RES_DELETE">
	jQuery("a[name='removeRes']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/bookRes_removeRes.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {resIdArr: id},
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
	<security:phoenixSec purviewCode="BOOK_RES_ADUIT_UP">
	jQuery("a[name='commitRes']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/bookRes_changeAuditStatus.do?flag=0",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {resIdArr: id},
			success: function() {
				alert("提交审核成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("提交审核失败！");
				chkItems = null;
			}
		});
		return false;
	});
	</security:phoenixSec>
});

</script>

</html>
