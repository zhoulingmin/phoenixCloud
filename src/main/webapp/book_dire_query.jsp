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
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍查询&gt;书籍目录
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
		</div>

	</div>
</body>

<script type="text/javascript">

// 初始化，手动初始化
// 初始化之后，开启异步加载
$(document).ready(function(){
	
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
	
	
});

</script>

</html>


