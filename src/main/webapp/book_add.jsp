<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<%
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getStaffId().toString());
String ctx = request.getContextPath();

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> subjectList = ddvDao.findByTblAndField("r_book", "SUBJECT_ID");
List<PubDdv> stuSegList = ddvDao.findByTblAndField("r_book", "STU_SEG_ID");
List<PubDdv> classList = ddvDao.findByTblAndField("r_book", "CLASS_ID");
List<PubDdv> kindList = ddvDao.findByTblAndField("r_book", "KIND_ID");
List<PubDdv> cataAddrList = ddvDao.findByTblAndField("r_book", "CATA_ADDR_ID");

PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);
List<PubPress> pressList = pressDao.getAll();

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
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍制作&gt;创建书籍
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
					
					<div class="control-group" style="display:none">
						<label class="control-label">机构</label>
						<div class="controls">
							<input type="text" name="orgNameTmp" onfocus="onfocusOrg()" >
							<input type="hidden" name="bookInfo.orgId" >
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">书籍编码</label>
						<div class="controls">
							<input type="text" name="bookInfo.bookNo">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">出版社名称</label>
						<div class="controls" style="float: left; margin-left: 20px;">
							<select name="bookInfo.pressId">
								<%for (PubPress press : pressList) { %>
								<option value="<%=press.getPressId() %>"><%=press.getName() %></option>
								<%} %>
							</select>
						</div>
						<label class="control-label" style="width: 60px;">出版年份</label>
						<div class="controls" style="float: left; margin-left: 5px;">
							<select name="yearOfRls" style="width: 86px;">
							<%
							int curYear = new Date().getYear() + 1900;
							for (int y = curYear; y > 2005; y--) {
							%>
								<option value="<%=y%>"><%=y%></option>
							<%} %>
							</select>
						</div>
						<label class="control-label" style="width: 34px;">季度</label>
						<div class="controls" style="float: left; margin-left: 5px;">
							<select name="quarter" style="width: 86px;">
								<option value="02">春季</option>
								<option value="09">秋季</option>
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
							<select id="stuSegSel" name="bookInfo.stuSegId" onchange="changeStuSeg();">
								<%for (PubDdv stu : stuSegList) { %>
								<option value="<%=stu.getDdvId()%>"><%=stu.getValue() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">年级</label>
						<div class="controls">
							<select id="cls" name="bookInfo.classId">
							<%for (PubDdv cls : classList) { %>
								<option value="<%=cls.getDdvId() %>" flag="<%=cls.getNotes()%>"><%=cls.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">册别</label>
						<div class="controls" style="float: left; margin-left: 20px;">
							<select id="kind" name="bookInfo.kindId">
							<%for (PubDdv kind : kindList) { %>
								<option value="<%=kind.getDdvId() %>" flag="<%=kind.getNotes()%>"><%=kind.getValue() %></option>
							<%} %>
							</select>
						</div>
						<label id="kindSeqLbl" style="display: none; width: 99px;" class="control-label">本学科科目序号</label>
						<div class="controls" id="kindSeqDiv" style="display: none; float: left; margin-left: 0px;">
							<input type="text" name="kindSeqNo" value="a"/>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">页数</label>
						<div class="controls">
							<input type="text" name="bookInfo.pageNum">
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">服务器IP</label>
						<div class="controls">
							<input type="text" name="bookInfo.ipAddr">
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">书内网全地址</label>
						<div class="controls">
							<input type="text" name="bookInfo.allAddrInNet">
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">书外网全地址</label>
						<div class="controls">
							<input type="text" name="bookInfo.allAddrOutNet">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="bookInfo.notes">
						</div>
					</div>
				
					<div class="form-actions">
						<security:phoenixSec purviewCode="BOOK_ADD">
						<button class="btn btn-primary" type="button"  onclick="addBook();">创建</button>
						</security:phoenixSec>
						<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">取消</button>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">


function checkBookNoExist(){
	var bookNo = jQuery("input[name='bookInfo.bookNo']")[0];
	if (bookNo == null || bookNo.value.trim().length == 0) {
		alert("书籍编码不能为空！");
		return;
	}
	
	jQuery.ajax({
		type: "POST",
		url: "<%=ctx%>/book/book_checkBookNo.do",
		data: {"bookInfo.bookNo": bookNo.value},
		dataType: "JSON",
		async: false,
		timeout: 3000,
		success: function(ret) {
			if (ret == null) {
				alert("检查书籍编码是否重复时，出错！");
				jQuery(bookNo).val("");
				jQuery(bookNo).focus();
			}
			if (ret.ret) {
				alert("书籍编码重复！");
				jQuery(bookNo).focus();
			}
		},
		error: function(XMLRequest, textInfo) {
			if (textInfo != null) {
				alert(textInfo);
			}
			jQuery(bookNo).val("");
		}
	});
}


function back() {
	jQuery.ajax({
		url: "",
		type:"GET",
		async:"false",
		timeout:10,
		success:function(){
			location.href = "<%=ctx%>/book_zhizuo.jsp";
		},
		error: function() {
			location.href = "<%=ctx%>/book_zhizuo.jsp";
		}
	});
}

function addBook() {
	var pageNum = jQuery("input[name='bookInfo.pageNum']")[0];
	if (pageNum == null || pageNum.value.trim().length == 0 || !jQuery.isNumeric(pageNum.value.trim())) {
		alert("页数不能为空，且必须为数字！");
		jQuery("input[name='bookInfo.pageNum']:eq(0)").focus();
		return;
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/book/book_addBook.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		dataType: "JSON",
		data: jQuery("#bookForm").serialize(),
		success: function(ret) {
			if (ret == null) {
				alert("创建书籍失败！");
				return;
			}
			if (ret.ret == 1) {
				alert(ret.reason);
				return;
			}
			alert("创建书籍成功！");
			location.href = "<%=ctx%>/book_zhizuo.jsp";
		},
		error: function() {
			alert("创建书籍失败！");
		}
	});
}

var oldStuSeg = "";
function changeStuSeg() {
	if ("高中" == jQuery("#stuSegSel option:selected").html()) {
		jQuery("#kindSeqLbl").css("display","inline");
		jQuery("#kindSeqDiv").css("display","block");
		jQuery("#kind option[flag='高中']").css("display","block");
		jQuery("#kind option[flag!='高中']").css("display","none");
		var selFirst = jQuery("#kind option[flag='高中']:eq(0)").val();
		jQuery("#kind").val(selFirst);
		
		jQuery("#cls option[flag='高中']").css("display","block");
		jQuery("#cls option[flag!='高中']").css("display","none");
		selFirst = jQuery("#cls option[flag='高中']:eq(0)").val();
		jQuery("#cls").val(selFirst);
	} else if (oldStuSeg == "" || oldStuSeg == "高中"){
		jQuery("#kindSeqLbl").css("display","none");
		jQuery("#kindSeqDiv").css("display","none");
		jQuery("#kind option[flag!='高中']").css("display","block");
		jQuery("#kind option[flag='高中']").css("display","none");
		var selFirst = jQuery("#kind option[flag!='高中']:eq(0)").val();
		jQuery("#kind").val(selFirst);
		
		jQuery("#cls option[flag!='高中']").css("display","block");
		jQuery("#cls option[flag='高中']").css("display","none");
		selFirst = jQuery("#cls option[flag!='高中']:eq(0)").val();
		jQuery("#cls").val(selFirst);
	}
	oldStuSeg = jQuery("#stuSegSel option:selected").html();
}

jQuery(document).ready(function(){
	changeStuSeg();
});

function constructBookNo() {
	
}

</script>
</html>
