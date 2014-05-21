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

ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
String orgId = vs.findString("bookInfo.orgId");
String orgName = "";

String accntName = "";
SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
SysStaff staffTmp = staffDao.find(vs.findString("bookInfo.staffId"));
if (staffTmp != null) {
	accntName = staffTmp.getName();
}
String beautifySize = new java.text.DecimalFormat(",###").format((Integer)vs.findValue("bookInfo.bookSize"));

String kindSeqNo = (String)request.getAttribute("kindSeqNo");
if (kindSeqNo == null){
	kindSeqNo = "";
}

String yearOfRls = (String)request.getAttribute("yearOfRls");
if (yearOfRls == null){
	yearOfRls = "";
}

String quarter = (String)request.getAttribute("quarter");
if (quarter == null){
	quarter = "";
}

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
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>
<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍制作&gt;修改书籍
		</div>
		<security:phoenixSec purviewCode="BOOK_UPLOAD">
		<div class="widget-box">
			<div class="widget-content">
				<div class="fileinput fileinput-new" data-provides="fileinput">
					<form id="uploadBookFrm" action="<%=ctx%>/book/uploadBookNew.do" onsubmit="checkfile()" method="POST" enctype="multipart/form-data">
						<span class="btn btn-default btn-file">
							<span class="fileinput-new">选择书籍文件</span>
							<span class="fileinput-exists">重新选择书籍文件</span>
							<input id="bookFile" type="file" name="bookFile">
						</span>
						<span class="fileinput-filename"></span>
						<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
						<input type="hidden" name="bookId" value="<s:property value="bookInfo.bookId"/>" />
						<input type="hidden" name="isUpload" value="<s:property value="bookInfo.isUpload"/>" />
						
						<input id="uploadBtn" type="submit" class="btn btn-primary" onclick="return checkfile();" name="submit" value="上传"/>						
					</form>
				</div>
			</div>
		</div>
		</security:phoenixSec>

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
						<label class="control-label">书籍编码</label>
						<div class="controls">
							<input type="text" name="bookInfo.bookNo" value="<s:property value="bookInfo.bookNo"/>" readonly="readonly">
						</div>
					</div>
					
					<div class="control-group" style="display:none">
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
						<div class="controls" style="float: left; margin-left: 20px;" >
							<select name="bookInfo.pressId" value="<s:property value="bookInfo.pressId"/>">
								<%for (PubPress press : pressList) { %>
								<option value="<%=press.getPressId() %>"><%=press.getName() %></option>
								<%} %>
							</select>
						</div>
						<label class="control-label" style="width: 60px;">出版年份</label>
						<div class="controls" style="float: left; margin-left: 5px;">
							<select name="yearOfRls" style="width: 86px;" value="<%=yearOfRls %>">
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
							<select name="quarter" style="width: 86px;" value="<%=quarter %>">
								<option value="02">春季</option>
								<option value="09">秋季</option>
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
							<select id="stuSegSel" name="bookInfo.stuSegId" value="<s:property value="bookInfo.stuSegId"/>" onchange="changeStuSeg();">
								<%for (PubDdv stu : stuSegList) { %>
								<option value="<%=stu.getDdvId()%>"><%=stu.getValue() %></option>
								<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">年级</label>
						<div class="controls">
							<select id="cls" name="bookInfo.classId" value="<s:property value="bookInfo.classId"/>">
							<%for (PubDdv cls : classList) { %>
								<option value="<%=cls.getDdvId() %>" flag="<%=cls.getNotes()%>"><%=cls.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">册别</label>
						<div class="controls" style="float: left; margin-left: 20px;">
							<select id="kind" name="bookInfo.kindId" value="<s:property value="bookInfo.kindId"/>">
							<%for (PubDdv kind : kindList) { %>
								<option value="<%=kind.getDdvId() %>" flag="<%=kind.getNotes()%>"><%=kind.getValue() %></option>
							<%} %>
							</select>
						</div>
						<label id="kindSeqLbl" style="display: none; width: 99px;" class="control-label">本学科科目序号</label>
						<div class="controls" id="kindSeqDiv" style="display: none; float: left; margin-left: 0px;">
							<input type="text" name="kindSeqNo" value="<%=kindSeqNo%>"/>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">页数</label>
						<div class="controls">
							<input type="text" name="bookInfo.pageNum" value="<s:property value="bookInfo.pageNum"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">书籍大小(字节)</label>
						<div class="controls">
							<input type="hidden" name="bookInfo.bookSize" value="<s:property value="bookInfo.bookSize"/>" readonly="readonly">
							<input type="text" name="bookSizeTmp" value="<%=beautifySize %>" readonly="readonly">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">服务器IP地址</label>
						<div class="controls">
							<input type="text" name="bookInfo.ipAddr" value="<s:property value="bookInfo.ipAddr"/>" readonly="readonly">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">书内网全路径</label>
						<div class="controls">
							<input type="text" name="bookInfo.allAddrInNet" value="<s:property value="bookInfo.allAddrInNet"/>" readonly="readonly">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">书外网全路径</label>
						<div class="controls">
							<input type="text" name="bookInfo.allAddrOutNet" value="<s:property value="bookInfo.allAddrOutNet"/>" readonly="readonly">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号</label>
						<div class="controls">
							<input type="hidden" name="bookInfo.orgId" value="<s:property value="bookInfo.orgId"/>">
							<input type="text" name="accntName" value="<%= accntName%>" readonly="readonly">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="bookInfo.notes" value="<s:property value="bookInfo.notes"/>">
						</div>
					</div>
				
					<div class="form-actions">
						<security:phoenixSec purviewCode="BOOK_UPDATE">
						<button class="btn btn-primary" type="button"  onclick="saveBook();">保存</button>
						</security:phoenixSec>
						<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">返回</button>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">

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

function checkfile() {
	if(jQuery("#bookFile").val().length == 0) {
		alert("请先选择文件！");
		return false;
	}
	
	if (jQuery("#bookFile").val().lastIndexOf(".pkg") == -1) {
		alert("请选择pkg格式的文件！");
		return false;
	}
	
	return true;
}

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

function saveBook() {
	
	var pageNum = jQuery("input[name='bookInfo.pageNum']")[0];
	if (pageNum == null || pageNum.value.trim().length == 0 || !jQuery.isNumeric(pageNum.value.trim())) {
		alert("页数不能为空，且必须为数字！");
		jQuery("input[name='bookInfo.pageNum']:eq(0)").focus();
		return;
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/book/book_editBook.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: jQuery("#bookForm").serialize(),
		success: function(ret) {
			if (ret == null) {
				alert("修改书籍失败！");
				return;
			}
			if (ret.ret == 1) {
				alert(ret.reason);
				return;
			}
			alert("修改书籍成功！");
			location.href = "<%=ctx%>/book_zhizuo.jsp";
		},
		error: function() {
			alert("修改书籍失败！");
		}
	});
}

jQuery(function() {
	jQuery("select").each(function(idx) {
		jQuery(this).val(this.getAttribute("value"));
	});
	
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
	}
	
	<security:phoenixSec purviewCode="BOOK_UPLOAD">
	var isUpload = jQuery("input[name='isUpload']")[0].value;
	if (isUpload != null && isUpload == 1) {
		jQuery("#uploadBtn").val("更新");
	}
	</security:phoenixSec>
});

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
	} else {
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
}

</script>
</html>
