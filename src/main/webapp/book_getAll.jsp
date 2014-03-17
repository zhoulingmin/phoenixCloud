<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%@page import="com.opensymphony.xwork2.util.ValueStack" %>
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

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
byte mode = (Byte)vs.findValue("bookInfo.isAudit");
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
					<input type="hidden" name="bookInfo.isAudit" value="<s:property value="bookInfo.isAudit"/>" >
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
				<%if (mode == (byte)-1) { %>
				<security:phoenixSec purviewCode="BOOK_ADD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addBook" onclick="addBook();" value="新建"/>
				</security:phoenixSec>
				<%} %>
				<security:phoenixSec purviewCode="BOOK_UPDATE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeBook" onclick="editBook();" value="修改"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_DELETE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeBook" onclick="removeBooks();" value="删除"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_UPLOAD_AFFIX">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="uploadBook" onclick="uploadBook();" value="上传附件"/>
				</security:phoenixSec>
				
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="editBookDire" onclick="editBookDire();" value="目录"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="editBookRes" onclick="editBookRes();" value="资源"/>
				<%if (mode == (byte)-1) { %>
				<security:phoenixSec purviewCode="BOOK_ADUIT_UP">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="commitBook" onclick="changeBookAuditStatus(0);" value="提交审核"/>
				</security:phoenixSec>
				<%} else if (mode == (byte)0) {%>
				<security:phoenixSec purviewCode="BOOK_ADUIT_OK">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="passBook" onclick="changeBookAuditStatus(1);" value="提交发布"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_ADUIT_NO">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="rejectBook" onclick="changeBookAuditStatus(-1);" value="打回重新制作"/>
				</security:phoenixSec>
				<%} else if (mode == (byte)1) { %>
				<security:phoenixSec purviewCode="BOOK_RELEASE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="releaseBook" onclick="changeBookAuditStatus(2);" value="发布"/>
				</security:phoenixSec>
				<%} %>
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
									<security:phoenixSec purviewCode="BOOK_UPLOAD_AFFIX">
									<%if (book.getIsUpload() == (byte)0) {%>
									<a class="tip-top" data-original-title="上传" href="<%=ctx%>/book/book_editBook.do?bookInfo.bookId=<%=book.getId()%>"><i class="icon-upload"></i></a>
									<%} %>
									</security:phoenixSec>
									<a class="tip-top" data-original-title="详情" href="<%=ctx%>/book/book_viewBook.do?bookInfo.bookId=<%=book.getId()%>" ><i class="icon-eye-open"></i></a>
									<security:phoenixSec purviewCode="BOOK_UPDATE">
									<a class="tip-top" data-original-title="修改" href="<%=ctx%>/book/book_editBook.do?bookInfo.bookId=<%=book.getId()%>"><i class="icon-edit"></i></a>
									</security:phoenixSec>
									<security:phoenixSec purviewCode="BOOK_DIR_UPDATE">
									<a class="tip-top" data-original-title="目录" href="<%=ctx%>/book/bookDire_getAll.do?mode=<%=mode %>&bookId=<%=book.getId()%>"><i class="icon-th-list"></i></a>
									</security:phoenixSec>
									<a class="tip-top" data-original-title="资源" href="<%=ctx%>/book/bookRes_getAll.do?bookRes.bookId=<%=book.getId()%>&bookInfo.isAudit=<%=mode%>"><i class="icon-file"></i></a>
									<security:phoenixSec purviewCode="BOOK_ADUIT_OK">
									<%if (book.getIsUpload() == (byte)1) {%>
									<a class="tip-top" data-original-title="下载" href="<%=ctx%>/book/book_download.do?bookInfo.bookId=<%=book.getId()%>"><i class="icon-download-alt"></i></a>
									<%} %>
									</security:phoenixSec>
									<%if (book.getIsAudit() == (byte)-1) { %>
									<security:phoenixSec purviewCode="BOOK_ADUIT_UP">
									<a name="commitBook" class="tip-top" data-original-title="提交审核" href="#"><i class="icon-arrow-up"></i></a>
									</security:phoenixSec>
									<%} else if (book.getIsAudit() == (byte)0) {%>
									<security:phoenixSec purviewCode="BOOK_ADUIT_OK">
									<a name="passBook" class="tip-top" data-original-title="提交发布" href="#"><i class="icon-ok-circle"></i></a>
									</security:phoenixSec>
									<security:phoenixSec purviewCode="BOOK_ADUIT_NO">
									<a name="rejectBook"class="tip-top" data-original-title="打回重新制作" href="#"><i class="icon-ban-circle"></i></a>
									</security:phoenixSec>
									<%} else if (book.getIsAudit() == (byte)1) { %>
									<security:phoenixSec purviewCode="BOOK_RELEASE">
									<a name="releaseBook" class="tip-top" data-original-title="发布" href="#"><i class=" icon-share-alt"></i></a>
									</security:phoenixSec>
									<%} %>
									<%if (Byte.toString(book.getIsAudit()).equals(mode)) { %>
									<security:phoenixSec purviewCode="BOOK_DELETE">
									<a name="removeBook" class="tip-top" data-original-title="删除" href="#"><i class="icon-remove"></i></a>
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
		</security:phoenixSec>
	</div>

	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function addBook() {
	window.location.href = "<%=ctx%>/addBook.jsp?isAudit=<s:property value="bookInfo.isAudit"/>";
}

function editBook() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_editBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

function uploadBook() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_editBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

function editBookDire() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/bookDire_getAll.do?mode=<%=mode %>&bookId=" + checkedItems[0].value;
}

function editBookRes() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		window.location.href = "<%=ctx%>/bookRes_getAll.jsp?mode=<%=mode%>";
		return;
	}
	window.location.href = "<%=ctx%>/book/bookRes_getAll.do?bookInfo.isAudit=<%=mode%>&bookRes.bookId=" + checkedItems[0].value;
}

function viewBook() {
	var checkedItems = jQuery("#bookContent tbody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一本书籍后重试！");
		return;
	}
	window.location.href = "<%=ctx%>/book/book_viewBook.do?bookInfo.bookId=" + checkedItems[0].value;
}

var chkItems = null;

function removeBooks() {

	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	
	var ids = "";
	chkItems = jQuery("#bookContent tbody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要删除的书籍！");
		return;
	}
	for (var i = 0; i < chkItems.length; i++) {
		ids += chkItems[i].value;
		if (i != (chkItems.length - 1)) {
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
			jQuery(chkItems).parents("tr").remove();
			chkItems = null;
		},
		error: function() {
			alert("删除失败！");
		}
	});
}

function changeBookAuditStatus(flag) {
	
	if (chkItems != null) {
		alert("网络繁忙，请稍后重试！");
		return;
	}
	
	var ids = "";
	chkItems = jQuery("#bookContent tbody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要操作的书籍！");
		return;
	}
	for (var i = 0; i < chkItems.length; i++) {
		ids += chkItems[i].value;
		if (i != (chkItems.length - 1)) {
			ids += ",";
		}
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/book/book_changeAuditStatus.do?flag=" + flag,
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {bookIdArr:ids},
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
		}
	});
}

jQuery(document).ready(function() {
	jQuery("a[name='removeBook']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/book_removeBook.do",
			type: "POST",
			async: "false",
			timeout: 30000,
			data: {bookIdArr: id},
			success: function() {
				alert("删除成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("删除失败！");
			}
		});
		return false;
	});
	
	jQuery("a[name='commitBook']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/book_changeAuditStatus.do?flag=0",
			type: "POST",
			async: "false",
			timeout: 30000,
			data:{bookIdArr: id},
			success: function() {
				alert("提交审核成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("提交审核失败！");
			}
		});
	});
	
	jQuery("a[name='passBook']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/book_changeAuditStatus.do?flag=1",
			type: "POST",
			async: "false",
			timeout: 30000,
			data:{bookIdArr: id},
			success: function() {
				alert("提交发布成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("提交发布失败！");
			}
		});
	});
	
	jQuery("a[name='rejectBook']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/book_changeAuditStatus.do?flag=-1",
			type: "POST",
			async: "false",
			timeout: 30000,
			data:{bookIdArr: id},
			success: function() {
				alert("打回继续制作成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("打回继续制作失败！");
			}
		});
	});
	
	jQuery("a[name='releaseBook']").on("click", function(e) {
		if (chkItems != null) {
			alert("网络繁忙，请稍后重试！");
			return;
		}
		chkItems = jQuery(this.parentNode.parentNode).find("input:first-child");
		var id = chkItems.val().toString();
		jQuery.ajax({
			url: "<%=ctx%>/book/book_changeAuditStatus.do?flag=2",
			type: "POST",
			async: "false",
			timeout: 30000,
			data:{bookIdArr: id},
			success: function() {
				alert("书籍发布成功！");
				jQuery(chkItems).parents("tr").remove();
				chkItems = null;
			},
			error: function() {
				alert("书籍发布失败！");
			}
		});
	});
});

</script>

</html>