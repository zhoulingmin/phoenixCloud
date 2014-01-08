<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String ctx = request.getContextPath();
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/uniform.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<script src="<%=ctx%>/js/jquery.min.js"></script>
	<script src="<%=ctx%>/js/jquery.uniform.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.custom.js"></script>
	<script src="<%=ctx%>/js/bootstrap.min.js"></script>
	<script src="<%=ctx%>/js/unicorn.js"></script>
	<title>书籍资源管理</title>
	
	<style type="text/css">
	table th,td{
	border: 1px solid #DADADA;
	width:10%;
	}
	th{
	text-align:left;
	}
	.emptyCol{
	width:3%;
	}
	</style>
</head>
<body>
	<jsp:include page="header.jsp" flush="true"></jsp:include>
	<jsp:include page="admin_sidebar.jsp" flush="true"></jsp:include>
	<div id="content">
		<div id="content-header">
			<h1>凤凰云端</h1>
		</div>
		<%
		// 算出机构节点的最大level
		// 1.有资源的机构找出来
		// 2.计算机构的最大深度
		
		%>
		
		<div class="widget-box">
			<table style="border: 1px solid #AAAAAA;border-collapse: collapse;width:100%">
				<thead  style="background:#EEEEEE;">
					<tr>
						<th colspan="4">机构根节点</th>
						<th>电子书名称</th>
						<th>资源名称</th>
						<th>状态</th>
						<th colspan="3">操作</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td></td>
						<td colspan="3">机构目录1</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td colspan="2">机构目录11</td>
						<td></td>
						<td></td>
						<td ></td>
						<td ></td>
						<td ></td>
					</tr>
					<tr>
						<td ></td>
						<td ></td>
						<td ></td>
						<td >南京</td>
						<td >电子书1</td>
						<td >未审核</td>
						<td ><a href="#">通过</a></td>
						<td ><a href="#">不通过</a></td>
						<td ><a href="#">删除</a></td>
					</tr>
					<tr>
						<td ></td>
						<td ></td>
						<td ></td>
						<td >苏州</td>
						<td >电子书2</td>
						<td >未审核</td>
						<td ><a href="#">通过</a></td>
						<td ><a href="#">不通过</a></td>
						<td ><a href="#">删除</a></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3">机构目录2</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td ></td>
						<td ></td>
						<td ></td>
						<td >南京</td>
						<td >电子书1</td>
						<td >未审核</td>
						<td ><a href="#">通过</a></td>
						<td ><a href="#">不通过</a></td>
						<td ><a href="#">删除</a></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td colspan="2">机构目录21</td>
						<td></td>
						<td></td>
						<td ></td>
						<td ></td>
						<td ></td>
					</tr>
					<tr>
						<td ></td>
						<td ></td>
						<td ></td>
						<td >xx</td>
						<td >电子书2</td>
						<td >未审核</td>
						<td ><a href="#">通过</a></td>
						<td ><a href="#">不通过</a></td>
						<td ><a href="#">删除</a></td>
					</tr>
				</tbody>
			</table>
		</div>		
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">
$(function(){
	$("th").each(function(){
		if ($(this).html().length == 0) {
			$(this).addClass("emptyCol");
		}
	});
	$("td").each(function(){
		if ($(this).html().length == 0) {
			$(this).addClass("emptyCol");
		}
	});

});
</script>

</html>