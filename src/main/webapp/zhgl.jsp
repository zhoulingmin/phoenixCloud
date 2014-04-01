<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>

<%
String ctx = request.getContextPath();
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(staff.getOrgId().toString());
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
<link rel="stylesheet" href="css/common.css" />
<link rel="stylesheet" href="css/page.css" />
<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css"
	type="text/css">


<script src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript"
	src="<%=ctx %>/js/ztree/jquery.ztree.core-3.5.js"></script>

</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="image/home_icon.jpg">&nbsp;个人信息管理&gt;账号管理&gt;首页
		</div>
		<div class="zhgl">
			<!--左侧菜单-->
			<div class="left_dtree" style="width:20%;overflow:scroll">
				<div class="tree_title margin_top_15" style="width:100%">机构</div>
				<div id="agencyTree" class="ztree"></div>
			</div>
			<!--左侧菜单-->
			<!--右侧内容-->
			<div class="rcontent margin_top_20"
				style="float: right; width: 79%; margin-top: -730px;overflow:scroll">
				<div class="box_info1 margin_bottom_20">
					<div class="line_title margin_top_5">
						<img src="image/user_photo.jpg">&nbsp;用户
					</div>
					<div class="line_btn margin_top_10">
						<input type="button" value="显示全部" class="btn btn-primary" onclick="getAll();">&nbsp;&nbsp;
						<input type="button" value="增加" class="btn btn-primary" onclick="addUser();">&nbsp;&nbsp;
						<input type="button" value="编辑" class="btn btn-primary" onclick="editUser();">&nbsp;&nbsp;
						<input type="button" value="删除" class="btn btn-primary" onclick="delUser();">
					</div>
				</div>
				<table class="list_table1">
					<thead>
						<tr>
							<th style='width:1%'><input type="checkbox" id="titleChk" onchange="checkAll(this)"></th>
							<th>用户名</th>
							<th>账号</th>
							<th>创建时间</th>
							<th>所属机构</th>
							<th>是否有效</th>
						</tr>
					</thead>
					<tbody id="userTblBody">
						<tr>
							<td colspan="5">请点击某个机构，进行用户搜索！</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--右侧内容-->
		</div>
	</div>
</body>

<script type="text/javascript">

function getAll() {
	if (isLoadingUser) {
		alert("正在加载用户数据，请稍后！");
		return;
	}
	
	isLoadingUser = true;
	jQuery.ajax({
		url: "<%=ctx%>/system/getAllUser.do",
		dataType: "json",
		timeout: 30000,
		async: false,
		success: function(userArr) {
			if (userArr == null || userArr.length == 0) {
				alert("加载用户数据失败！");
				return;
			}
			
			jQuery("#userTblBody").children("tr").remove();
			jQuery(userArr).each(function() {
				var trElm = "<tr>" ;
				trElm += "<td style='width:1%'><input type='checkbox' staffId='" + this.id + "'/></td>";
				trElm += "<td>" + this.name + "</td>";
				trElm += "<td>" + this.code + "</td>";
				trElm += "<td>" + this.createTime + "</td>";
				trElm += "<td>" + this.orgName + "</td>";
				trElm += "<td>" + this.isExpired + "</td>";
				trElm += "</tr>";
				jQuery("#userTblBody").append(trElm);
			});
			isLoadingUser = false;
		},
		error: function(req,txt) {
			alert("加载用户失败！");
			isLoadingUser = false;
		}
	});
}

function addUser() {
	window.location.href = "<%=ctx%>/zhgl_add.jsp";
}

function editUser() {
	var chkNodes = jQuery("#userTblBody>tr>td>input:checked");
	if (chkNodes.length == 0) {
		alert("请选择要操作的用户！");
		return;
	}
	
	if (chkNodes.length > 1) {
		alert("请只选择一个用户进行编辑！");
		return;
	}
	
	window.location.href = "<%=ctx%>/system/editAccount.do?staff.staffId=" + chkNodes[0].getAttribute("staffId");
}

var selNodes = null;
function delUser() {
	if (selNodes != null) {
		alert("正在删除用户，请稍后！");
		return;
	}
	selNodes = jQuery("#userTblBody>tr>td>input:checked");
	if (selNodes.length == 0) {
		alert("请选择要操作的用户！");
		return;
	}
	var ids = "";
	jQuery(selNodes).each(function(idx){
		ids += this.getAttribute("staffId");
		if (idx != (selNodes.length - 1)) {
			ids += ",";
		}
	});
	jQuery.ajax({
		url: "<%=ctx%>/system/system_removeUser.do",
		type: "POST",
		async: "false",
		timeout: 30000,
		data: {userIdArr:ids},
		success: function() {
			alert("删除成功！");
			jQuery(selNodes).parents("tr").remove();
			selNodes = null;
		},
		error: function() {
			alert("删除失败！");
			selNodes = null;
		}
	});
}

function checkAll(which) {
	if (which.checked) {
		jQuery("#userTblBody>tr>td>input:checkbox").attr("checked","checked");
	} else {
		jQuery("#userTblBody>tr>td>input:checkbox").removeAttr("checked");
	}
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

var isLoadingUser = false;
function onSelOrg(event, treeId, treeNode, clickFlag) {
	if (treeNode != null && !treeNode.isParent) {
		if (isLoadingUser) {
			alert("正在加载用户数据，请稍后！");
			return;
		}
		isLoadingUser = true;
		jQuery.ajax({
			url: "<%=ctx%>/system/getAllUser.do",
			data: {selfId:treeNode.selfId},
			dataType: "json",
			timeout: 30000,
			async: false,
			success: function(userArr) {
				if (userArr == null || userArr.length == 0) {
					alert("加载用户数据失败！");
					return;
				}
				
				jQuery("#userTblBody").children("tr").remove();
				jQuery(userArr).each(function() {
					var trElm = "<tr>" ;
					trElm += "<td style='width:1%'><input type='checkbox' staffId='" + this.id + "'/></td>";
					trElm += "<td>" + this.name + "</td>";
					trElm += "<td>" + this.code + "</td>";
					trElm += "<td>" + this.createTime + "</td>";
					trElm += "<td>" + this.orgName + "</td>";
					trElm += "<td>" + this.isExpired + "</td>";
					trElm += "</tr>";
					jQuery("#userTblBody").append(trElm);
				});
				isLoadingUser = false;
			},
			error: function(req,txt) {
				alert("加载用户失败！");
				isLoadingUser = false;
			}
		});
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
