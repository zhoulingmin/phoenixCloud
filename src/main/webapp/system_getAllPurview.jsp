<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.math.*" %>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.system.service.ISysService" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
String ctx = (String) request.getContextPath();
WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
		WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
ISysService iSysService = (ISysService)context.getBean("sysServiceImpl");
IRBookMgmtService iBookService = (IRBookMgmtService)context.getBean("bookMgmtServiceImpl");
List<SysPurview> purviewList = (List<SysPurview>)request.getAttribute("purviewList");
if (purviewList == null) {
	purviewList = new ArrayList<SysPurview>();
}
List<SysStaffPurview> staffPurList = (List<SysStaffPurview>)request.getAttribute("staffPurList");
if (staffPurList == null) {
	staffPurList = new ArrayList<SysStaffPurview>();
}

List<SysStaffRegCode> staffRegCodeList = (List<SysStaffRegCode>)request.getAttribute("staffRegCodeList");
if (staffRegCodeList == null) {
	staffRegCodeList = new ArrayList<SysStaffRegCode>();
}

String tabId = (String)request.getAttribute("tabId");
if (tabId == null || tabId.isEmpty()) {
	tabId = "purviewTabTable";
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/select2.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle/zTreeStyle.css" type="text/css">
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/select2.min.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.tables.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.excheck-3.5.js"></script>
	
<title>权限管理</title>
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
				<ul class="nav nav-tabs">
					<li class="">
						<a href="#staffPurTab" data-toggle="tab">功能权限配置</a>
					</li>
				</ul>
			</div>
			<div class="widget-content tab-content" style="padding: 0px; border-left-width: 0px;">			
				<!-- 功能权限配置 -->
				<div id="staffPurTab" class="tab-pane" style="display:block">
					<div class="span6">
						<div class="widget-box">
							<div class="widget-title">
								<span class="icon">
									<i class="icon-user"></i>
								</span>
								<h5>账号列表</h5>
							</div>
							<div class="widget-content">
								<div id="agencyTree" class="ztree" style="padding: 0px;">
								</div>
							</div>
						</div>
					</div>
					<div class="span6">
						<div class="widget-box">
							<div class="widget-title">
								<span class="icon">
									<i class="icon-user"></i>
								</span>
								<h5>权限点列表</h5>
							</div>
							<div class="widget-content">
								<div id="purTree" class="ztree" style="padding: 0px;">
								</div>
							</div>
						</div>
					</div>
					<security:phoenixSec purviewCode="PURVIEW_CONF">
					<div class="span6" style="float: right;">
						<button class="btn btn-primary" type="button" style="margin-right: 20px; margin-bottom: 20px;" onclick="savePurCfg();">保存</button>
					</div>
					</security:phoenixSec>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
<script type="text/javascript">
var zAgencyTreeObj,
agencySetting = {
	view: {
		selectedMulti: false
	},
	check:{//复选框设置 
        enable:true,
        chkStyle:"checkbox",
		chkboxType:{"Y":"","N":""}
    },
	async: {
		enable: true,
		url: "<%=ctx%>/agency/agencyMgmt!getStaff.do",
		autoParam: ["type", "selfId"]
	},
	<security:phoenixSec purviewCode="PURVIEW_QUERY">
	callback: {
		onClick: onClickUser,
	}
	</security:phoenixSec>
},
zAgencyTreeNodes = [];

function onClickUser(event, treeId, treeNode, clickFlag) {
	if (treeNode.isParent) {
		return;
	}
	unCheckAll();
	jQuery.ajax({
		url: "<%=ctx%>/system/system_getPurByStaff.do",
		data: {selfId:treeNode.selfId},
		async: false,
		timeout: 30000,
		dataType: "JSON",
		success: function(ret) {
			if (ret == null || ret.length == 0) {
				alert("该用户无任何权限！");
				return;
			}
			jQuery(zPurTreeObj.getNodes()).each(function () {
				if (containsId(this.selfId, ret)) {
					zPurTreeObj.checkNode(this, true, false, false);
				}
				checkPurNodes(ret, this.children);
			});
		},
		error: function(XMLRequest, textInfo) {
			if (textInfo != null) {
				alert(textInfo);
			} else {
				alert("Unknown error!")
			}
		}
	});
}

function unCheckAll() {
	jQuery(zPurTreeObj.getNodes()).each(function() {
		zPurTreeObj.checkNode(this, false, true, false);
	});
}

function containsId(id, idArr) {
	var flag = false;
	jQuery(idArr).each(function() {
		if (this == id) {
			flag = true;
			return false;
		}
	});
	return flag;
}

function checkPurNodes(ret, children) {
	if (children != null && children.length > 0) {
		jQuery(children).each(function() {
			if (containsId(this.selfId, ret)) {
				zPurTreeObj.checkNode(this, true, false, false);
			}
			checkPurNodes(ret, this.children);
		});
	}
}


var zPurTreeObj,
purSetting = {
		view: {
			selectedMulti: false
		},
		check:{//复选框设置 
	        enable:true,
	        chkStyle:"checkbox",
			chkboxType:{"Y":"s","N":"s"}
	    },
		async: {
			enable: true,
			url: "<%=ctx%>/system/system_getAllPur.do",
			autoParam: ["selfId"]
		},
		callback: {
			onAsyncSuccess: onAsyncSuccess,
		}
	},
zPurTreeNodes = [];

function onAsyncSuccess(event, treeId, treeNode, msg) {
	zPurTreeObj.setting.async.enable=false;
}

var checkedUsers = null, checkedPurs = null;

function savePurCfg() {
	if (checkedUsers != null || checkedPurs != null) {
		alert("正在保存配置，请稍后重试！");
		return;
	}
	
	checkedUsers = zAgencyTreeObj.getCheckedNodes();
	if (checkedUsers == null || checkedUsers.length == 0) {
		checkedUsers = null;
		alert("请选择要配置的账号！");
		return;
	}
	
	checkedPurs = zPurTreeObj.getCheckedNodes();
	if (checkedPurs == null || checkedPurs.length == 0) {
		checkedUsers = null;
		checkedPurs = null;
		alert("请选择要配置的权限！");
		return;
	}
	
	var staffIdArr = "", purIdArr = "";
	jQuery(checkedUsers).each(function(idx) {
		staffIdArr += this.selfId;
		if (idx != (checkedUsers.length - 1)) {
			staffIdArr += ",";
		}
	});
	jQuery(checkedPurs).each(function(idx) {
		purIdArr += this.selfId;
		if (idx != (checkedPurs.length - 1)) {
			purIdArr += ",";
		}
	});
	
	jQuery.ajax({
		url: "<%=ctx%>/system/system_saveStaffPur.do",
		data: {staffIdArr:staffIdArr, purIdArr:purIdArr},
		async: true,
		timeout: 30000,
		success: function() {
			alert("保存配置权限成功！");
			checkedUsers = null;
			checkedPurs = null;
			window.location.reload(true);
		}, 
		error: function(XMLRequest, textInfo) {
			if (textInfo != null) {
				alert(textInfo);
			} else {
				alert("保存权限出错！");
			}
			checkedUsers = null;
			checkedPurs = null;
		}
	});
}

jQuery(document).ready(function() {
	
	zAgencyTreeObj = $.fn.zTree.init($("#agencyTree"), agencySetting, zAgencyTreeNodes);
	zPurTreeObj = $.fn.zTree.init($("#purTree"), purSetting, zPurTreeNodes);
	
	// 设置激活tab
	/*var activeTabId = "<%=tabId%>";
	jQuery("#" + activeTabId).addClass("active");
	if (activeTabId == "purviewTab") {
		jQuery(".nav-tabs > li:eq(0)").addClass("active");
	} else if (activeTabId == "staffPurTab") {
		jQuery(".nav-tabs > li:eq(1)").addClass("active");
	} else if (activeTabId == "staffRegCodeTab") {
		jQuery(".nav-tabs > li:eq(2)").addClass("active");
	}*/
	
});
</script>
</html>