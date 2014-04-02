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
PubOrg org = orgDao.find(vs.findString("staff.orgId"));

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
<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/ztree/jquery.ztree.core-3.5.js"></script>



</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;个人信息管理&gt;个人资料
		</div>
		<div class="box_main">
			<form id="editUser" action="" method="POST">
				<input type="hidden" name="staff.staffId" value="<s:property value="staff.staffId"/>" />
				<div style="display:none" class="line_info red margin_top_15">说明：以下所有内容为必填项。</div>
				<div class="line_info margin_top_25"></div>
				<div class="line_info margin_top_25"></div>
				<div class="line_info margin_top_25"></div>
				<div class="line_info">
					<font class="blue">登录名：</font><font class="grey"><s:property
							value="staff.code" /></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">邮箱：</font><font class="black"><input type="text"
						name="staff.email" value="<s:property value="staff.email"/>" /></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">姓名：</font> <input name="staff.name" type="text"
						class="txts" value="<s:property value="staff.name"/>" /><font
						class="red"></font>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">所属单位：</font> <input type="text" name="orgNameTmp" value="<%=org.getOrgName() %>" onfocus="onfocusOrg()"  /> 
					<input type="hidden" name="staff.orgId" value="<s:property value="staff.orgId"/>">
					<div id="agencyTree" class="widget-box ztree" style="display:none;">
					</div>
				</div>
				<!--
				<div class="line_info margin_top_5">
					<font class="blue">单位地址：</font> <input type="text" class="txts1">
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">学段：</font> <select class="select">
						<option>小学</option>
						<option>初中</option>
						<option>高中</option>
					</select>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">年级：</font> <select class="select">
						<option>小学</option>
						<option>初中</option>
						<option>高中</option>
					</select>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">学科：</font> <select class="select">
						<option>小学</option>
						<option>初中</option>
						<option>高中</option>
					</select>
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">性别：</font> <input type="radio" name="1">
					男 <input type="radio" name="1"> 女
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">联系电话：</font> <input type="text" class="txts">
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">QQ：</font> <input type="text" class="txts">
				</div>
				<div class="line_info margin_top_5">
					<font class="blue">通信地址：</font> <input type="text" class="txts1">
				</div>
				-->
				<div class="line_info margin_top_25">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="btn btn-primary" value="保存" onclick="saveUser();">
				</div>
			</form>
		</div>
	</div>

</body>

<script type="text/javascript">
function saveUser() {
	jQuery.ajax({
		url: "<%=ctx%>/system/saveSelf.do",
		data: jQuery("#editUser").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("修改账号成功！");
			window.location.reload(true);
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


