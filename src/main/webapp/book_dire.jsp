<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@page import="java.util.Date" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>

<%
ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff curStaff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(curStaff.getOrgId().toString());
RBook book = (RBook)request.getAttribute("book");
int maxLevel = (Integer)request.getAttribute("maxLevel");
JSONArray direArr = (JSONArray)request.getAttribute("direArr");

String ctx = request.getContextPath();
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
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />

<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>

<style type="text/css">
#contextMenu {
    position: absolute;
    display:none;
}
table th,td{
border: 1px solid #DADADA;
width:20%;
}
th{
text-align:left;
}
td p{ margin: 0;}
td input{width:106px;}
</style>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div id="contextMenu" class="dropdown clearfix">
	    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" style="display:block;position:absolute;margin-bottom:5px;">
	    	<security:phoenixSec purviewCode="BOOK_EDIT_DIR">
	        <li><a tabindex="1" href="#">新建</a></li>
	        <li><a tabindex="2" href="#">删除</a></li>
	        </security:phoenixSec>
	    </ul>
	</div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍制作&gt;书籍目录
		</div>
		
		<div class="widget-box">
			<table style="border: 1px solid #AAAAAA;border-collapse: collapse;width:80%">
				<thead style="background:#EEEEEE;">
					<tr>
						<%for (int i = 0; i < (maxLevel+2); i++) { %>
						<th></th>
						<%} %>
						<th>开始页面</th>
						<th>结束页面</th>
						<th>描述</th>
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
							
							out.print("<td><input type='text' name='bPageNum' style='border:0;margin:0;padding:0' value='" + obj.get("bPageNum") + "'>" + "</td>");
							out.print("<td><input type='text' name='ePageNum' style='border:0;margin:0;padding:0' value='" + obj.get("ePageNum") + "'>" + "</td>");
							out.print("<td><input type='text' name='notes' style='border:0;margin:0;padding:0' value='" + obj.get("notes") + "'>" + "</td>");
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
			<input style="float:right; margin-right:30px;" type="button" name="cancel" class="btn btn-primary" onclick="history.back();return false;" value="返回" />
			<security:phoenixSec purviewCode="BOOK_EDIT_DIR">
			<input style="float:right; margin-right:30px;" class="btn btn-primary" type="button" name="update" onclick="updateDire();return false;" value="保存" />
			</security:phoenixSec>
		</div>

	</div>
</body>

<script type="text/javascript">

var count = 0;
var updatedCount = 0;
var isAjax = false;
var timerCheck;

function updateDire() {
	if (isAjax) {
		alert("正在保存，请稍后重试！");
		return;
	}
	if (jQuery("tbody tr[direId!='0']").length > 0) {
		isAjax = true;
	}
	updatedCount = 0;
	count = jQuery("tbody tr[direId!='0']").length;
	jQuery("tbody tr[direId!='0']").each(function() {
		if (!isAjax) {
			isAjax = true;
			timerCheck = setTimeout(function() {
				if (updatedCount != count) {
					alert("保存书籍目录失败！");
				} else {
					alert("保存书籍目录成功！");
				}
				isAjax = false;
			}, count * 30 * 1000);
		}
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
				updatedCount++;
				if (updatedCount == count) {
					alert("保存书籍目录成功！");
					clearTimeout(timerCheck);
					isAjax = false;
				}
			},
			error: function() {
				isAjax = false;
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
	<security:phoenixSec purviewCode="BOOK_EDIT_DIR">
	$("tbody tr").on("contextmenu", function(event) {
		var index = jQuery(this).index();
		if (index == 1 || index == 2) { // 封面及目录节点 不可以删除
			return false;
		}
		if (index == 0) {
			$contextMenu.find("li:eq(1)").css("display", "none");
		} else {
			$contextMenu.find("li:eq(1)").css("display", "inline");
		}
		$contextMenu.css({
			  display: "block",
			  left: event.clientX,
			  top: event.clientY
		});
		$curDire = this;
		return false;
	});
	</security:phoenixSec>
	
	$("tbody tr:eq(1) td:eq(1)").html($("tbody tr:eq(1) td:eq(1) input:eq(0)").val());
	$("tbody tr:eq(2) td:eq(1)").html($("tbody tr:eq(2) td:eq(1) input:eq(0)").val());
	
	$("tbody tr").on("mouseover", function(event) {
		$(this).attr("bgcolor", "#E6E6FA");
	});
	
	$("tbody tr").on("mouseout", function(event) {
		$(this).removeAttr("bgcolor");
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
			window.location.href = "<%=ctx%>/book_dire_add.jsp?bookId=<%=book.getId()%>&parentId=" 
					+ $curDire.getAttribute("direId") + "&level=" + $curDire.getAttribute("level");
			//var title = "创建书籍目录";
			//var params = "height=245,width=635,top=" 
				//+ (window.screen.availHeight - 30 - 245) / 2 
				//+ ",left=" + (window.screen.availWidth - 10 - 635) / 2;
				//+ ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
			//window.open(url, title, params);
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
					window.location.href = "<%=ctx%>/book/bookDire.do?bookId=<%=book.getId()%>&mode=-1"; 
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


