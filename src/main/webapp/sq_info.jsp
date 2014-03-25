<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.ctrl.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.*" %>
<%@page import="java.math.BigInteger" %>
<%@page import="java.text.*" %>
<%
String ctx = request.getContextPath();
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrg org = orgDao.find(staff.getOrgId().toString());

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubHw> hwList = (List<PubHw>)request.getAttribute("hwList");
List<PubHwNum> hwNumList = (List<PubHwNum>)request.getAttribute("hwNumList");

PubHwDao hwDao = (PubHwDao)SpringUtils.getBean(PubHwDao.class); 


%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="keywords" content="江苏凤凰数字出版传媒有限公司">
<meta name="description" content="江苏凤凰数字出版传媒有限公司">
<title></title>
<link rel="stylesheet" href="<%=ctx %>/css/common.css" />
<link rel="stylesheet" href="<%=ctx %>/css/page.css" />
<script src="<%=ctx %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctx %>/js/public.js"></script>

</head>

<body>
     <div class="local">当前机构：<%=org.getOrgName() %></div>
      <div class="right_main">
         <div class="head">
           <img src="<%=ctx %>/image/home_icon.jpg">&nbsp;个人信息管理&gt;授权信息
         </div>
         <div class="box_main">
            <div class="line_info  margin_top_25"></div>
            <div class="line_info  margin_top_25"></div>
            
            <table class="list_table location_center">
            	<thead>
            		<tr>
            		<th>硬件类型</th>
            		<th>授权总数</th>
            		<th>已授权数量</th>
            		</tr>
            	</thead>
            	<tbody>
            		<%for (PubHwNum num : hwNumList) {
            			PubDdv ddv = ddvDao.find(num.getHwType().toString());
            		%>
            		<tr>
            		<td><%=ddv.getValue() %></td>
            		<td><input type="text" readonly="readonly" value="<%=num.getNum() %>"/></td>
            		<td><%=hwDao.getCountOfHw(new BigInteger(staff.getStaffId()), num.getHwType()) %></td>
            		</tr>
            		<%} %>
            	</tbody>
            </table>
            
            <div class="line_info  margin_top_25"></div>
            <div class="line_info  margin_top_25"></div>
            <table class="list_table location_center">
				<thead>
					<tr>
						<th>序号</th>
						<th>授权日期</th>
						<th>类型</th>
						<th>硬件信息</th>
					</tr>
				</thead>
				<tbody>
					<%
					int num = 1;
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					for (PubHw hw : hwList) { 
						num++;
						PubDdv ddv = ddvDao.find(hw.getHwType().toString());
					%>
					<tr>
					<td><%=num %></td>
					<td><%=sdf.format(hw.getCreateTime()) %></td>
					<td><%=ddv.getValue()%></td>
					<td><%=hw.getCode() %></td>
					</tr>
					<%} %>
				</tbody>
			</table>
         </div>
       </div>
</body>
</html>
