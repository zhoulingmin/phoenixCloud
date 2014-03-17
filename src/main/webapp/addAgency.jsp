<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="com.phoenixcloud.dao.ctrl.PubDdvDao" %>
<%@page import="com.phoenixcloud.bean.PubDdv" %>
<%@page import="java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String ctx = request.getContextPath();
	String noChk = request.getParameter("noChk");
	PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
	List<PubDdv> ddvList = ddvDao.findByTblAndField("pub_org", "ORG_TYPE_ID");
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/fullcalendar.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/select2.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<script src="<%=ctx%>/js/excanvas.min.js"></script>
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/select2.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script src="<%=ctx%>/js/global.js"></script>
	<style type="text/css">
	span.addAgency, div.addAgency {
		display:block;
	}
	span, input{
		margin-left:20px;
	}
	body {
		background:none repeat scroll 0 0 #EEEEEE;
		margin-top:10px;
	}
	</style>
	<title>创建机构目录或机构</title>

</head>
<body>
	<%if ("false".equals(noChk)){ %>
	<span class="addAgency">类型:
	<%} else { %>
	<span class="addAgency" style="display:none">类型:
	<%} %>
	<select id="type" onchange="selectType(this);">
		<option value="cata" selected="selected">机构目录</option>
		<option value="org">机构</option>
	</select></span>
	<span class="addAgency">机构目录名:<input type="text" id="agencyName" name="agencyName" value=""></span>
	<span class="addAgency" id="orgType" style="display:none">机构类型:
		<select id="orgTypeId">
			<%for(PubDdv ddv : ddvList) { %>
			<option value="<%=ddv.getDdvId() %>" ><%=ddv.getValue() %></option>
			<%} %>
		</select>
	</span>
	<span class="addAgency">备注:<textarea id="agencyNotes" name="agencyNotes" maxlength="255" style="width: 296px; height: 255px;"></textarea></span>
	<span class="addAgency">数目:<input type="text" id="number" name="number" value="1" /></span>
	<input style="margin-left:230px" class="btn" type="button" name="save" onclick="addAgency();" value="创建" />
	<input type="button" name="cancel" class="btn" onclick="self.close();" value="取消" />
	
	
</body>
<script type="text/javascript">

	function selectType(which) {
		if (which.value == "cata") { // 机构目录
			jQuery("#orgType").css("display", "none");
			jQuery(jQuery(".addAgency")[1]).html(jQuery(jQuery(".addAgency")[1]).html().replace("机构名:", "机构目录名:"));
		} else { // 机构
			jQuery("#orgType").css("display", "block");
			jQuery(jQuery(".addAgency")[1]).html(jQuery(jQuery(".addAgency")[1]).html().replace("机构目录名:", "机构名:"));
		}
	}

	var isCreating = false;
	
	function addAgency() {
		if (self.opener.addAgency != null) {
			self.opener.addAgency(
				jQuery("#type").val(), // 类型
				jQuery("#agencyName").val(), // 名称
				jQuery("#agencyNotes").val(), // 备注
				jQuery("#number").val(),  // 数目
				(jQuery("#type").val() == "org") ? jQuery("#orgTypeId option:selected").val() : null
			);
			isCreating = true;
			self.close();
		}
	}
	
	window.onbeforeunload = function() {
		if (!isCreating) {
			self.opener.checkedNodes = null;
		}
	}
	
	jQuery(document).ready(function(){
		jQuery("#orgTypeId option:first").prop("selected", "selected");
	});
</script>

</html>