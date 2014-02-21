<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.math.BigInteger" %>
<%@page import="com.phoenixcloud.util.*" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="java.util.Date" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String ctx = request.getContextPath();
RBook book = (RBook)request.getAttribute("book");

int maxLevel = (Integer)request.getAttribute("maxLevel");
JSONArray direArr = (JSONArray)request.getAttribute("direArr");

%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	
	<style type="text/css">
	#contextMenu {
	    position: absolute;
	    display:none;
	}
	table th,td{
	border: 1px solid #DADADA;
	width:10%;
	}
	th{
	text-align:left;
	}
	td p{ margin: 0;}
	</style>
	
	<title><%=book.getName()%>-书籍目录管理</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	
	<div id="contextMenu" class="dropdown clearfix">
	    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" style="display:block;position:absolute;margin-bottom:5px;">
	        <li><a tabindex="1" href="#">新建</a></li>
	        <li><a tabindex="3" href="#">删除</a></li>
	    </ul>
	</div>
	
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<div class="widget-box">
			<table style="border: 1px solid #AAAAAA;border-collapse: collapse;width:100%">
				<thead style="background:#EEEEEE;">
					<tr>
						<%for (int i = 0; i < (maxLevel+2); i++) { %>
						<th></th>
						<%} %>
						<th>描述</th>
						<th>开始页面</th>
						<th>结束页面</th>
					</tr>
				</thead>
				<tbody>
					<tr direId="0">
						<td><%=book.getName() %></td>
						<%for (int i = 0; i < (maxLevel+1); i++) {%>
						<td></td>
						<%} %>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<%!
					void showChildDire(JSONArray direArr, javax.servlet.jsp.JspWriter out, int maxLevel) throws java.io.IOException{
						for (int i = 0; i < direArr.size(); i++) {
							JSONObject obj = (JSONObject)direArr.get(i);
							int level = (Integer)obj.get("level");
							out.print("<tr direId=\"" + obj.get("direId") + "\" level=\"" + obj.get("level") + "\">");
							for (int j = 0; j < (level+1); j++) {
								out.print("<td></td>");
							}
							out.print("<td><input type='text' name='name' style='border:0;margin:0;padding:0' value='" + obj.get("name") + "'>" + "</td>");
							
							for (int k = 0; k < (maxLevel - level); k++) {
								out.print("<td></td>");
							}
							
							out.print("<td><input type='text' name='notes' style='border:0;margin:0;padding:0' value='" + obj.get("notes") + "'>" + "</td>");
							out.print("<td><input type='text' name='bPageNum' style='border:0;margin:0;padding:0' value='" + obj.get("bPageNum") + "'>" + "</td>");
							out.print("<td><input type='text' name='ePageNum' style='border:0;margin:0;padding:0' value='" + obj.get("ePageNum") + "'>" + "</td>");
							out.print("</tr>");
							
							JSONArray children = (JSONArray)obj.get("children");
							if (children != null) {
								showChildDire(children, out, maxLevel);
							}
						}
					}
					
					%>
					
					<%showChildDire(direArr, out, maxLevel); %>
					
				</tbody>
			</table>
			<br />
			<br />
			<br />
			<input style="float:right; margin-right:30px;" type="button" name="cancel" class="btn btn-primary" onclick="cancel();return false;" value="返回" />
			<input style="float:right; margin-right:30px;" class="btn btn-primary" type="button" name="update" onclick="updateDire();return false;" value="保存" />
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function cancel() {
	window.location.href = "<%=ctx%>/book/book_getAll.do";
}

var count = 0;
var updatedCount = 0;

function updateDire() {
	updatedCount = 0;
	count = jQuery("tbody tr[direId!='0']").length;
	jQuery("tbody tr[direId!='0']").each(function() {
		var direId = this.getAttribute("direId");
		var name = jQuery(this).find("input[name='name']")[0].value;
		var notes = jQuery(this).find("input[name='notes']")[0].value;
		var bPageNum = jQuery(this).find("input[name='bPageNum']")[0].value;
		var ePageNum = jQuery(this).find("input[name='ePageNum']")[0].value;
		jQuery.ajax({
			url: "<%=ctx%>/book/bookDire_saveDire.do",
			type: "POST",
			async: "true",
			data:  {
				"bookDire.direId": direId,
				"bookDire.name": name,
				"bookDire.notes": notes,
				"bookDire.bPageNum": bPageNum,
				"bookDire.ePageNum": ePageNum
			},
			timeout: 30000,
			success: function() {
			},
			error: function() {
				alert("保存书籍目录失败！");
			}
		});
	});
}

var $contextMenu = $("#contextMenu");
var $curDire;

// 初始化，手动初始化
// 初始化之后，开启异步加载
$(document).ready(function(){

	$("tbody tr").on("contextmenu", function(event) {
		$contextMenu.css({
			  display: "block",
			  left: event.clientX,
			  top: event.clientY
		});
		$curDire = this;
		return false;
	});
	
	$("td").on("click", function(event) {
		var inputChild = $(this).children("input");
		if (inputChild != null) {
			$(this).children("p").css("display", "none");
			$(this).children("input").css("display", "inline");
		}
	});
	
	
	$(document).click(function () {
	    $contextMenu.hide();
	});
	
	$("#contextMenu").on("click", "a", function(e) {
		var tabIndex = e.target.getAttribute("tabindex");
		switch (parseInt(tabIndex)) {
		case 1: // 新建
			var url = "<%=ctx%>/addBookDire.jsp?bookId=<%=book.getId()%>&parentId=" 
					+ $curDire.getAttribute("direId") + "&level=" + $curDire.getAttribute("level");
			var title = "创建书籍目录";
			var params = "height=470,width=635,top=" 
				+ (window.screen.availHeight - 30 - 470) / 2 
				+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
				+ ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
			window.open(url, title, params);
			break;
		case 2: // 删除
			jQuery.ajax({
				url: "<%=ctx%>/book/bookDire_removeDire.do",
				type: "post",
				async: "false",
				data: {bookId:"<%=book.getId()%>", direId:$curDire.getAttribute("direId")},
				timeout: 30000,
				success: function() {
					alert("删除书籍目录成功！");
					window.location.href = "<%=ctx%>/book/bookDire_getAll.do?bookId=<%=book.getId()%>"; 
				},
				error: function() {
					alert("删除书籍目录失败！");
				}
			});
			break;
		}
		$contextMenu.hide();
		return false;
	});
});

</script>

</html>