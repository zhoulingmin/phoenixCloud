<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.List" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> subjectList = ddvDao.findByTblAndField("r_book", "SUBJECT_ID");
List<PubDdv> stuSegList = ddvDao.findByTblAndField("r_book", "STU_SEG_ID");
List<PubDdv> classList = ddvDao.findByTblAndField("r_book", "CLASS_ID");
List<PubDdv> kindList = ddvDao.findByTblAndField("r_book", "KIND_ID");
List<PubDdv> cataAddrList = ddvDao.findByTblAndField("r_book", "CATA_ADDR_ID");

PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);
List<PubPress> pressList = pressDao.getAll();

String isAudit = request.getParameter("isAudit");
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	
<title>新建书籍</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>录入书籍信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="bookForm" class="form-horizontal" method="POST" action="#">
					<div class="control-group">
						<label class="control-label">书籍名称</label>
						<div class="controls">
							<input type="text" name="bookInfo.name">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">机构</label>
						<div class="controls">
							<input type="text" name="orgNameTmp" onfocus="onfocusOrg()" >
							<input type="hidden" name="bookInfo.orgId" >
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">书籍编码</label>
						<div class="controls">
							<input type="text" name="bookInfo.bookNo">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">出版社名称</label>
						<div class="controls">
							<select name="bookInfo.pressId">
								<%for (PubPress press : pressList) { %>
								<option value="<%=press.getPressId() %>"><%=press.getName() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">学科</label>
						<div class="controls">
							<select name="bookInfo.subjectId">
								<%for (PubDdv sub: subjectList) {%>
								<option value="<%=sub.getDdvId() %>"><%=sub.getValue() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">学段</label>
						<div class="controls">
							<select name="bookInfo.stuSegId">
								<%for (PubDdv stu : stuSegList) { %>
								<option value="<%=stu.getDdvId()%>"><%=stu.getValue() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">年级</label>
						<div class="controls">
							<select name="bookInfo.classId">
							<%for (PubDdv cls : classList) { %>
								<option value="<%=cls.getDdvId() %>"><%=cls.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">册别</label>
						<div class="controls">
							<select name="bookInfo.kindId">
							<%for (PubDdv kind : kindList) { %>
								<option value="<%=kind.getDdvId() %>"><%=kind.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">页数</label>
						<div class="controls">
							<input type="text" name="bookInfo.pageNum">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">资源目录地址</label>
						<div class="controls">
							<select name="bookInfo.cataAddrId">
							<%for (PubDdv cataAddr : cataAddrList) { %>
								<option value="<%=cataAddr.getDdvId() %>"><%=cataAddr.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">服务器IP</label>
						<div class="controls">
							<input type="text" name="bookInfo.ipAddr">
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">书全地址</label>
						<div class="controls">
							<input type="text" name="bookInfo.allAddr">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="bookInfo.notes">
						</div>
					</div>
				
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="addBook();">创建</button>
						<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">取消</button>
					</div>
				</form>
			</div>
			
		</div>
	</div>
	
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function addBook() {
	jQuery.ajax({
		url: "<%=ctx%>/book/book_addBook.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: jQuery("#bookForm").serialize(),
		dataType: "json",
		success: function() {
			alert("创建书籍成功！");
			location.href = "<%=ctx%>/book/book_getAll.do?bookInfo.isAudit=<%=isAudit%>";
		},
		error: function() {
			alert("创建书籍失败！");
		}
	});
}

function cancel() {
	location.href = "<%=ctx%>/book/book_getAll.do";
}

function onfocusOrg() {
	jQuery("#agencyTree").css("display", "block");
}

var zTreeObj,
setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getAgency.do",
		autoParam: ["type", "selfId"]
	},
	callback: {
		onClick: onSelOrg
	}
},
zTreeNodes = [];

function onSelOrg(event, treeId, treeNode, clickFlag) {
	if (treeNode != null && !treeNode.isParent) {
		// 1. set org field value
		jQuery(jQuery("input[name='bookInfo.orgId']")[0]).val(treeNode.selfId);
		jQuery(jQuery("input[name='orgNameTmp']")[0]).val(treeNode.name);
		// 2. hide
		jQuery("#agencyTree").css("display", "none");
	}
}

jQuery(document).ready(function(){
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
});

</script>

</html>