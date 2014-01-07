<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.phoenixcloud.util.MiscUtils" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
String ctx = request.getContextPath();
Boolean isView = (Boolean)request.getAttribute("isView");
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-datetimepicker.min.css"/>
	
	<script src="<%=ctx%>/js/jquery-2.0.3.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<script src="<%=ctx%>/js/bootstrap-datetimepicker.min.js"></script>
	<%if (!isView) { %>
	<title>修改书籍目录</title>
	<%} else { %>
	<title>查看书籍目录</title>
	<%} %>
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
				<span class="icon"><i class="icon-align-justify"></i></span>
				<h5>输入书籍目录信息</h5>
			</div>
			<div class="widget-content nopadding">
				<form id="editDire" class="form-horizontal" method="POST" action="#">
					<input type="hidden" name="bookDire.direId" value="<s:property value="bookDire.direId"/>"/>
					<input type="hidden" name="bookDire.bookId" value="<s:property value="bookDire.bookId"/>"/>
					<input type="hidden" name="bookDire.parentDireId" value="<s:property value="bookDire.parentDireId"/>"/>
					<div class="control-group">
						<label class="control-label">目录名称</label>
						<div class="controls">
							<input type="text" name="bookDire.name" value="<s:property value="bookDire.name"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">描述</label>
						<div class="controls">
							<input type="text" name="bookDire.notes" value="<s:property value="bookDire.notes"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">起始页码</label>
						<div class="controls">
							<input type="text" name="bookDire.bPageNum" value="<s:property value="bookDire.bPageNum"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">结束页码</label>
						<div class="controls">
							<input type="text" name="bookDire.ePageNum" value="<s:property value="bookDire.ePageNum"/>">
						</div>
					</div>
					
					<div class="control-group" style="display:none">
						<label class="control-label">级别</label>
						<div class="controls">
							<input type="text" name="bookDire.level" value="<s:property value="bookDire.level"/>">
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">账号Id</label>
						<div class="controls">
							<input type="text" name="bookDire.staffId" value="<s:property value="bookDire.staffId"/>">
						</div>
					</div>
					
					<div class="control-group">
						<div id="datetimepicker1" class="input-append date">
							<label class="control-label">创建时间</label>
							<div class="controls">
								<input data-format="yyyy/MM/dd hh:mm:ss" type="text" name="bookDire.createTime" value="<s:date name="bookDire.createTime" format="yyyy/MM/dd HH:mm:ss" />">
								<span class="add-on">
							      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
							      </i>
							    </span>
							</div>
						</div>
					</div>
					
					<%if (isView) {%>
					<div class="control-group">
						<div id="datetimepicker2" class="input-append date">
							<label class="control-label">更新时间</label>
							<div class="controls">
								<input data-format="yyyy/MM/dd hh:mm:ss" type="text" name="bookDire.updateTime" value="<s:date name="bookDire.updateTime" format="yyyy/MM/dd HH:mm:ss" />">
								<span class="add-on">
							      <i data-time-icon="icon-time" data-date-icon="icon-calendar">
							      </i>
							    </span>
							</div>
						</div>
					</div>
					<%} %>
					<div class="form-actions">
					<%if (!isView) {%>
						<button class="btn btn-primary" type="button"  onclick="saveDire();">保存</button>
						<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">返回</button>
					<%} else { %>
						<button class="btn btn-primary" onclick="cancel();return false;">返回</button>
					<%} %>
					</div>
					
				</form>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">

function saveDire() {
	jQuery.ajax({
		url: "<%=ctx%>/book/bookDire_saveDire.do",
		type: "POST",
		async: "false",
		data: jQuery("#editDire").serialize(),
		timeout: 30000,
		success: function() {
			alert("书籍目录修改成功！");
			location.href = "<%=ctx%>/book/bookDire_getAll.do?bookId=" +  jQuery("input[name='bookDire.bookId']").val();
		},
		error: function() {
			alert("书籍目录修改失败！");
		}
	});	
}

function cancel() {
	location.href = "<%=ctx%>/book/bookDire_getAll.do?bookId=" +  jQuery("input[name='bookDire.bookId']").val();
}

$(document).ready(function(){
	$('#datetimepicker1').datetimepicker({
		language : 'pt-BR'
	});
	$('#datetimepicker2').datetimepicker({
		language : 'pt-BR'
	});
	
	$($(".add-on")[0]).on("click", "i", function(e){
		$($(".bootstrap-datetimepicker-widget")[0]).css("top", $(e.target.parentNode).offset().top);
		$($(".bootstrap-datetimepicker-widget")[0]).css("left", $(e.target.parentNode).offset().left + $(e.target.parentNode).width());
	});
});


</script>

</html>