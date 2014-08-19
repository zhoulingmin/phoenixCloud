<%@page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.text.*"%>
<%
String ctx = request.getContextPath();
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(staff.getOrgId().toString());

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubHw> hwList = (List<PubHw>)request.getAttribute("hwList");
if (hwList == null) {
	hwList = new ArrayList<PubHw>();
}
List<PubHwNum> hwNumList = (List<PubHwNum>)request.getAttribute("hwNumList");
if (hwNumList == null) {
	hwNumList = new ArrayList<PubHwNum>();
}

PubHwDao hwDao = (PubHwDao)SpringUtils.getBean(PubHwDao.class); 
List<PubDdv> ddvList = ddvDao.findByTblAndField("pub_hardware", "HW_TYPE");

SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
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
<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css"
	type="text/css">
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />

<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>

<style type="text/css">
td {padding-top: 2px; padding-bottom: 2px;}
</style>
	
</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;个人信息管理&gt;授权信息
		</div>

		<div class="widget-box">
			<div class="widget-content" style="white-space: nowrap">
				<form id="searchHw" action="" method="POST">
					&nbsp;&nbsp;&nbsp;&nbsp;账号&nbsp; <input type="text" id="staffName"
						onfocus="onFocusStaffName();" />
					&nbsp;&nbsp;&nbsp;&nbsp;硬件类型&nbsp; <select id="hwType"
						name="criteria.hwType" style="width: 100px">
						<option value="-1" selected="selected">全部</option>
						<%for (PubDdv ddv : ddvList) {%>
						<option value="<%=ddv.getDdvId()%>"><%=ddv.getValue() %></option>
						<%} %>
					</select> &nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn"
						class="btn btn-primary" value="搜索" type="button"
						onclick="searchHw();" style="margin-bottom: 10px; width: 50px;" />
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="reset-Btn"
						class="btn btn-primary" value="重置" type="reset"
						style="margin-bottom: 10px; width: 50px;" /> <input type="hidden"
						id="staffId" name="criteria.staffId" type="text"
						style="width: 50px;" />
					<div id="agencyTree" class="widget-box ztree"
						style="display: none; width: 80%"></div>
				</form>
			</div>
		</div>

		<div class="widget-box">
			<div class="widget-content">
				<table class="list_table location_center" style="margin-top: 0px;">
					<thead>
						<tr>
							<th>机构</th>
							<th>用户名</th>
							<th>硬件类型</th>
							<th>已授权数量</th>
							<th>授权总数</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="hwNumTblBody">
						<%for (PubHwNum num : hwNumList) {
            			PubDdv ddv = ddvDao.find(num.getHwType().toString());
            			SysStaff staffTmp = staffDao.find(num.getStaffId().toString());
            			PubOrg orgTmp = orgDao.find(staffTmp.getOrgId().toString());
            			if (ddv == null || staffTmp == null || orgTmp == null) {
            				continue;
            			}
            		%>
						<tr>
							<td><%=orgTmp.getOrgName() %></td>
							<td><%=staffTmp.getName() %></td>
							<td><%=ddv.getValue() %></td>
							<td><%=hwDao.getCountOfHw(new BigInteger(staff.getStaffId()), num.getHwType()) %></td>
							<td><input type="text" readonly="readonly" style="margin-bottom:0px;padding:0px;"
								value="<%=num.getNum() %>" /></td>
							<td><a href="#">设置</a>&nbsp;&nbsp;<a href="#"
								hwId="<%=num.getHwId() %>" style="display: none">保存</a></td>
						</tr>
						<%} %>
					</tbody>
				</table>

				<table class="list_table location_center">
					<thead>
						<tr>
							<th>序号</th>
							<th>机构</th>
							<th>用户名</th>
							<th>授权日期</th>
							<th>类型</th>
							<th>硬件序列号</th>
						</tr>
					</thead>
					<tbody>
						<%
					int num = 0;
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					for (PubHw hw : hwList) { 
						num++;
						PubDdv ddv = ddvDao.find(hw.getHwType().toString());
						SysStaff staffTmp = staffDao.find(hw.getStaffId().toString());
            			PubOrg orgTmp = orgDao.find(staffTmp.getOrgId().toString());
					%>
						<tr>
							<td><%=num %></td>
							<td><%=orgTmp.getOrgName() %></td>
							<td><%=staffTmp.getName() %></td>
							<td><%=sdf.format(hw.getCreateTime()) %></td>
							<td><%=ddv.getValue()%></td>
							<td><%=hw.getCode() %></td>
						</tr>
						<%} %>
					</tbody>
				</table>
			</div>
		</div>
		<div class="line_info  margin_top_25"></div>
		<div class="line_info  margin_top_25"></div>
	</div>
</body>
<script type="text/javascript">

function searchHw() {
	location.href = "<%=ctx%>/system/searchHw.do?criteria.staffId=" + jQuery("#staffId").val() + "&criteria.hwType=" + jQuery("#hwType").val();
}

function onFocusStaffName() {
	jQuery("#agencyTree").css("display", "block");
}

var zTreeObj,
setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getStaff.do?isClient=true",
		autoParam: ["type", "selfId"]
	},
	callback: {
		onClick: onSelUser
	}
},
zTreeNodes = [];

function onSelUser(event, treeId, treeNode, clickFlag) {
	if (treeNode != null && !treeNode.isParent) {
		// 1. set org field value
		jQuery("#staffId").val(treeNode.selfId);
		jQuery("#staffName").val(treeNode.name);
		// 2. hide
		jQuery("#agencyTree").css("display", "none");
	}
}

$(function() {
	jQuery.ajax({
		type:"get",
		url: "<%=ctx%>/agency/agencyMgmt!getUpperTree.do",
		async: "true",
		data: {orgAsCata:true},
		timeout: 30000,
		dataType: "json",
		success: function(data) {
			if (data == null) {
				alert("加载数据出错！");
				return;
			}
			zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, data);
		},
		error: function() {
			alert("加载数据出错！");
		}
	});
	jQuery("#agencyTree").on("blur", function(event) {
		jQuery(this).css("display", "none");
	});
	
	// set
	jQuery("#hwNumTblBody tr td:last-child a:first-child").on("click", function(evt) {
		jQuery(this).parents("tr").find("input").removeAttr("readonly");
		jQuery(this).parent().children("a:eq(1)").css("display", "inline");
		return false;
	});
	
	// save
	jQuery("#hwNumTblBody tr td:last-child a:last-child").on("click", function(evt){
		var num = jQuery(this).parents("tr").find("input:eq(0)").val();
		jQuery.ajax({
			url: "<%=ctx%>/system/saveHwNum.do",
			data: {"hwNum.hwId":this.getAttribute("hwId"), "hwNum.num":num},
			timeout:30000,
			async: "false",
			dataType: "json",
			success: function(ret) {
				if (ret == null) {
					alert("设置失败！");
					return;
				}
				alert("设置成功！");
				var node = jQuery("#hwNumTblBody").find("a[hwId='" + ret.hwId + "']");
				if (node.length != 1) {
					return;
				}
				jQuery(node[0]).css("display", "none");
				jQuery(node[0]).parents("tr").find("input").attr("readonly", "readonly");
			},
			error: function() {
				alert("设置失败！");
			}
		});
	});
});	
</script>
</html>
