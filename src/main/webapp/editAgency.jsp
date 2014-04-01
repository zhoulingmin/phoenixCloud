<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="com.phoenixcloud.bean.PubOrg"%>
<%@page import="com.phoenixcloud.bean.PubOrgCata"%>
<%@page import="com.phoenixcloud.agency.service.IAgencyMgmtService" %>
<%@page import="com.phoenixcloud.util.MiscUtils" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.math.BigInteger" %>
<%@page import="com.phoenixcloud.dao.ctrl.PubDdvDao" %>
<%@page import="com.phoenixcloud.bean.PubDdv" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.List" %>
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String ctx = request.getContextPath();
	boolean isCata = true;
	try{
		isCata = Boolean.parseBoolean((String)request.getParameter("isCata"));
	} catch (Exception e) {
		MiscUtils.getLogger().info(e.toString());
	}
	boolean isView = false;
	try {
		isView = Boolean.parseBoolean((String)request.getParameter("isView"));
	} catch (Exception e) {
		MiscUtils.getLogger().info(e.toString());
	}

	String id = request.getParameter("id");
	
	String agencyName = null;
	String createTime = null;
	String updateTime = null;
	int deleteSatus = 0;
	int orgTypeId = 1;
	String notes = null;
	String parentName = null;
	
	WebApplicationContext context = (WebApplicationContext)this.getServletContext().getAttribute(
			WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
	IAgencyMgmtService iAgencyMgmt = (IAgencyMgmtService)context.getBean("agencyMgmtServiceImpl");
	PubOrg pubOrg = null;
	PubOrgCata pubOrgCata = null;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	String parentId = "0";
	if (isCata) {
		pubOrgCata = iAgencyMgmt.findOrgCataById(id);
		agencyName = pubOrgCata.getCataName();
		createTime = sdf.format(pubOrgCata.getCreateTime());
		updateTime = sdf.format(pubOrgCata.getUpdateTime());
		deleteSatus = pubOrgCata.getDeleteState();
		notes = pubOrgCata.getNotes();
		parentId = pubOrgCata.getParentCataId().toString();
	} else {
		pubOrg = iAgencyMgmt.findOrgById(id);
		agencyName = pubOrg.getOrgName();
		orgTypeId = pubOrg.getOrgTypeId().intValue();
		createTime = sdf.format(pubOrg.getCreateTime());
		updateTime = sdf.format(pubOrg.getUpdateTime());
		notes = pubOrg.getNotes();
		deleteSatus = pubOrg.getDeleteState();
		parentId = pubOrg.getPubOrgCata().getId();
	}
	pubOrgCata = iAgencyMgmt.findOrgCataById(parentId);
	if (pubOrgCata == null) {
		parentName = "无";
	} else {
		parentName = pubOrgCata.getCataName();
	}
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
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-datetimepicker.min.css"/>
	<script src="<%=ctx%>/js/excanvas.min.js"></script>
	<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/select2.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/jquery.dataTables.min.js"></script>
	<script src="<%=ctx%>/js/global.js"></script>
	<script src="<%=ctx%>/js/bootstrap-datetimepicker.min.js"></script>
	<style type="text/css">
	span.editAgency {
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
	<%if (!isView) {%>
		<%if (isCata) {%>
		<title>修改机构目录</title>
		<%} else { %>
		<title>修改机构</title>
		<%} %>
	<%} else { %>
		<%if (isCata) {%>
		<title>查看机构目录</title>
		<%} else { %>
		<title>查看机构</title>
	<%} %>
	<%} %>
</head>
<body>
	<%if(isCata) {%>
	<span class="editAgency">机构目录名:<input type="text" id="agencyName" name="agencyName" value="<%=agencyName%>"></span>
	<span class="editAgency" style="display:none">机构类型:
	<%}else{ %>
	<span class="editAgency">机构名:<input type="text" id="agencyName" name="agencyName" value="<%=agencyName%>"></span>
	<span class="editAgency" style="display:block">机构类型:
	<%} %>
		<select id="orgTypeId">
			<%for (PubDdv ddv : ddvList) { %>
			<option value="<%=ddv.getDdvId()%>"><%=ddv.getValue() %></option>
			<%} %>
		</select>
	</span>
	<div id="datetimepicker1" class="input-append date" <%if(!isView){%>style="display:none"<%}%>>
	<label style="display:inline;margin-left:20px;">创建时间:</label>
	<input data-format="yyyy/MM/dd hh:mm:ss" type="text" id="createTime" name="createTime" style="margin-left:34px;" value="<%=createTime%>" />
		<span class="add-on">
	      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
	      </i>
	    </span>
	</div>
	<div id="datetimepicker1" class="input-append date" <%if(!isView){%>style="display:none"<%}%>>
	<label style="display:inline;margin-left:20px;">更新时间:</label>
	<input data-format="yyyy/MM/dd hh:mm:ss" type="text" id="updateTime" name="updateTime" style="margin-left:34px;" value="<%=updateTime%>" />
		<span class="add-on">
	      <i class="icon-calendar" data-time-icon="icon-time" data-date-icon="icon-calendar">
	      </i>
	    </span>
	</div>
	<span class="editAgency" style="display:none;">删除状态:<input type="text" id="deleteStatus" name="deleteStatus" value="<%=deleteSatus%>"></span>
	<span class="editAgency" <%if (!isView) { %>style="display:none"<%} %>>隶属机构目录:<input type="text" id="parentName" name="parentName" value="<%=parentName%>"></span>
	<span class="editAgency">备注:<textarea id="agencyNotes" name="agencyNotes" maxlength="255" style="width: 296px; height: 255px;"><%=notes%></textarea></span>
	<%if(!isView) { %>
	<security:phoenixSec purviewCode="ORG_UPDATE">
	<input style="margin-left:230px" class="btn btn-primary" type="button" name="save" onclick="updateAgency();" value="保存" />
	</security:phoenixSec>
	<input type="button" name="cancel" class="btn btn-primary" onclick="self.close();" value="取消" />
	<%} else { %>
	<input style="margin-left:310px" type="button" name="ok" class="btn btn-primary" onclick="self.close();" value="确定" />
	<%} %>
</body>
<script type="text/javascript">

	var isEditing = false;
	function updateAgency() {
		if (self.opener.updateAgency != null) {
			self.opener.updateAgency(
			<%if (isCata){%>
				"cata", // 类型
			<%} else {%>
				"org", // 类型
			<%}%>
				jQuery("#agencyName").val(), // 名称
				jQuery("#createTime").val(),
				jQuery("#agencyNotes").val(), // 备注
			<%if (isCata){%>
				null
				<%} else {%>
				jQuery("#orgTypeId option:selected").val()
			<%}%>
			);
			isEditing = true;
			self.close();
		}
	}
	
	window.onbeforeunload = function() {
		if (!isEditing) {
			self.opener.checkedNodes = null;
		}
	}
	
	$(function() {
		$('#datetimepicker1').datetimepicker({
			language : 'pt-BR'
		});
		
		jQuery("#orgTypeId").val(<%=orgTypeId%>);
	});
</script>

</html>