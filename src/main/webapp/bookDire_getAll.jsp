<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.phoenixcloud.bean.RBookDire" %>
<%@page import="java.math.BigInteger" %>
<%@page import="com.phoenixcloud.bean.RBook" %>
<%@page import="com.phoenixcloud.util.MiscUtils" %>
<%@page import="java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String ctx = request.getContextPath();
RBook book = (RBook)request.getAttribute("book");
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
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.exedit-3.5.js"></script>
	
	<style type="text/css">
	#contextMenu {
	    position: absolute;
	    display:none;
	}
	</style>
	
	<title><%=book.getName()%>-书籍目录管理</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	
	<div id="contextMenu" class="dropdown clearfix">
	    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" style="display:block;position:absolute;margin-bottom:5px;">
	        <li><a tabindex="1" href="#">新建</a></li>
	        <li><a tabindex="2" href="#">删除</a></li>
	        <li><a tabindex="3" href="#">修改</a></li>
	        <li class="divider"></li>
	        <li><a tabindex="4" href="#">刷新</a></li>
	    </ul>
	</div>
	
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<div class="widget-box">
			<div class="widget-box">
				<div class="widget-content">
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addBook" onclick="addBook();" value="新建"/>
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="removeBook" onclick="removeBooks();" value="删除"/>
				</div>
			</div>
		</div>
		<div id="direTree" class="widget-box ztree">
		
		</div>
	</div>
</body>

<script type="text/javascript">

var zTreeObj,
setting = {
	view: {
		dblClickExpand: false
	},
	async: {
		enable: true,
		url: "<%=ctx%>/book/bookDire_getSubDire.do",
		autoParam: ["direId"],
		otherParam: ["bookId","<%=book.getId()%>"]
	},
	callback: {
		onRightClick: OnRightClick
	}
},
zTreeNodes = [];


var $contextMenu = $("#contextMenu");

function OnRightClick(event, treeId, treeNode) {
	if (treeNode == null) {
		return;
	}
	$contextMenu.css({
	      display: "block",
	      left: event.clientX,
	      top: event.clientY
	});
}

// 初始化，手动初始化
// 初始化之后，开启异步加载
$(document).ready(function(){
	zTreeObj = $.fn.zTree.init($("#direTree"), setting, zTreeNodes);
	$(document).click(function () {
	    $contextMenu.hide();
	});
});

</script>

</html>