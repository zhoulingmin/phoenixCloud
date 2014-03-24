<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="java.util.Date" %>

<!doctype html>
<html>
<%
SysStaff staff = (SysStaff)session.getAttribute("user");
Date curDate = new Date();
%>

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>
<link rel="stylesheet" href="css/common.css" />
<link rel="stylesheet" href="css/page.css" />
<script src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/public.js"></script>

</head>

<body>
 <div class="top">
   <div class="left_logo"><img src="image/logo1.png"></div>
   <div class="right_info"><%=curDate.getYear() + 1900 %>年<%=curDate.getMonth()+1 %>月<%=curDate.getDate() %>日 &nbsp;&nbsp;<%=staff.getName() %>&nbsp;&nbsp;<img src="image/exit_btn1.jpg" style="vertical-align:middle;"></div>
 </div>

</body>
</html>
