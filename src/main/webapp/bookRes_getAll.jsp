<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@taglib  uri="/WEB-INF/security.tld" prefix="security"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();

RBook book = (RBook)request.getAttribute("book");
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


String mode = request.getParameter("mode");
if (mode == null || mode.trim().length() == 0) {
	mode = request.getParameter("bookInfo.isAudit");
}

RBookDao bookDao = (RBookDao)SpringUtils.getBean("RBookDao");

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
				<form id="searchBook" action="<%=ctx %>/book/searchRes.do" method="post">
					<input type="hidden" name="bookRes.isAudit" value="-2">
					<input type="hidden" name="bookInfo.isAudit" value="<%=mode%>">
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
			<div class="widget-content">
				
				<%if (book != null) { %>
				<security:phoenixSec purviewCode="BOOK_RES_ADD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addRes" onclick="addRes();" value="新建"/>
				</security:phoenixSec>
				<%} %>
				<security:phoenixSec purviewCode="BOOK_RES_UPDATE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="editRes" onclick="editRes();" value="修改"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_DELETE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeRes" onclick="removeRes();" value="删除"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_UPLOAD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="uploadRes" onclick="uploadRes();" value="上传资源附件"/>
				</security:phoenixSec>

				<%if ("-1".equals(mode)) { %>
				<security:phoenixSec purviewCode="BOOK_RES_ADUIT_UP">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="commitRes" onclick="changeBookAuditStatus(0);" value="提交审核"/>
				</security:phoenixSec>
				<%} else if ("0".equals(mode)) { %>
				<security:phoenixSec purviewCode="BOOK_RES_ADUIT_OK">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="passRes" onclick="changeBookAuditStatus(1);" value="提交发布"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_ADUIT_NO">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="rejectRes" onclick="changeBookAuditStatus(-1);" value="打回重新制作"/>
				</security:phoenixSec>
				<%} else if ("1".equals(mode)) { %>
				<security:phoenixSec purviewCode="BOOK_RES_RELEASE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="releaseRes" onclick="changeBookAuditStatus(2);" value="发布"/>
				</security:phoenixSec>
				<%} %>
				
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="viewRes" onclick="viewRes();" value="详情"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="back" onclick="history.back();" value="返回"/>
			</div>
		</div>

		<div><!-- this div node is just used to let $(this).parents('.widget-box') find only one node -->
			<div class="widget-box">
				<div class="widget-title">
					<span class="icon"><i class="icon-eye-open"></i></span>
					<h5>资源列表</h5>
				</div>
				<div class="widget-content nopadding">
					<table id="resContent" class="table table-bordered data-table">
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
								RBook bookTmp = bookDao.find(res.getBookId().toString());
								String format = "";
								PubDdv ddv = ddvDao.find(res.getFormat().toString());
								if (ddv != null) {
									format = ddv.getValue();
								}
								
								String auditStatus = "";
								if (res.getIsAudit() == (byte)-1) {
									auditStatus = "制作中";
								} else if (res.getIsAudit() == (byte)0) {
									auditStatus = "待审核";
								} else if (res.getIsAudit() == (byte)1) {
									auditStatus = "待发布";
								} else if (res.getIsAudit() == (byte)2) {
									auditStatus = "已发布";
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
								<td><%=bookTmp.getName() %></td>
								<td><a href="<%=ctx%>/book/bookRes_viewRes.do?bookRes.resId=<%=res.getId()%>"><%=res.getName() %></a></td>
								<td><%=format %></td>
								<td><%if (res.getIsUpload() == (byte)0) { %>未上传<%} else { %>已上传<%} %></td>
								<td><%=createTime%></td>
								<td><%=updateTime%></td>
								<td><%=auditStatus %></td>
								<td><%=res.getNotes() %></td>
								<td>
									<%if (Byte.toString(res.getIsAudit()).equals(mode) && res.getIsUpload() == (byte)0) {%>
									<security:phoenixSec purviewCode="BOOK_RES_UPLOAD">
									<a class="tip-top" data-original-title="上传" href="#" onclick="return editResFromIcon(<%=res.getId()%>)"><i class="icon-upload"></i></a>
									</security:phoenixSec>
									<%} %>
									<a class="tip-top" data-original-title="详情" href="<%=ctx%>/book/bookRes_viewRes.do?bookRes.resId=<%=res.getId()%>"><i class="icon-eye-open"></i></a>
									<%if (Byte.toString(res.getIsAudit()).equals(mode)) {%>
									<security:phoenixSec purviewCode="BOOK_RES_UPDATE">
									<a class="tip-top" data-original-title="修改" href="#" onclick="return editResFromIcon(<%=res.getId()%>)"><i class="icon-edit"></i></a>
									</security:phoenixSec>
									<%} %>
									<%if (res.getIsUpload() == (byte)1) {%>
									<a class="tip-top" data-original-title="下载" href="<%=ctx%>/book/bookRes_download.do?bookRes.resId=<%=res.getId()%>"><i class="icon-download-alt"></i></a>
									<%} %>
									
									<%if (res.getIsAudit() == (byte)-1 && "-1".equals(mode)) {%>
									<security:phoenixSec purviewCode="BOOK_RES_ADUIT_UP">
									<a name="commitRes" class="tip-top" data-original-title="提交审核" href="#"><i class="icon-ok-circle"></i></a>
									</security:phoenixSec>
									<%} else if (res.getIsAudit() == (byte)0 && "0".equals(mode)){ %>
									<security:phoenixSec purviewCode="BOOK_RES_ADUIT_OK">
									<a name="passRes" class="tip-top" data-original-title="提交发布" href="#"><i class="icon-ok-circle"></i></a>
									</security:phoenixSec>
									<security:phoenixSec purviewCode="BOOK_RES_ADUIT_NO">
									<a name="rejectRes" class="tip-top" data-original-title="打回重新制作" href="#"><i class="icon-ban-circle"></i></a>
									</security:phoenixSec>
									<%} else if (res.getIsAudit() == (byte)1 && "1".equals(mode)) { %>
									<security:phoenixSec purviewCode="BOOK_RES_RELEASE">
									<a name="releaseRes" class="tip-top" data-original-title="发布" href="#"><i class="icon-ok-circle"></i></a>
									</security:phoenixSec>
									<%} %>
									<%if (Byte.toString(res.getIsAudit()).equals(mode)) {%>
									<security:phoenixSec purviewCode="BOOK_RES_DELETE">
									<a name="removeRes" class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
									</security:phoenixSec>
									<%} %>
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
<%if (book != null){%>
function batchUploadRes() {
	var checkedItems = jQuery("#resContent tbody").find("input:checked");
	if (checkedItems != null && checkedItems.length > 1) {
		alert("请只选择一个资源后，再批量上传子资源！");
		return;
	}
	var parentId = 0;
	if (checkedItems != null && checkedItems.length == 1) {
		parentId = checkedItems[0].value;
	}
	var url = "<%=ctx%>/bookRes_batchUpload.jsp?bookId=<%=book.getBookId()%>&parentId=" + parentId;
	var title = "批量上传书籍资源";
	var params = "height=400,width=635,top=" 
		+ (window.screen.availHeight - 30 - 400) / 2 
		+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
		+ ",toolbar=no,menubar=no,location=no";
	window.open(url, title, params);
}

function addRes() {
	var checkedItems = jQuery("#resContent tbody").find("input:checked");
	if (checkedItems != null && checkedItems.length > 1) {
		alert("请只选择一个资源后，创建子资源！");
		return;
	}
	var parentId = 0;
	if (checkedItems != null && checkedItems.length == 1) {
		parentId = checkedItems[0].value;
	}
	var url = "<%=ctx%>/addRes.jsp?mode=<%=mode%>&bookId=<%=book.getBookId()%>&parentId=" + parentId;
	var title = "创建书籍资源";
	var params = "height=400,width=635,top=" 
		+ (window.screen.availHeight - 30 - 400) / 2 
		+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
		+ ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open(url, title, params);
}
<%}%>
function editRes() {
	var checkedItems = jQuery("#resContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一个资源后重试！");
		return;
	}
	
	var url = "<%=ctx%>/book/bookRes_editRes.do?bookRes.resId=" + checkedItems[0].value;
	var title = "修改书籍资源";
	var params = "height=470,width=635,top=" 
		+ (window.screen.availHeight - 30 - 470) / 2 
		+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
		+ ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open(url, title, params);
}

function editResFromIcon(resId) {
	var url = "<%=ctx%>/book/bookRes_editRes.do?bookRes.resId=" + resId;
	var title = "修改书籍资源";
	var params = "height=470,width=635,top=" 
		+ (window.screen.availHeight - 30 - 470) / 2 
		+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
		+ ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open(url, title, params);
	return false;
}

function uploadRes() {
	var checkedItems = jQuery("#resContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		<%if (book == null){%>
		alert("请选择一个资源后重试！");
		<%} else {%>
		batchUploadRes();
		<%}%>
		return;
	}
	
	var url = "<%=ctx%>/book/bookRes_editRes.do?bookRes.resId=" + checkedItems[0].value;
	var title = "修改书籍资源";
	var params = "height=400,width=635,top=" 
		+ (window.screen.availHeight - 30 - 400) / 2 
		+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
		+ ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open(url, title, params);
}

function viewRes() {
	var checkedItems = jQuery("#resContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一个资源后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/bookRes_viewRes.do?bookRes.resId=" + checkedItems[0].value;
}

var chkItems = null;
<security:phoenixSec purviewCode="BOOK_RES_DELETE">
function removeRes() {
	
	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	
	var ids = "";
	var chkItems = jQuery("#resContent tbody").find("input:checked");
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
function changeBookAuditStatus(flag) {
	
	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	
	var ids = "";
	chkItems = jQuery("#bookContent tbody").find("input:checked");
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
			if (flag == 0) {
				alert("提交审核成功！");
			} else if (flag == 1) {
				alert("提交发布成功！");
			} else if (flag == -1) {
				alert("打回重新制作成功！");
			} else if (flag == 2) {
				alert("书籍发布成功！");
			}
			
			jQuery(chkItems).parents("tr").remove();
			chkItems = null;
		},
		error: function() {
			if (flag == 0) {
				alert("提交审核失败！");
			} else if (flag == 1) {
				alert("提交发布失败！");
			} else if (flag == -1) {
				alert("打回继续制作失败！");
			} else if (flag == 2) {
				alert("书籍发布失败！");
			}
			chkItems = null;
		}
	});
}

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
	<%if ("-1".equals(mode)) {%>
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
	<%} else if ("0".equals(mode)) {%>
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
	<%} else if ("1".equals(mode)) {%>
	jQuery("a[name='releaseRes']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/bookRes_changeAuditStatus.do?flag=2",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {resIdArr: id},
			success: function() {
				alert("发布成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("发布失败！");
				chkItems = null;
			}
		});
		return false;
	});
	<%}%>
});

</script>

</html>