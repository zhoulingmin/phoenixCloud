<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.dao.res.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@page import="java.util.Date" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="java.math.*" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>

<%
ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff curStaff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(curStaff.getOrgId().toString());
RBook book = (RBook)request.getAttribute("book");
int maxLevel = (Integer)request.getAttribute("maxLevel");
JSONArray direArr = (JSONArray)request.getAttribute("direArr");

RBookDireDao direDao = (RBookDireDao)SpringUtils.getBean("RBookDireDao");
String preDir = "inline", sufDir = "inline", sufCover = "inline";
BigInteger bookId = new BigInteger(book.getBookId());
if (direDao.existTypeOfDire(bookId, 1) != null) { // 前目录
	preDir = "none";
}
if (direDao.existTypeOfDire(bookId, 3) != null) { // 后目录
	sufDir = "none";
}
if (direDao.existTypeOfDire(bookId, 4) != null) { // 后封面
	sufCover = "none";
}

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
	        <li style="display:<%=preDir%>"><a tabindex="1" href="#">新建前目录</a></li>
	        <li><a tabindex="2" href="#">新建正文</a></li>
	        <li style="display:<%=sufDir%>"><a tabindex="3" href="#">新建后目录</a></li>
	        <li style="display:<%=sufDir%>"><a tabindex="4" href="#">新建封底</a></li>
	        <li class="divider"></li> 
	        <li><a tabindex="5" href="#">删除</a></li>
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
				<tbody id="direBody">
					<tr direId="0" type="-1">
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
							out.print("<tr direId=\"" + obj.get("direId") + "\" level=\"" + obj.get("level") + "\" type=\"" + obj.get("type") + "\">");
							
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
			<input style="float:right; margin-right:30px;" type="button" name="cancel" class="btn btn-primary" onclick="backToQueryBook();return false;" value="返回" />
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

function backToQueryBook() {
	window.location.href = "<%=ctx%>/book_zhizuo.jsp";
}

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
		var type = this.getAttribute("type");
		$contextMenu.find("li").css("display","inline");
		$contextMenu.find("li.divider")[0].style.display='';
		if (type == -1) { // 在目录的第一行
			if (jQuery("#direBody tr[type='1']").length == 1) { // 前目录存在
				$contextMenu.find("li:eq(0)").css("display", "none");
			}
			if (jQuery("#direBody tr[type='3']").length == 1) { // 后目录存在
				$contextMenu.find("li:eq(2)").css("display", "none");
			}
			if (jQuery("#direBody tr[type='4']").length == 1) { // 后封面存在
				$contextMenu.find("li:eq(3)").css("display", "none");
			}
			$contextMenu.find("li.divider").css("display", "none");
			$contextMenu.find("li:last").css("display", "none");
		} else if (type == 0) { // 封面
			return false;
		} else if (type == 1 || type == 3 || type == 4) { // 前目录，后目录，后封面
			$contextMenu.find("li").css("display", "none");
			$contextMenu.find("li:last").css("display", "inline");
		} else if (type == 2) { // 正文,context menu有 新建正文、删除
			$contextMenu.find("li:eq(0)").css("display", "none"); // 前目录
			$contextMenu.find("li:eq(2)").css("display", "none"); // 后目录
			$contextMenu.find("li:eq(3)").css("display", "none"); // 后封面
		} else {
			return false;
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
	
	var coverElm = $("tbody tr:eq(1) td:eq(1) input:eq(0)").val();
	coverElm += "<input type='hidden' name='name' value='" + coverElm + "' />";
	coverElm += "<a title=\"封面图片\" href=\"<%=ctx%>/book_cover_image.jsp?bookId=<%=book.getBookId()%>\"><i class=\"icon-picture\" style=\"margin-top: -2px;\"></i></a>";
	$("tbody tr:eq(1) td:eq(1)").html(coverElm);
	
	//var direElm = $("tbody tr:eq(2) td:eq(1) input:eq(0)").val();
	//direElm += "<input type='hidden' name='name' value='" + direElm + "' />";
	//$("tbody tr:eq(2) td:eq(1)").html(direElm);
	
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
		case 1: // 新建前目录
			window.location.href = "<%=ctx%>/book_dire_add.jsp?bookId=<%=book.getId()%>&parentId=" 
				+ $curDire.getAttribute("direId") + "&level=" + $curDire.getAttribute("level") + "&type=1";
			break;
		case 2: // 新建正文
			window.location.href = "<%=ctx%>/book_dire_add.jsp?bookId=<%=book.getId()%>&parentId=" 
					+ $curDire.getAttribute("direId") + "&level=" + $curDire.getAttribute("level") + "&type=2";
			break;
		case 3: // 新建后目录
			window.location.href = "<%=ctx%>/book_dire_add.jsp?bookId=<%=book.getId()%>&parentId=" 
				+ $curDire.getAttribute("direId") + "&level=" + $curDire.getAttribute("level") + "&type=3";
			break;
		case 4: // 新建封底
			window.location.href = "<%=ctx%>/book_dire_add.jsp?bookId=<%=book.getId()%>&parentId=" 
				+ $curDire.getAttribute("direId") + "&level=" + $curDire.getAttribute("level") + "&type=4";
			break;
		
		case 5: // 删除
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


