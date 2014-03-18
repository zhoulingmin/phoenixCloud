<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="com.phoenixcloud.dao.ctrl.*" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();

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
	<link rel="stylesheet" href="<%=ctx%>/css/select2.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/select2.min.js"></script>

	<style type="text/css">
	table th,td{
	border: 1px solid #DADADA;
	width:10%;
	}
	th{
	text-align:left;
	}
	</style>
	
<title>书籍注册码管理</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		
		<div class="widget-content">
			<div class="span6" style="margin-left: 0px;">
				<div class="widget-box">
					<div class="widget-title">
						<span class="icon"><i class="icon-list-alt"></i></span>
						<h5>书籍列表</h5>
					</div>
					<div class="widget-content">
						<form id="searchBook" method="post" action="/phoenixCloud/book/searchBook.do?dataType=JSON">
						<input type="hidden" name="bookInfo.isAudit" value="2" >
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
						&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn" value="搜索" onclick="searchBook();" type="button" style="margin-bottom:10px;width:50px;"/>
						</form>
					</div>
					<table id="bookTbl">
						<thead>
							<tr>
								<th style="width:1%"><input style="width: 3px;" type="checkbox" id="bookTitleChker" onclick="checkAllBook(this)"></th>
								<th>书名</th>
								<th>书籍编码</th>
								<th>隶属机构</th>
								<th>学段</th>
								<th>年级</th>
								<th>学科</th>
								<th>出版社</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody id="bookTblBody">
							<tr><td colspan="9">请先搜索书籍！</td></tr>
						</tbody>
					</table>
				</div>
			</div> 
			
			<div class="span3" style="width:130px">
				<br>
				<br>
				<input class="btn" type="button" onclick="batchGenRegCode()" value="批量添加">
				&nbsp;<input id="codeNum" type="text" value="5" style="width: 20px; padding-bottom: 4px; margin-bottom: 0px;">
				<br>
				<br>
				<input class="btn" type="button" onclick="queryRegCode()" value="查询">
				<br>
				<br>
				<input class="btn" type="button" onclick="batchDelRegCode()" value="批量删除">
			</div>
			
			<div class="span6" style="width:400px">
				<div class="widget-box">
					<div class="widget-title">
						<span class="icon"><i class="icon-list-alt"></i></span>
						<h5>注册码列表</h5>
					</div>
					<div class="widget-content nopadding">
					<table id="regCodeTbl">
						<thead>
							<tr>
								<th style="width:1%"><input style="width: 3px;" type="checkbox" onclick="checkAllRegCode(this)"></th>
								<th>书名</th>
								<th>注册码</th>
								<th>有效期</th>
								<th>关联账号</th>
							</tr>
						</thead>
						<tbody id="regCodeTblBody">
							<tr><td colspan="9">请先搜索书籍！</td></tr>
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

var delItems = null;

function batchDelRegCode() {

	var delItems = jQuery("#regCodeTblBody").find("input:checked");
	if (delItems == null || delItems.length == 0) {
		alert("请选择要删除的注册码！");
		delItems = null;
		return;
	}
	
	var ids = "";
	jQuery(delItems).each(function() {
		ids += this.id.substring("regCode_".length) + ",";
	});
	if (ids.length > 0) {
		ids = ids.substr(0, ids.length - 1);
	}
	
	jQuery.ajax({
		type: "post",
		url: "<%=ctx%>/book/bookRegCode_batchDelRegcode.do",
		data:{regCodeIdArr:ids},
		dataType: "JSON",
		timeout: 30000,
		async: true,
		success: function(delArr) {
			if (delArr.length == 0) {
				alert("无法删除注册码！");
			} else {
				alert("删除注册码成功！");
			}
			jQuery(delArr).each(function() {
				jQuery("#regCode_" + this).parents("tr").remove();
			});			
		},
		error: function(XMLReq, txt) {
			if (txt != null) {
				alert(txt);
			} else {
				alert("删除注册码出错！");
			}
		}
	});
}

function queryRegCode() {
	var chkItems = jQuery("#bookTblBody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要查询注册码的书籍！");
		return;
	}
	
	var ids = "";
	jQuery(chkItems).each(function() {
		ids += this.id.substring("book_".length) + ",";
	});
	if (ids.length > 0) {
		ids = ids.substr(0, ids.length - 1);
	}
	
	jQuery.ajax({
		type: "post",
		url: "<%=ctx%>/book/bookRegCode_queryRegcode.do",
		data:{bookIdArr:ids},
		dataType: "JSON",
		timeout: 30000,
		async: true,
		success: function(regCodeArr) {
			if (regCodeArr == null) {
				alert("查询注册码出错！");
				return;
			}
			jQuery("#regCodeTbl thead").find("input:checkbox").removeAttr("checked");
			jQuery("#regCodeTblBody").children().remove();
			jQuery(regCodeArr).each(function(idx) {
				var trElm = "<tr><td style='width:1%;'><input style='width:3px;' type='checkbox' id='regCode_" + this.regCodeId + "'></td>";
				trElm += "<td>" + this.bookName + "</td>";
				trElm += "<td>" + this.code + "</td>";
				trElm += "<td>" + this.validDate + "</td>";
				trElm += "<td>" + this.staffName + "</td>";
				trElm += "</tr>";
				jQuery("#regCodeTblBody").append(trElm);
			});
		},
		error: function(XMLReq, txt) {
			if (txt != null) {
				alert(txt);
			} else {
				alert("查询注册码出错！");
			}
		}
	});
}

function batchGenRegCode() {
	
	var chkItems = jQuery("#bookTblBody").find("input:checked");
	if (chkItems == null || chkItems.length == 0) {
		alert("请选择要生成注册码的书籍！");
		return;
	}
	
	if (!jQuery.isNumeric(jQuery("#codeNum").val())) {
		alert("请输入要创建注册码的数目！");
		jQuery("#codeNum").focus();
		return;
	}
	
	var num = parseInt(jQuery("#codeNum").val());
	if (num < 1) {
		alert("请输入大于0的数字！");
		jQuery("#codeNum").focus();
		return;
	}
	var ids = "";
	jQuery(chkItems).each(function() {
		ids += this.id.substring("book_".length) + ",";
	});
	if (ids.length > 0) {
		ids = ids.substr(0, ids.length - 1);
	}
	
	jQuery.ajax({
		type: "post",
		url: "<%=ctx%>/book/bookRegCode_batchGenRegCode.do",
		data:{num:num, bookIdArr:ids},
		dataType: "JSON",
		timeout: 30000,
		async: true,
		success: function(regCodeArr) {
			if (regCodeArr == null) {
				alert("生成注册码出错！");
				return;
			}
			jQuery("#regCodeTbl thead").find("input:checkbox").removeAttr("checked");
			jQuery("#regCodeTblBody").children().remove();
			jQuery(regCodeArr).each(function(idx) {
				var trElm = "<tr><td style='width:1%;'><input style='width:3px;' type='checkbox' id='regCode_" + this.regCodeId + "'></td>";
				trElm += "<td>" + this.bookName + "</td>";
				trElm += "<td>" + this.code + "</td>";
				trElm += "<td>" + this.validDate + "</td>";
				trElm += "<td>" + this.staffName + "</td>";
				trElm += "</tr>";
				jQuery("#regCodeTblBody").append(trElm);
			});
		},
		error: function(XMLReq, txt) {
			if (txt != null) {
				alert(txt);
			} else {
				alert("生成注册码出错！");
			}
		}
	});
}

function checkAllBook(which) {
	if (!which.checked) {
		jQuery(which).removeAttr("checked");
		jQuery("#bookTblBody").find("input:checkbox").removeAttr("checked");
	} else {
		jQuery(which).attr("checked", "checked");
		jQuery("#bookTblBody").find("input:checkbox").attr("checked", "checked");
	}
}

function checkAllRegCode(which) {
	if (!which.checked) {
		jQuery(which).removeAttr("checked");
		jQuery("#regCodeTblBody").find("input:checkbox").removeAttr("checked");
	} else {
		jQuery(which).attr("checked", "checked");
		jQuery("#regCodeTblBody").find("input:checkbox").attr("checked", "checked");
	}
}

function searchBook() {
	jQuery.ajax({
		url: "<%=ctx%>/book/searchBook.do?dataType=JSON",
		type: "POST",
		dataType: "JSON",
		data: jQuery("#searchBook").serialize(),
		timeout: 30000,
		async: true,
		success: function(bookArr) {
			if (bookArr == null) {
				alert("搜索书籍失败！");
				return;
			}
			jQuery("#bookTblBody").children().remove();
			jQuery("#bookTbl thead").find("input:checkbox").removeAttr("checked");
			jQuery(bookArr).each(function(idx) {
				var trElm = "<tr><td style='width:1%;'><input style='width:3px;' type='checkbox' id='book_" + this.bookId + "'></td>";
				trElm += "<td>" + this.name + "</td>";
				trElm += "<td>" + this.bookNo + "</td>";
				trElm += "<td>" + this.orgName + "</td>";
				trElm += "<td>" + this.stu + "</td>";
				trElm += "<td>" + this.cls + "</td>";
				trElm += "<td>" + this.kind + "</td>";
				trElm += "<td>" + this.press + "</td>";
				trElm += "<td>" + this.notes + "</td>";
				trElm += "</tr>";
				
				jQuery("#bookTblBody").append(trElm);
			});
		},
		error: function(XMLReq, txt) {
			if(txt != null) {
				alert(txt);
			} else {
				alert("搜索书籍失败！");
			}
		}
	});
}

</script>

</html>