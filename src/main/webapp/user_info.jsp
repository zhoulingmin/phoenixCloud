<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>

<!doctype html>
<html>
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

<%
SysStaff staff = (Sys)

%>

</head>

<body>
     <div class="local">当前机构：江苏省－凤凰传媒集团</div>
      <div class="right_main">
         <div class="head">
           <img src="image/home_icon.jpg">&nbsp;个人信息管理&gt;个人资料
         </div>
         <div class="box_main">
            <div class="line_info red margin_top_15">说明：以下所有内容为必填项。</div>
            <div class="line_info"><font class="blue">账号：</font><font class="grey">123984023840sauweoursd</font></div>
            <div class="line_info margin_top_5"><font class="blue">邮箱：</font><font class="black">gihu@ppm.cn</font></div>
            <div class="line_info margin_top_5"><font class="blue">姓名：</font> <input type="text" class="txts"><font class="red"> 请填写真实姓名</font></div>
            <div class="line_info margin_top_5"><font class="blue">所属单位：</font> 
              <select class="select">
                <option>凤凰集团</option>
                <option>凤凰集团</option><option>凤凰集团</option>
              </select>
            </div>
            <div class="line_info margin_top_5"><font class="blue">单位地址：</font> <input type="text" class="txts1"></div>
            <div class="line_info margin_top_5"><font class="blue">学段：</font> 
             <select class="select">
                <option>小学</option>
                <option>初中</option>
                <option>高中</option>
              </select></div>
            <div class="line_info margin_top_5"><font class="blue">年级：</font>  
            <select class="select">
                <option>小学</option>
                <option>初中</option>
                <option>高中</option>
              </select></div>
            <div class="line_info margin_top_5"><font class="blue">学科：</font>
            <select class="select">
                <option>小学</option>
                <option>初中</option>
                <option>高中</option>
              </select></div>
            <div class="line_info margin_top_5"><font class="blue">性别：</font> <input type="radio" name="1"> 男 <input type="radio" name="1"> 女</div>
            <div class="line_info margin_top_5"><font class="blue">联系电话：</font> <input type="text" class="txts"></div>
            <div class="line_info margin_top_5"><font class="blue">QQ：</font> <input type="text" class="txts"></div>
            <div class="line_info margin_top_5"><font class="blue">通信地址：</font> <input type="text" class="txts1"></div>
            <div class="line_info margin_top_25">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="image/save_btn.jpg"></div>
         </div>
       </div>

</body>
</html>
