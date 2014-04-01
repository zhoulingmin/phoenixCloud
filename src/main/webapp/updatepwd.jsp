<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.ctrl.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s" %>
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
<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>

</head>

<body>
  
     <div class="local">当前机构：<%=org.getOrgName() %></div>
      <div class="right_main">
         <div class="head">
           <img src="<%=ctx %>/image/home_icon.jpg">&nbsp;个人信息管理&gt;修改密码&gt;首页
         </div>
         <form id="modifyPassFrm" action="" method="POST">
         <input type="hidden" name="staff.staffId" value="<s:property value="staff.staffId"/>" />
         <div class="box_main">
            <div class="line_info  margin_top_25"></div>
             <div class="line_info  margin_top_25"></div>
          <div class="line_info  margin_top_25"></div>
            <div class="line_info margin_top_10"><font class="blue">&nbsp;&nbsp;当前密码：</font>
            <input type="password" class="txts" value="<s:property value="staff.password"/>" /><font class="grey"> 6-12位数字、字母、下划线，区分大小写</font></div>
            <div class="line_info margin_top_10"><font class="blue">&nbsp;&nbsp;&nbsp;&nbsp;新密码：</font> <input id="pass1" type="password" name="staff.password" class="txts" placeholder="新密码"></div>
            <div class="line_info margin_top_10"><font class="blue"> 确认新密码：</font> <input id="pass2" type="password" class="txts" placeholder="再次输入新密码"></div>
            <div class="line_info margin_top_25">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="保存" class="btn btn-primary" onclick="savePass();"></div>
         </div>
         </form>
       </div>

</body>
<script type="text/javascript">
var saving = false;
function savePass() {
	
	if (saving) {
		alert("正在保存，请稍后！");
		return;
	}
	saving = true;
	
	if (jQuery("#pass1").val().trim().length == 0) {
		alert("密码不能为空！");
		jQuery("#pass1").focus();
		saving = false;
		return;
	}
	
	if (jQuery("#pass1").val() != jQuery("#pass2").val()) {
		alert("两次输入的新密码要一致！");
		jQuery("#pass1").focus();
		saving = false;
		return;
	}
	
	jQuery.ajax({
		url: "<%=ctx%>/system/system_savePass.do",
		data: jQuery("#modifyPassFrm").serialize(),
		timeout: 30000,
		async: true,
		success: function() {
			alert("修改密码成功！");
			location.href.reload(true);
			saving = false;
		},
		error: function(req, txt) {
			alert("修改密码失败！")
			saving = false;
		}
	});
}

</script>
</html>
