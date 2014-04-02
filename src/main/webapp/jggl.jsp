<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getStaffId().toString());
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
<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="css/common.css" />
<link rel="stylesheet" href="css/page.css" />

<script src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/public.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.excheck-3.5.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="image/home_icon.jpg">&nbsp;个人信息管理&gt;机构管理
		</div>

		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				<form id="searchAgency" action="" method="POST">
					&nbsp;&nbsp;&nbsp;&nbsp;机构目录名称&nbsp;<input id="cataName" name="criteria.cataName" type="text" style="width:50px;"/>
					&nbsp;&nbsp;&nbsp;&nbsp;机构名称&nbsp;<input id="orgName" name="criteria.orgName" type="text" style="width:50px;"/>
					&nbsp;&nbsp;&nbsp;&nbsp;备注&nbsp;<input id="notes" name="criteria.notes" type="text" style="width:50px;"/>
					<security:phoenixSec purviewCode="ORG_MGMT_MENU">
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn btn-primary" value="搜索" type="button" onclick="searchAgency();" style="margin-bottom:10px;width:50px;"/>
					</security:phoenixSec>
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="reset-Btn" class="btn btn-primary" value="重置" type="reset" style="margin-bottom:10px;width:50px;"/>
				</form>
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				<security:phoenixSec purviewCode="ORG_DETAIL">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="viewAgency" onclick="popUpViewAgency();" value="详情"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="ORG_ADD">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="addAgency" onclick="popUpAddAgency();" value="新建"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="ORG_UPDATE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="removeAgency" onclick="removeAgency();" value="删除"/>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="ORG_REMOVE">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="editAgency" onclick="popUpEditAgency();" value="修改"/>
				</security:phoenixSec>
			</div>
		</div>		
		
		<div id="agencyTree" class="widget-box ztree">
		</div>
		
	</div>

</body>
<script type="text/javascript">
var zTreeObj,
setting = {
	view: {
		selectedMulti: false,
		dblClickExpand: false
	},
	check:{//复选框设置 
        enable:true,
        chkStyle:"checkbox",
		chkboxType:{"Y":"","N":""}
    },
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getAgency.do",
		autoParam: ["type", "selfId"]
	},
	// onAsyncError,onAsyncSuccess are used to deal with batch operation
	callback: {
		onRightClick: OnRightClick,
		onAsyncError: onAsyncError,
		onAsyncSuccess: onAsyncSuccess,
		onDblClick: onDblClick
	}
},
zTreeNodes = [];

function OnRightClick() {
	
}

function onDblClick(event, treeId, node) {
	var params = "height=";
	var title = null;
	var isCata = false;
	if (node.isParent) {
		params += "470,width=520,top=" + (window.screen.availHeight - 30 - 470) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
		title = "查看机构目录";
		isCata = true;
	} else {
		params += "500,width=520,top=" + (window.screen.availHeight - 30 - 500) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
		title = "查看机构";
	}
	params += ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open("<%=ctx%>/editAgency.jsp?isView=true&isCata=" + isCata + "&id=" + node.selfId, title, params);
}

var toDelNodes = null;
var checkedNodes = null;
var curStatus = "init";

function onAsyncSuccess(event, treeId, treeNode, msg) {
	if (curStatus == "init") {
		return;
	}
	if (curStatus == "add") {
		index++;
		if (index < checkedNodes.length) {
			zTreeObj.reAsyncChildNodes(checkedNodes[index], "refresh", false);
		} else {
			checkedNodes = null;
			curStatus = "";
		}
	} else if (curStatus == "edit") {
		index++;
		if (index < checkedNodes.length) {
			zTreeObj.reAsyncChildNodes(checkedNodes[index].getParentNode(), "refresh", false);
		} else {
			checkedNodes = null;
			curStatus = "";
		}
	} else if (curStatus == "remove") {
		index++;
		if (index < toDelNodes.length) {
			zTreeObj.reAsyncChildNodes(toDelNodes[index].getParentNode(), "refresh", false);
		} else {
			toDelNodes = null;
			curStatus = "";
		}
	}
}

function onAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {

	if (curStatus == "init") {
		return;
	}

	if (curStatus == "add") {
		index++;
		if (index < checkedNodes.length) {
			zTreeObj.reAsyncChildNodes(checkedNodes[index], "refresh", false);
		} else {
			checkedNodes = null;
			curStatus = "";
		}
	} else if (curStatus == "edit") {
		index++;
		if (index < checkedNodes.length) {
			zTreeObj.reAsyncChildNodes(checkedNodes[index].getParentNode(), "refresh", false);
		} else {
			checkedNodes = null;
			curStatus = "";
		}
	} else if (curStatus == "remove") {
		index++;
		if (index < toDelNodes.length) {
			zTreeObj.reAsyncChildNodes(toDelNodes[index].getParentNode(), "refresh", false);
		} else {
			toDelNodes = null;
			curStatus = "";
		}
	}
}

function popUpViewAgency() {
	if (checkedNodes != null || toDelNodes != null) {
		alert("请求处理中，请稍后...");
		return;
	}
	var chkCatas = zTreeObj.getNodesByFilter(function(node){
		return (node.isParent && node.checked);
	});
	var chkOrgs = zTreeObj.getNodesByFilter(function(node){
		return (!node.isParent && node.checked);
	});
	if (chkCatas.length > 0 && chkOrgs.length > 0) {
		alert("只能选择一个项目进行查看！");
		return;
	} else if (chkCatas.length == 0 && chkOrgs.length == 0) {
		alert("请至少选择一个项目进行查看！");
		checkedNodes = null;
		return;
	}
	var params = "height=";
	var title = null;
	var isCata = false;
	if (chkCatas.length > 0) {
		params += "470,width=520,top=" + (window.screen.availHeight - 30 - 470) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
		title = "查看机构目录";
		isCata = true;
		checkedNodes = chkCatas;
	} else {
		params += "500,width=520,top=" + (window.screen.availHeight - 30 - 500) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
		title = "查看机构";
		checkedNodes = chkOrgs;
	}
	params += ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open("<%=ctx%>/editAgency.jsp?isView=true&isCata=" + isCata + "&id=" + checkedNodes[0].selfId, title, params);
}

function popUpEditAgency() {
	if (checkedNodes != null || toDelNodes != null) {
		alert("请求处理中，请稍后...");
		return;
	}
	var chkCatas = zTreeObj.getNodesByFilter(function(node){
		return (node.isParent && node.checked);
	});
	var chkOrgs = zTreeObj.getNodesByFilter(function(node){
		return (!node.isParent && node.checked);
	});
	if (chkCatas.length > 0 && chkOrgs.length > 0) {
		alert("机构目录与机构不能同时修改！请重新选择！");
		return;
	} else if (chkCatas.length == 0 && chkOrgs.length == 0) {
		alert("请至少选择一个项目进行修改！");
		checkedNodes = null;
		return;
	}
	var params = "height=";
	var title = null;
	var isCata = false;
	if (chkCatas.length > 0) {
		params += "470,width=520,top=" + (window.screen.availHeight - 30 - 470) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
		title = "修改机构目录";
		isCata = true;
		checkedNodes = chkCatas;
	} else {
		params += "500,width=520,top=" + (window.screen.availHeight - 30 - 500) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
		title = "修改机构";
		checkedNodes = chkOrgs;
	}
	params += ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	window.open("<%=ctx%>/editAgency.jsp?isCata=" + isCata + "&id=" + checkedNodes[0].selfId, title, params);
}

function updateAgency(type, agencyName, createTime, notes, orgTypeId) {
	if (!checkedNodes) {
		return;
	}
	if (checkedNodes.length == 0 || (orgTypeId != null && checkedNodes[0].isParent)) {
		alert("修改出错，请刷新界面后重新尝试！");
		checkedNodes = null;
		return;
	}
	var params = "{type:\"" + type + "\""
	+ ", agencyName:\"" + agencyName + "\""
	+ ", createTime:\"" + createTime + "\""
	+ ", notes:\"" + notes + "\"";
	
	if (type == "org") { // 机构
		params += ", orgTypeId:\"" + orgTypeId + "\"";
	}
	
	params += ", cataId:\"";
	for (var i = 0; i < checkedNodes.length; i++) {
		params += checkedNodes[i].selfId;
		if (i != (checkedNodes.length - 1)) {
			params += ",";
		}
	}
	params += "\"}";
	jQuery.ajax({
		type: "POST",
		url: "<%=ctx%>/agency/agencyMgmt!updateAgency.do",
		data: eval("(" + params + ")"),
		async: "false",
		dataType: "json",
		timeout: 30000,
		success: function(){
			alert("修改成功！");
			// 更新节点数据
			index = 0;
			curStatus = "edit";
			zTreeObj.setting.async.enable = true;
			zTreeObj.reAsyncChildNodes(checkedNodes[index].getParentNode(), "refresh", false);
		},
		error: function() {
			alert("修改失败！");
			checkedNodes = null;
		}
	});
}

function popUpAddAgency() {
	if (checkedNodes != null || toDelNodes != null) {
		alert("请求处理中，请稍后！或刷新界面后，重试。");
		return;
	}
	checkedNodes = zTreeObj.getNodesByFilter(function(node){
		return (node.isParent && node.checked);
	});
	
	// open a dialog and get agency's basic information, then call parent's function
	// to find the new agency's parent cata id and create agency in db and add nodes
	// in the tree
	var params = "height=500,width=520,top=" + (window.screen.availHeight - 30 - 500) / 2 + ",left=" + (window.screen.availWidth - 10 - 520) / 2;
	params += ",toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no";
	var noChk = "false";
	if (checkedNodes.length == 0) {
		noChk = "true";
	}
	window.open("<%=ctx%>/addAgency.jsp?noChk=" + noChk, "创建机构目录或机构", params);
}

var index = 0;
function addAgency(type, name, notes, number, orgTypeId) {
	// 组织成一个长的字符串，然后post到后台
	// type,name,notes,number,cataId list
	if (!checkedNodes) {
		return;
	}
	if (orgTypeId != null && checkedNodes.length == 0) {
		alert("请先创建机构目录，再创建机构！");
		checkedNodes = null;
		return;
	}
	var params = "{type:\"" + type + "\""
		+ ", agencyName:\"" + name + "\""
		+ ", notes:\"" + notes + "\""
		+ ", number:\"" + number + "\"";
	
	if (type == "org") { // 机构
		params += ", orgTypeId:\"" + orgTypeId + "\"";
	}
	
	params += ", cataId:\"";
	
	for (var i = 0; i < checkedNodes.length; i++) {
		params += checkedNodes[i].selfId;
		if (i != (checkedNodes.length - 1)) {
			params += ",";
		}
	}
	if (checkedNodes.length == 0) { // 此时是创建顶级机构目录
		params += "0";
	}
	params += "\"}";
	jQuery.ajax({
		type: "POST",
		url: "<%=ctx%>/agency/agencyMgmt!addAgency.do",
		data: eval("(" + params + ")"),
		async: "false",
		dataType: "json",
		timeout: 30000,
		success: function(){
			alert("创建成功！");
			// 更新节点数据
			index = 0;
			curStatus = "add";
			zTreeObj.setting.async.enable = true;
			if (checkedNodes.length == 0) {
				zTreeObj.reAsyncChildNodes(null, "refresh", false);
			} else {
				zTreeObj.reAsyncChildNodes(checkedNodes[index], "refresh", false);
			}
			//checkedNodes = null;
		},
		error: function() {
			alert("创建失败！");
			checkedNodes = null;
		}
	});
}

function removeAgency() {
	if (toDelNodes != null || checkedNodes != null) {
		alert("请求处理中，请稍后！或刷新界面后，重试。");
		return;
	}
	if (zTreeObj.getCheckedNodes(true).length == 0) {
		alert("请先选择要删除的机构或机构目录！");
		return;
	}
	
	var checkedCataNodes = zTreeObj.getNodesByFilter(function(node){
		return (node.isParent && node.checked);
	});
	var bConfirmed = false;
	if (checkedCataNodes.length > 0) {
		if (confirm("您选中了机构目录，若删除将同时删除其下面的所有机构。 确认要删除吗?")) {
			bConfirmed = true;
		}
	} else {
		if (confirm("确认要删除选中的机构吗？")) {
			bConfirmed = true;
		}
	}
	if (bConfirmed) {
		// get nodes which are to be deleted
		toDelNodes = new Array();
		var chkNodes = zTreeObj.getCheckedNodes(true);
		for (var i = 0; i < chkNodes.length; i++) {
			var parentNode = chkNodes[i].getParentNode();
			var p0 = null;
			while(parentNode != null) {
				if (parentNode.checked) {
					p0 = parentNode;
					break;
				}
				parentNode = parentNode.getParentNode();
			}
			if (p0 != null) {
				continue;
			}
			toDelNodes.push(chkNodes[i]);
		}
		// organize params
		var params = "[";
		for (var i = 0; i < toDelNodes.length; i++) {
			var nodeObj = "{type:\"";
			if (toDelNodes[i].isParent) {
				nodeObj += "cata\", id:\"" + toDelNodes[i].selfId + "\"}";
			} else {
				nodeObj += "org\", id:\"" + toDelNodes[i].selfId + "\"}";
			}
			if (i != (toDelNodes.length - 1)) {
				nodeObj += ",";
			}
			params += nodeObj;
		}
		params += "]";
		jQuery.ajax({
			type: "POST",
			url: "<%=ctx%>/agency/agencyMgmt!removeAgency.do",
			data: {checkedNodes: params},
			async: "false",
			dataType: "json",
			timeout: 30000,
			success: function() {
				alert("删除成功！");
				// 更新节点
				index = 0;
				curStatus = "remove";
				zTreeObj.setting.async.enable = true;
				zTreeObj.reAsyncChildNodes(toDelNodes[index].getParentNode(), "refresh", false);
			},
			error: function() {
				alert("删除失败！");
				toDelNodes = null;
			}
		});
	}
}

function searchAgency() {
	var orgCataName = jQuery("#cataName").val();
	var orgName = jQuery("#orgName").val();
	var notes = jQuery("#notes").val();
	if (orgCataName.length == 0 && orgName.length == 0 && notes.length == 0) {
		setting.async.enable = true;
		zTreeObj.destroy();
		jQuery("#agencyTree").empty();
		zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
		return;
	}
	
	jQuery.ajax({
		type: "POST",
		url: "<%=ctx%>/agency/agencyMgmt!searchAgency.do",
		async: "true",
		timeout: 30000,
		data: jQuery("#searchAgency").serialize(),
		dataType: "json",
		success: function(data) {
			zTreeObj.destroy();
			jQuery("#agencyTree").empty();
			if (data.length != 0) {
				setting.async.enable = false;
				zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, data);
			} else {
				var noResult = "<div style=\"padding: 8px 35px 8px 14px; width: 48.7179%;\" class=\"row-fluid alert alert-info\">";
				noResult += "<strong>搜索结果：</strong>没有合适的机构或机构目录！";
				noResult += "<a href=\"#\" data-dismiss=\"alert\" class=\"close\">×</a></div>";
				jQuery("#agencyTree").append(jQuery(noResult));
			}
		},
		error: function() {
			alert("搜索失败！");
		}
	});
}

$(document).ready(function(){
	<security:phoenixSec purviewCode="ORG_MGMT_MENU">
	zTreeObj = $.fn.zTree.init($("#agencyTree"), setting, zTreeNodes);
	</security:phoenixSec>
});
</script>
</html>
