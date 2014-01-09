<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.phoenixcloud.book.vo.BookResNode" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String ctx = request.getContextPath();
Integer maxLevel = (Integer)request.getAttribute("maxLevel");
if (maxLevel == null) {
	maxLevel = 1;
}
Map<String,BookResNode> resNodeMap = (HashMap<String,BookResNode>)request.getAttribute("resNodeMap");
if (resNodeMap == null) {
	resNodeMap = new HashMap<String,BookResNode>();
}
List<String> children = resNodeMap.get("root").getChildren();
WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
		WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
IRBookMgmtService iBookService = (IRBookMgmtService)context.getBean("bookMgmtServiceImpl");
IAgencyMgmtService iAgencyMgmt = (IAgencyMgmtService)context.getBean("agencyMgmtServiceImpl");

%>

<html>
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
	<title>书籍资源管理</title>
	
	<style type="text/css">
	table th,td{
	border: 1px solid #DADADA;
	width:10%;
	}
	th{
	text-align:left;
	}
	.emptyCol{
	width:3%;
	}
	.passAnchor{}
	.rejectAnchor{}
	.removeAnchor{}
	</style>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<%
		// 算出机构节点的最大level
		// 1.有资源的机构找出来
		// 2.计算机构的最大深度
		
		%>
		
		<div class="widget-box">
			<table style="border: 1px solid #AAAAAA;border-collapse: collapse;width:100%">
				<thead  style="background:#EEEEEE;">
					<tr>
						<th colspan="<%=(maxLevel+1)%>">机构根节点</th>
						<th>电子书名称</th>
						<th>资源名称</th>
						<th>状态</th>
						<th colspan="3" style="text-align:center">操作</th>
					</tr>
				</thead>
				<tbody>
				<%!
				void showChild(Map<String,BookResNode> resNodeMap, String child, 
						javax.servlet.jsp.JspWriter out,
						IAgencyMgmtService iAgencyMgmt,
						IRBookMgmtService iBookService,
						int maxLevel,
						String ctx) throws java.io.IOException{
	
					BookResNode resNode = resNodeMap.get(child);
					if ("cata".equals(resNode.getType())) {
						out.print("<tr>");
						for (int i = 0; i < resNode.getLevel(); i++) {
							out.print("<td></td>");
						}
						
						PubOrgCata cata = iAgencyMgmt.findOrgCataById(resNode.getId());

						// 输出机构目录名称
						out.print("<td colspan=\"" + (maxLevel - resNode.getLevel() + 1) + "\">" + cata.getCataName() + "</td>");
						
						// 电子书名称
						out.print("<td></td>");
						
						// 资源名称
						out.print("<td></td>");
						
						// 状态
						out.print("<td></td>");
						
						// 3个操作
						out.print("<td></td>");
						out.print("<td></td>");
						out.print("<td></td>");
						out.print("</tr>");
						for (String childKey: resNode.getChildren()) {
							showChild(resNodeMap, childKey, out, iAgencyMgmt, iBookService, maxLevel, ctx);
						}
					} else if ("org".equals(resNode.getType())) {
						PubOrg org = iAgencyMgmt.findOrgById(resNode.getId());
						// 循环输出有资源 书籍及其所有资源
						for (String bookId : resNode.getBookIds()) {
							RBook book = iBookService.findBook(bookId);
							List<RBookRe> resList = iBookService.getResByBookId(bookId);
							for (RBookRe res : resList) {
								out.print("<tr>");
								for (int i = 0; i < maxLevel; i++) {
									out.print("<td></td>");
								}
								// 输出机构目录名称
								out.print("<td>" + org.getOrgName() + "</td>");
								
								// 电子书名称
								out.print("<td>" + book.getName() + "</td>");
								
								// 资源名称
								out.print("<td>" + res.getName() + "</td>");
								
								// 状态
								byte isAudit = res.getIsAudit();
								if (isAudit == (byte)-1) {
									out.print("<td>未审核</td>");
									out.print("<td><a class=\"passAnchor\" resId=\"" + res.getId() + "\" href=\"#\">通过</a></td>");
									out.print("<td><a class=\"rejectAnchor\" resId=\"" + res.getId() + "\" href=\"#\">不通过</a></td>");
								} else if (isAudit == (byte)0){
									out.print("<td>审核未通过</td>");
									out.print("<td></td>");
									out.print("<td></td>");
								} else if (isAudit == (byte)1) {
									out.print("<td>审核已通过</td>");
									out.print("<td></td>");
									out.print("<td></td>");
								} else {
									out.print("<td></td>");
									out.print("<td></td>");
									out.print("<td></td>");
								}
								out.print("<td><a class=\"removeAnchor\" resId=\"" + res.getId() + "\" href=\"#\">删除</a></td>");
								out.print("</tr>");
							}
						}
					}
				}
				
				%>
				<%
				if (children.size() == 0) {
					out.print("<tr><td>暂时没有可用的书籍资源！</td></tr>");
				} else {
					for (String child: children) {
						showChild(resNodeMap, child, out, iAgencyMgmt, iBookService, maxLevel, ctx);
					}
				}
				%>
				</tbody>
			</table>
		</div>		
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">
$(function(){
	$("th").each(function(){
		if ($(this).html().length == 0) {
			$(this).addClass("emptyCol");
		}
	});
	$("td").each(function(){
		if ($(this).html().length == 0) {
			$(this).addClass("emptyCol");
		}
	});
	$(".passAnchor").on("click", function(event) {
		$.ajax({
			url: "<%=ctx%>/book/bookRes_auditRes.do",
			type: "post",
			async: "false",
			timeout: 30000,
			data: {flag:"true", resId:event.target.getAttribute("resId")},
			success: function() {
				location.reload(true);
			},
			error: function() {
				alert("请重试！");
			}
		});
		return false;
	});
	$(".rejectAnchor").on("click", function(event) {
		$.ajax({
			url: "<%=ctx%>/book/bookRes_auditRes.do",
			type: "post",
			async: "false",
			timeout: 30000,
			data: {flag:"false", resId:event.target.getAttribute("resId")},
			success: function() {
				location.reload(true);
			},
			error: function() {
				alert("请重试！");
			}
		});
		return false;
	});
	$(".removeAnchor").on("click", function(event) {
		$.ajax({
			url: "<%=ctx%>/book/bookRes_removeRes.do",
			type: "post",
			async: "false",
			timeout: 30000,
			data: {resId:event.target.getAttribute("resId")},
			success: function() {
				location.reload(true);
			},
			error: function() {
				alert("请重试！");
			}
		});
		return false;
	});
});
</script>

</html>