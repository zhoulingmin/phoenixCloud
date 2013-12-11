<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String ctx = (String) request.getContextPath();
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
		<link rel="stylesheet" href="<%=ctx%>/css/skin/ui.dynatree.css">
		
		<script src="<%=ctx%>/js/jquery.min.js"></script>
		
		<title>凤凰云端</title>
	</head>
	<body>
		<jsp:include page="mainfrm.jsp" flush="true" />
		<div id="content">
			<div id="content-header">
				<h1>凤凰云端</h1>
			</div>
			<jsp:include page="agency_mgmt_content.jsp" flush="true"></jsp:include>
			<jsp:include page="footer.jsp" flush="true" />
			</div>
		</div>
	</body>
	<script type="text/javascript">
		$(document).ready(function() {
			setActiveClass($("#home_menu"));
		});
	</script>
</html>