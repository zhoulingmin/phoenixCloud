<div id="header">
	<h1><a href="#">Phoenixcloud</a></h1>		
</div>
<%@page import="com.phoenixcloud.bean.*" %>
<%
SysStaff user = (SysStaff)session.getAttribute("user");
%>
<div id="user-nav" class="navbar navbar-inverse">
    <ul class="nav btn-group">
        <li class="btn btn-inverse" ><a title="" href="<%=request.getContextPath()%>/system/system_editUser.do?staff.staffId=<%=user.getStaffId()%>"><i class="icon icon-user"></i> <span class="text"><%=user.getName() %></span></a></li>
        <li class="btn btn-inverse" style="display:none" ><a title="" href="#"><i class="icon icon-cog"></i> <span class="text">设置</span></a></li>
        <li class="btn btn-inverse"><a title="" href="<%=request.getContextPath()%>/logout.jsp"><i class="icon icon-share-alt"></i> <span class="text">登出</span></a></li>
    </ul>
</div>