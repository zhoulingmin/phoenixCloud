<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.List" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
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

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
String orgId = vs.findString("bookInfo.orgId");
String orgName = "";
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg orgBean = orgDao.find(orgId);
if (orgBean != null) {
	orgName = orgBean.getOrgName();
}

%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery-1.7.2.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	
	<title>书籍管理界面</title>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		
		<div class="widget-box">
			<div class="widget-content">
				<div class="fileinput fileinput-new" data-provides="fileinput">
					<form id="uploadBookFrm" action="<%=ctx%>/book/uploadBook.do" onsubmit="checkfile()" method="POST" enctype="multipart/form-data">
						<span class="btn btn-default btn-file">
							<span class="fileinput-new">选择书籍文件</span>
							<span class="fileinput-exists">重新选择书籍文件</span>
							<input id="bookFile" type="file" name="bookFile">
						</span>
						<span class="fileinput-filename"></span>
						<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
						<input type="hidden" name="bookId" value="<s:property value="bookInfo.bookId"/>" />
						<input type="hidden" name="isUpload" value="<s:property value="bookInfo.isUpload"/>" />
						<input id="uploadBtn" type="submit" class="btn" onclick="return checkfile();" name="submit" value="上传"/>						
					</form>
				</div>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>书籍信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="bookForm" class="form-horizontal" method="POST" action="#">
					<input type="hidden" name="bookInfo.bookId" value="<s:property value="bookInfo.bookId"/>" />
					<div class="control-group">
						<label class="control-label">书籍名称</label>
						<div class="controls">
							<input type="text" name="bookInfo.name" value="<s:property value="bookInfo.name"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">机构</label>
						<div class="controls">
							<input type="text" name="orgNameTmp" onfocus="onfocusOrg()" value="<%=orgName %>">
							<input type="hidden" name="bookInfo.orgId" value="<s:property value="bookInfo.orgId"/>">
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">出版社名称</label>
						<div class="controls">
							<select name="bookInfo.pressId" value="<s:property value="bookInfo.pressId"/>">
								<%for (PubPress press : pressList) { %>
								<option value="<%=press.getPressId() %>"><%=press.getName() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">学科</label>
						<div class="controls">
							<select name="bookInfo.subjectId" value="<s:property value="bookInfo.subjectId"/>">
								<%for (PubDdv sub: subjectList) {%>
								<option value="<%=sub.getDdvId() %>"><%=sub.getValue() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">学段</label>
						<div class="controls">
							<select name="bookInfo.stuSegId" value="<s:property value="bookInfo.stuSegId"/>">
								<%for (PubDdv stu : stuSegList) { %>
								<option value="<%=stu.getDdvId()%>"><%=stu.getValue() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">年级</label>
						<div class="controls">
							<select name="bookInfo.classId" value="<s:property value="bookInfo.classId"/>">
							<%for (PubDdv cls : classList) { %>
								<option value="<%=cls.getDdvId() %>"><%=cls.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">册别</label>
						<div class="controls">
							<select name="bookInfo.kindId" value="<s:property value="bookInfo.kindId"/>">
							<%for (PubDdv kind : kindList) { %>
								<option value="<%=kind.getDdvId() %>"><%=kind.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">页数</label>
						<div class="controls">
							<input type="text" name="bookInfo.pageNum" value="<s:property value="bookInfo.pageNum"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">资源目录地址</label>
						<div class="controls">
							<select name="bookInfo.cataAddrId" value="<s:property value="bookInfo.cataAddrId"/>">
							<%for (PubDdv cataAddr : cataAddrList) { %>
								<option value="<%=cataAddr.getDdvId() %>"><%=cataAddr.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="bookInfo.notes" value="<s:property value="bookInfo.notes"/>">
						</div>
					</div>
				
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="saveBook();">保存</button>
						<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">返回</button>
					</div>
				</form>
			</div>
			
		</div>
	</div>
	
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function checkfile() {
	if(jQuery("#bookFile").val().length == 0) {
		alert("请先选择文件！");
		return false;
	}
	return true;
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

function saveBook() {
	jQuery.ajax({
		url: "<%=ctx%>/book/book_editBook.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: jQuery("#bookForm").serialize(),
		success: function() {
			alert("修改书籍成功！");
			location.href = "<%=ctx%>/book/book_getAll.do";
		},
		error: function() {
			alert("修改书籍失败！");
		}
	});
}

function cancel() {
	location.href = "<%=ctx%>/book/book_getAll.do";
}

jQuery(function() {
	jQuery("select").each(function(idx) {
		jQuery(this).val(this.getAttribute("value"));
	});
	var isUpload = jQuery("input[name='isUpload']")[0].value;
	if (isUpload != null && isUpload == 1) {
		jQuery("#uploadBtn").val("更新");
	}
	
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
});

</script>

</html>