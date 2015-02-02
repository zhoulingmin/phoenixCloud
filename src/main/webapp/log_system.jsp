<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.dao.res.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@page import="java.util.*" %>
<%@page import="com.phoenixcloud.common.*" %>

<%
String ctx = request.getContextPath();

SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getOrgId().toString());

List<SysLog> systemList = (List<SysLog>)request.getAttribute("systemList");

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> sysOperaList = ddvDao.findByTblAndField("sys_log", "LOG_TYPE_ID");


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
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-datetimepicker.min.css"/>

<script src="<%=ctx%>/js/jquery-1.7.1.min.js"></script>
<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
<script src="<%=ctx%>/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>

<style>
tr td,th{
white-space:nowrap;
}
select{
	width:100px;
}
</style>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx%>/image/home_icon.jpg">&nbsp;日志管理&gt;系统日志管理
		</div>
	
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				
					<input type="hidden" name="bookRes.isAudit" value="-2">
					<input type="hidden" name="bookInfo.isAudit" value="-2">
					<div id="datetimepicker1" style="float: left;width:330px; ">
						    <span>开始时间：</span>
							<input data-format="yyyy-MM-dd" type="text" id="starttime" value="">
							<span class="add-on">
						      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
						      </i>
						    </span>
					</div>
					<div id="datetimepicker2" style="width:330px" >
					       <span>结束时间：</span>
							<input data-format="yyyy-MM-dd" type="text" id="endtime" value="">
							<span class="add-on">
						      <i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
						    </span>
					</div>
					<br>
					操作用户:
					<input type="text" id="starffName" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					操作方式:
					<select id="logtype">
					    <option value="0" selected="selected">全部</option>
					    <%for (PubDdv oper : sysOperaList) { %>
						<option value="<%=oper.getDdvId()%>"><%=oper.getValue() %></option>
						<%} %>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" class="btn btn-primary" value="搜索"  onclick="fenye(1);" style="margin-bottom:10px;width:50px;"/>
				
			</div>
		</div>
		
		<div class="widget-box">
			<div class="widget-content" style="white-space:nowrap;">
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="viewRes" onclick="viewLogSystem();" value="详情"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-primary" name="back" onclick="history.back();return false;" value="返回"/>
			</div>
		</div>
		
		<div class="widget-box" style="overflow:scroll">
			<table class="list_table" style="margin-top:0px">
				<thead>
					<tr>
						<th style="width:1%">&nbsp;</th>
						<th>编号</th>
						<th>用户</th>
						<th>操作方式</th>
						<th>操作内容</th>
						<th>操作时间</th>
						<th>备注</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id="sysLogBody">
					<tr>
					  <td colspan="7">请搜索数据！</td>
					</tr>
				</tbody>
			</table>
			
			<div class="page_info">
				<div class="left_page" style="border-color:green ; float: left;">共有数据   <font id="count"></font> 条 每页
					<select id="pageSize">
					  <option selected="selected">10</option>
					  <option>20</option>
					</select>条 </div>
			     </div>
			    <div class="fenpage" style=" float: left;font-size: 14px; padding-top: 8px;margin-left: 80px;">
					<a href="#" onclick="paging(1);"> 首页 </a>&nbsp;<a href="#" onclick="paging(2);"> 上一页 </a> 
					   &nbsp;&nbsp;当前<span><font id="nowPage"></font></span>
					   /<span><font id="totalPages"></font></span> 页&nbsp;&nbsp;
					<a href="#" onclick="paging(3);"> 下一页 </a>&nbsp;<a href="#" onclick="paging(4);"> 尾页 </a>
				</div>
		  </div>
	</div>
</body>
<script type="text/javascript">
var nowPage=1;
var totalPages=jQuery("#totalPages").html();
altert(totalPages);
function paging(num) {
	if (num==1) {
	    if(nowPage==1){
		  alert("已经在首页！");}
		else{
		   nowPage=1;
		   fenye(nowPage);
		}
		
		
	}if (num==2) {
		 if(nowPage==1){
		   alert("已经是第一页！");}
		 else{
		   nowPage-=1;
		   jQuery(this).focus();
		   fenye(nowPage);
		 }
		
	}if (num==3) {
		if(nowPage==jQuery("#totalPages").html()){
		   alert("已经是最后一页！");}
		 else{
		   nowPage+=1;
		   jQuery(this).focus();
		   fenye(nowPage);
		   
		 }
	}if(num==4) {
		if(nowPage==jQuery("#totalPages").html()){
		   alert("已经是尾页！");}
		 else{
		    nowPage=jQuery("#totalPages").html();
		    jQuery(this).focus();
		    fenye(nowPage);
		 }
	}
}

function fenye(nowPage) {
	var starttime=jQuery("#starttime").val();
	var endtime=jQuery("#endtime").val();
	var starffName=jQuery("#starffName").val();
	var logtype=jQuery("#logtype").val();
	var pageSize=jQuery("#pageSize").val();
	jQuery.ajax({
		url: '<%=ctx%>/system/getloglist.do',
		data: {starttime:starttime,endtime:endtime,starffName:starffName,logtype:logtype,nowPage:nowPage,pageSize:pageSize},
		type: "POST",
		success: function(date) {
		    var result = eval("(" + date + ")");
			var sll = result.sysLogList;
			var count=result.count;
			var totalPages=parseInt((count-1)/pageSize+1);
			if (sll== null || sll.length == 0) {
				jQuery("#sysLogBody").children("tr").remove();
				var trElm="<tr><td colspan='7'>没有数据，请重新搜索！</td></tr>";
                jQuery("#sysLogBody").append(trElm);
                jQuery("#nowPage").html(0);
				return;
			}
			
			jQuery("#sysLogBody").children("tr").remove();
			jQuery("#nowPage").html(nowPage);
			jQuery("#totalPages").html(totalPages);
			jQuery("#count").html(count);
			for ( var i = 0; i < sll.length; i++) {
			    var syslog  = sll[i];
				var logdelete="<security:phoenixSec purviewCode='BOOK_REMOVE'><a name='removeBook' class='tip-top' title='删除' href='#'><i class='icon-remove'></i></a></security:phoenixSec>";
				var href= "<%=ctx%>/system/viewSystemLog.do?logId=" + syslog[0];
				var trElm = "<tr>" ;
				trElm += "<td style='width:1%'><input type='checkbox' name='logId' value='" + syslog[0] + "'/></td>";
				trElm += "<td>" + syslog[0] + "</td>";
				trElm += "<td>" + syslog[1] + "</td>";
				trElm += "<td>" + syslog[2] + "</td>";
				trElm += "<td>" + syslog[3] + "</td>";
				trElm += "<td>" + syslog[4] + "</td>";
				trElm += "<td>" + syslog[5] + "</td>";
				trElm += "<td><security:phoenixSec purviewCode='BOOK_REMOVE'><a class='tip-top' title='详情' href='"+href+"'><i class='icon-eye-open'></i></a></security:phoenixSec></td>";
				trElm += "</tr>";
				jQuery("#sysLogBody").append(trElm);
			}
		},
		error: function(req,txt) {
			alert("加载数据失败！");
		}
	});
}

function  viewLogSystem() {
	var checkedItems = jQuery("#sysLogBody").find("input:checked");
	if (checkedItems == null || checkedItems.length != 1) {
		alert("请选择一项后重试！");
		return;
	}
	alert(checkedItems[0].value);
	window.location.href = "<%=ctx%>/system/viewSystemLog.do?logId=" + checkedItems[0].value;
}

</script>

<script type="text/javascript">
  $(function() {
    $('#datetimepicker1').datetimepicker({
      language: 'pt-BR'
    });
    $('#datetimepicker2').datetimepicker({
      language: 'pt-BR'
    });
  });
</script>
</html>
