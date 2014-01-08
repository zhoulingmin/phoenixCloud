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
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
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
	        <li><a tabindex="2" href="#">修改</a></li>
	        <li><a tabindex="3" href="#">删除</a></li>
	        <li class="divider"></li>
	        <li><a tabindex="4" href="#">刷新</a></li>
	    </ul>
	</div>
	
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<div class="widget-box">
			<div class="widget-content">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn" name="addBookDire" onclick="addBookDire();" value="新建"/>
				
				<!-- 上传书籍文件 -->
				<div class="fileinput fileinput-new" data-provides="fileinput" style="border:1px dotted #0000FF">
					<form id="uploadBookFrm" action="<%=ctx%>/book/uploadBook.do" method="POST" enctype="multipart/form-data">
						<span class="btn btn-default btn-file">
							<span class="fileinput-new">选择书籍文件</span>
							<span class="fileinput-exists">重新选择书籍文件</span>
							<input id="bookFile" type="file" name="bookFile">
						</span>
						<span class="fileinput-filename"></span>
						<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
						<input type="hidden" name="bookId" value="<%=book.getId()%>" />
						<%if (book.getIsUpload() == (byte)0) {%>
						<input type="submit" class="btn" name="submit" value="上传"/>
						<%} else {%>
						<input type="submit" class="btn" name="submit" value="更新" />
						<%} %>
					</form>
				</div>
			</div>
		</div>
		<div id="direTree" class="widget-box ztree">
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
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
		onRightClick: OnRightClick,
		onDblClick: onDblClick
	}
},
zTreeNodes = [];

function addBookDire() {
	location.href = "<%=ctx%>/addBookDire.jsp?bookId=<%=book.getId()%>&parentId=0";	
}

function onDblClick(event, treeId, node) {
	location.href = "<%=ctx%>/book/bookDire_editDire.do?isView=true&direId=" + node.direId;
}


var $contextMenu = $("#contextMenu");
var $curTreeNode;

function OnRightClick(event, treeId, treeNode) {
	if (treeNode == null) {
		alert("请在节点上面点击！");
		return;
	}
	$contextMenu.css({
	      display: "block",
	      left: event.clientX,
	      top: event.clientY
	});
	$curTreeNode = treeNode;
}

// 初始化，手动初始化
// 初始化之后，开启异步加载
$(document).ready(function(){
	zTreeObj = $.fn.zTree.init($("#direTree"), setting, zTreeNodes);
	$(document).click(function () {
	    $contextMenu.hide();
	});
	
	$("#contextMenu").on("click", "a", function(e) {
		var tabIndex = e.target.getAttribute("tabindex");
		switch (parseInt(tabIndex)) {
		case 1: // 新建
			location.href = "<%=ctx%>/addBookDire.jsp?bookId=<%=book.getId()%>&parentId=" + $curTreeNode.direId;
			break;
		case 2: // 修改
			location.href = "<%=ctx%>/book/bookDire_editDire.do?direId=" + $curTreeNode.direId;
			break;
		case 3: // 删除
			if ($curTreeNode == zTreeObj.getNodes()[0] || $curTreeNode == zTreeObj.getNodes()[1]) {
				alert("无法删除！");
			}
			jQuery.ajax({
				url: "<%=ctx%>/book/bookDire_removeDire.do",
				type: "post",
				async: "false",
				data: {bookId:"<%=book.getId()%>", direId:$curTreeNode.direId},
				timeout: 30000,
				success: function() {
					alert("删除书籍目录成功！");
					zTreeObj.reAsyncChildNodes($curTreeNode.getParentNode(), "refresh", false);
				},
				error: function() {
					alert("删除书籍目录失败！");
				}
			});
			break;
		case 4: // 刷新
			location.href = "<%=ctx%>/book/bookDire_getAll.do?bookId=<%=book.getId()%>";
			break;
		}
		$contextMenu.hide();
	});
});

</script>

</html>