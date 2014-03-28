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

List<RBookRe> resList = (List<RBookRe>)request.getAttribute("resList");
if (resList == null) {
	resList = new ArrayList<RBookRe>();
}

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> subjectList = ddvDao.findByTblAndField("r_book", "SUBJECT_ID");
List<PubDdv> stuSegList = ddvDao.findByTblAndField("r_book", "STU_SEG_ID");
List<PubDdv> classList = ddvDao.findByTblAndField("r_book", "CLASS_ID");
PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);
List<PubPress> pressList = pressDao.getAll();


RBookDao bookDao = (RBookDao)SpringUtils.getBean("RBookDao");

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
select{
	width:100px;
}

</style>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx%>/image/home_icon.jpg">&nbsp;资源管理&gt;资源查询
		</div>
	
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				<form id="searchBook" action="<%=ctx %>/book/searchResNew.do" method="post">
					<input type="hidden" name="bookRes.isAudit" value="0">
					<input type="hidden" name="bookInfo.isAudit" value="-2">
					书名:
					<input type="text" name="bookInfo.name" />
					资源名:
					<input type="text" name="bookRes.name" />
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
			<div class="widget-content" style="white-space:nowrap;">
				<security:phoenixSec purviewCode="BOOK_RES_ADUIT_OK">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="passRes" onclick="changeBookAuditStatus(1);" value="提交发布"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_ADUIT_NO">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="rejectRes" onclick="changeBookAuditStatus(-1);" value="打回重新制作"/>
				</security:phoenixSec>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="viewRes" onclick="viewRes();" value="详情"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="back" onclick="history.back();;" value="返回"/>
			</div>
		</div>

		<div class="widget-box" style="overflow:scroll">
			<table class="list_table" style="margin-top:0px">
				<thead>
					<tr>
						<th style="width:1%"><input type="checkbox" onchange="checkAll(this);"/></th>
						<th>书名</th>
						<th>资源名称</th>
						<th>格式</th>
						<th>是否上传</th>
						<th>审核状态</th>
						<th>关联页码</th>
						<th>备注</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id="bookResTblBody">
					<%if (resList.size() == 0) { %>
					<tr><td colspan="8">请搜索图书资源！</td></tr>
					<%} else { 
						SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
						RBookPageResDao pgRsdao = (RBookPageResDao)SpringUtils.getBean("RBookPageResDao");
						for (RBookRe res : resList) {
							PubDdv fmDdv = ddvDao.find(res.getFormat().toString());
							String relatedPages = pgRsdao.getResRelatedPages(new java.math.BigInteger(res.getId()));
							RBook book = bookDao.find(res.getBookId().toString());
							
							String auditStatus = "";
							byte isAudit = res.getIsAudit();
							if (isAudit == (byte)-1) {
								auditStatus = "未审核";
							} else if (isAudit == (byte)0) {
								auditStatus = "待审核";
							} else if (isAudit == (byte)1) {
								auditStatus = "待上架";
							} else if (isAudit == (byte)2) {
								auditStatus = "已上架";
							} else if (isAudit == (byte)3) {
								auditStatus = "已下架";
							}
					%>
					<tr>
						<td style="width:1%"><input type="checkbox" value="<%=res.getId()%>"/></td>
						<td><%=book.getName() %></td>
						<td><%=res.getName() %></td>
						<td><%=fmDdv.getValue() %></td>
						<td><%if (res.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
						<td><%=auditStatus %></td>
						<td><%=relatedPages %></td>
						<td><%=res.getNotes() %></td>
						<td>
							<a cla1ss="tip-top" data-original-title="详情" href="<%=ctx%>/book/viewRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-eye-open"></i></a>
							<security:phoenixSec purviewCode="BOOK_RES_ADUIT_OK">
							<a name="passRes" class="tip-top" data-original-title="提交发布" href="#"><i class="icon-ok-circle"></i></a>
							</security:phoenixSec>
							<security:phoenixSec purviewCode="BOOK_RES_ADUIT_NO">
							<a name="rejectRes" class="tip-top" data-original-title="打回重新制作" href="#"><i class="icon-ban-circle"></i></a>
							</security:phoenixSec>
							<%if (res.getIsUpload() == (byte)1) {%>
							<a class="tip-top" data-original-title="下载" href="<%=res.getAllAddr()%>"><i class="icon-download-alt"></i></a>
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

function checkNum(which) {
	if (!jQuery.isNumberic(which.value)) {
		alert("页码必须为数字！");
		jQuery(this).focus();
	}
}

function viewRes() {
	var checkedItems = jQuery("#bookResTblBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一个资源后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/viewRes.do?bookRes.resId=" + checkedItems[0].value;
}


function checkAll(which) {
	if (which.checked) {
		jQuery("#bookResTblBody tr td input").attr("checked", "checked");
	} else {
		jQuery("#bookResTblBody tr td input").removeAttr("checked", "checked");
	}
}

var chkItems = null;
function changeBookAuditStatus(flag) {
	
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
		url: "<%=ctx%>/book/bookRes_changeAuditStatus.do?flag=" + flag,
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {resIdArr:ids},
		success: function() {
			if (flag == 1) {
				alert("提交上架成功！");
			} else if (flag == -1) {
				alert("打回重新制作成功！");
			}
			jQuery(chkItems).parents("tr").remove();
			chkItems = null;
		},
		error: function() {
			if (flag == 1) {
				alert("提交上架失败！");
			} else if (flag == -1) {
				alert("打回继续制作失败！");
			}
			chkItems = null;
		}
	});
}

jQuery(document).ready(function() {
	<security:phoenixSec purviewCode="BOOK_RES_ADUIT_OK">
	jQuery("a[name='passRes']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/bookRes_changeAuditStatus.do?flag=1",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {resIdArr: id},
			success: function() {
				alert("提交发布成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("提交发布失败！");
				chkItems = null;
			}
		});
		return false;
	});
	</security:phoenixSec>
	<security:phoenixSec purviewCode="BOOK_RES_ADUIT_NO">
	jQuery("a[name='rejectRes']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/bookRes_changeAuditStatus.do?flag=-1",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {resIdArr: id},
			success: function() {
				alert("打回重新制作成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("打回重新制作失败！");
				chkItems = null;
			}
		});
		return false;
	});
	</security:phoenixSec>
});

</script>

</html>
