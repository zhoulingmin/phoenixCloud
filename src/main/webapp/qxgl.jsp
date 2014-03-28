<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@page import="com.phoenixcloud.dao.res.*" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.system.service.ISysService" %>
<%@page import="com.phoenixcloud.book.service.IRBookMgmtService" %>
<%@taglib uri="/struts-tags" prefix="s"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>

<%
ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff curStaff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(curStaff.getOrgId().toString());

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
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />

<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=ctx%>/js/ztree/jquery.ztree.excheck-3.5.js"></script>

</head>

<body>
	<div class="local">
		当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;权限管理&gt;权限配置
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
			window.parent.location.reload(true);
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
	
});
</script>
</html>


