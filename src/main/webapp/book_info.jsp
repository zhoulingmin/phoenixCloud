<%@page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s"%>

<%
ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff curStaff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(curStaff.getOrgId().toString());

String ctx = (String) request.getContextPath();
PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);


String orgId = vs.findString("bookInfo.orgId");
String orgName = "";
PubOrg orgBean = orgDao.find(orgId);
if (orgBean != null) {
	orgName = orgBean.getOrgName();
}

String pressName = "";
PubPress press = pressDao.find(vs.findString("bookInfo.pressId"));
if (press != null) {
	pressName = press.getName();
}

String subName = "";
PubDdv ddv = ddvDao.find(vs.findString("bookInfo.subjectId"));
if (ddv != null) {
	subName = ddv.getValue();
}

String stuName = "";
ddv = ddvDao.find(vs.findString("bookInfo.stuSegId"));
if (ddv != null) {
	stuName = ddv.getValue();
}

String clsName = "";
ddv = ddvDao.find(vs.findString("bookInfo.classId"));
if (ddv != null) {
	clsName = ddv.getValue();
}

String kindName = "";
ddv = ddvDao.find(vs.findString("bookInfo.kindId"));
if (ddv != null) {
	kindName = ddv.getValue();
}

String staffName = "";
SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
SysStaff staff = staffDao.find(vs.findString("bookInfo.staffId"));
if (staff != null) {
	staffName = staff.getName();
}

String isUpload = "未上传";
if ((Byte)vs.findValue("bookInfo.isUpload") == (byte)1) {
	isUpload = "已上传";
}

String isAudit = "";
byte audit = (Byte)vs.findValue("bookInfo.isAudit");
if (audit == (byte)-1) {
	isAudit = "制作中";
} else if (audit == (byte)0) {
	isAudit = "待审核";
} else if (audit == (byte)1) {
	isAudit = "待上架";
} else if (audit == (byte)2) {
	isAudit = "已上架";
} else if (audit == (byte)3) {
	isAudit = "已下架";
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
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />

<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>

</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍管理&gt;书籍详情
		</div>
		
		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-book"></i></span>
				<h5>书籍信息</h5>
			</div>
			<div class="widget-content" style="margin-left:20px">
				<div class="line_info margin_top_5">
					<font class="blue">书籍名称: </font>
					<font color="black"><s:property value="bookInfo.name"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">书籍编码: </font>
					<font color="black"><s:property value="bookInfo.bookNo"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">机构: </font>
					<font color="black"><%=orgName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">出版社名称: </font>
					<font color="black"><%=pressName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">学科: </font>
					<font color="black"><%=subName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">学段: </font>
					<font color="black"><%=stuName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">年级: </font>
					<font color="black"><%=clsName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">册别: </font>
					<font color="black"><%=kindName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">页数: </font>
					<font color="black"><s:property value="bookInfo.pageNum"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">服务器IP: </font>
					<font color="black"><s:property value="bookInfo.ipAddr"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">书全地址: </font>
					<font color="black"><s:property value="bookInfo.allAddr"/></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">是否上传: </font>
					<font color="black"><%=isUpload %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">审核状态: </font>
					<font color="black"><%=isAudit%></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">创建时间: </font>
					<font color="black"><s:date name="bookInfo.createTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">更新时间: </font>
					<font color="black"><s:date name="bookInfo.updateTime" format="yyyy/MM/dd HH:mm:ss" /></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">账号: </font>
					<font color="black"><%=staffName %></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">备注: </font>
					<font color="black"><s:property value="bookInfo.notes"/></font>
				</div>
				<div class="line_info margin_top_5">
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">返回</button>
				</div>
			</div>
		</div>

	</div>
</body>

<script type="text/javascript">
function saveUser() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_saveUser.do",
		data: jQuery("#editUser").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("修改账号成功！");
			window.parent.location.reload(true);
		},
		error: function() {
			alert("修改账号失败！");
		}
	});
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
		jQuery(jQuery("input[name='staff.orgId']")[0]).val(treeNode.selfId);
		jQuery(jQuery("input[name='orgNameTmp']")[0]).val(treeNode.name);
		// 2. hide
		jQuery("#agencyTree").css("display", "none");
	}
}

$(function() {	
	jQuery("select").each(function(idx) {
		jQuery(this).val(this.getAttribute("value"));
	});
	
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
});

</script>

</html>


