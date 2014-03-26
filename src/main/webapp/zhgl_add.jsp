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
List<PubDdv> staffTypeList = ddvDao.findByTblAndField("sys_staff", "STAFF_TYPE_ID");

%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-datetimepicker.min.css"/>

<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script src="<%=ctx%>/js/bootstrap-datetimepicker.min.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;账号管理&gt;编辑账号
		</div>

		<div class="widget-box">
			<div class="widget-title">
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>录入账号信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="addUser" class="form-horizontal" method="POST" action="#">
				
					<div class="control-group">
						<label class="control-label">账号编码 (登陆名)</label>
						<div class="controls">
							<input type="text" name="staff.code" onchange="checkExists()">
						</div>
					</div>
				
					<div class="control-group">
						<label class="control-label">账号名称 (昵称)</label>
						<div class="controls">
							<input type="text" name="staff.name" value="">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号密码</label>
						<div class="controls">
							<input type="password" name="staff.password" value="">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">机构标识</label>
						<div class="controls">
							<input type="text" name="orgNameTmp" onfocus="onfocusOrg()" >
							<input type="hidden" name="staff.orgId" >
							<div id="agencyTree" class="widget-box ztree" style="display:none; width:80%">
							</div>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号类型标识</label>
						<div class="controls">
							<select name="staff.staffTypeId">
							<%for (PubDdv staffType : staffTypeList) { %>
								<option value="<%=staffType.getDdvId() %>"><%=staffType.getValue() %></option>
							<%} %>
							</select>
						</div>
					</div>
					
					<div id="datetimepicker1" class="control-group input-append date">
						<label class="control-label">有效期</label>
						<div class="controls">
							<input data-format="yyyy/MM/dd" type="text" name="staff.validDate">
							<span class="add-on">
						      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
						      </i>
						    </span>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">备注</label>
						<div class="controls">
							<input type="text" name="staff.notes">
						</div>
					</div>
					
					<div class="form-actions">
						<button class="btn btn-primary" type="button"  onclick="addUser();">创建</button>
						<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();"></button>
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
			location.href = "<%=ctx%>/zhgl.jsp";
		},
		error: function() {
			location.href = "<%=ctx%>/zhgl.jsp";
		}
	});
}

function addUser() {
	jQuery.ajax({
		url: "<%=ctx%>/system/system_addUser.do",
		data: jQuery("#addUser").serialize(),
		type: "POST",
		async: "false",
		timeout: 30000,
		success: function() {
			alert("创建账号成功！");
			location.href = "<%=ctx%>/zhgl.jsp";
		},
		error: function() {
			alert("创建账号失败！");
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
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
	
	jQuery("#datetimepicker1").datetimepicker({
		language : 'pt-BR'
	});
	$($(".add-on")[0]).on("click", "i", function(e){
		$($(".bootstrap-datetimepicker-widget")[0]).css("top", $(e.target.parentNode).offset().top);
		$($(".bootstrap-datetimepicker-widget")[0]).css("left", $(e.target.parentNode).offset().left + $(e.target.parentNode).width());
	});
});
</script>
</html>