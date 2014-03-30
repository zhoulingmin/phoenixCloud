<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.phoenixcloud.bean.*"%>
<%@page import="com.phoenixcloud.dao.ctrl.*"%>
<%@page import="com.phoenixcloud.util.SpringUtils"%>
<%@taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<%
SysStaff staff = (SysStaff)session.getAttribute("user");
PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
PubOrg org = orgDao.find(staff.getStaffId().toString());
String ctx = request.getContextPath();

PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
List<PubDdv> formatList = ddvDao.findByTblAndField("r_book_res", "FORMAT");

String bookId = request.getParameter("bookId");
if (bookId == null) {
	bookId = "";
}
String parentId = request.getParameter("parentId");
if (parentId == null) {
	parentId = "";
}

String fileNameMarker = "${fileName_}";
String fileSizeMarker = "${fileSize_}";

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
<link rel="stylesheet" href="<%=ctx%>/css/jquery.fileupload-ui.css">
<link rel="stylesheet" href="<%=ctx%>/css/common.css" />
<link rel="stylesheet" href="<%=ctx%>/css/page.css" />

<script src="<%=ctx%>/js/jquery-1.8.1.js"></script>
<script type="text/javascript" src="<%=ctx%>/js/public.js"></script>
<script src="<%=ctx%>/js/bootstrap-fileinput.js"></script>
<script src="<%=ctx%>/js/jquery.ui.widget.js"></script>
<script src="<%=ctx%>/js/jquery.iframe-transport.js"></script>
<script src="<%=ctx%>/js/jquery.fileupload.js"></script>
<script src="<%=ctx%>/js/jquery.tmpl.js"></script>

</head>

<body>
	<div class="local">当前机构：<%=org.getOrgName() %></div>
	<div class="right_main">
		<div class="head">
			<img src="<%=ctx %>/image/home_icon.jpg">&nbsp;书籍制作&gt;批量上传资源
		</div>

		<div class="widget-content nopadding">
			<form id="editRes" class="form-horizontal" method="POST" action="#">
				<input type="hidden" name="bookRes.bookId" value="<%=bookId%>"/>
				<input type="hidden" name="bookRes.parentResId" value="<%=parentId%>"/>
				
				<div class="control-group">
					<div class="container">    
						<span class="btn btn-success fileinput-button" style="margin-left:40px;">
							<i class="icon-plus icon-white"></i>
							<span>选择资源...</span>
							<input id="fileupload" type="file" name="resFile" multiple="">
						</span>
						<br>
						<br>
						<table role="presentation" class="table table-striped">
						  <tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery">
						  </tbody>
						</table>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">格式</label>
					<div class="controls">
						<select name="bookRes.format" >
						<%for (PubDdv format : formatList) { %>
							<option value="<%=format.getDdvId()%>"><%=format.getValue() %></option>
						<%} %>
						</select>					
					</div>
				</div>
				
				<div class="control-group" style="display:none">
					<label class="control-label">资源目录地址</label>
					<div class="controls">
						<input type="text" name="bookRes.cataAddr" />
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">备注</label>
					<div class="controls">
						<input type="text" name="bookRes.notes" value="">
					</div>
				</div>
				
				<div class="form-actions">
					<button class="btn btn-primary" type="button"  onclick="saveRes();">批量上传资源</button>
					<button class="btn btn-primary" style="margin-left:50px" onclick="history.back();return false;">取消</button>
				</div>
				
			</form>
		</div>
	</div>

</body>
<script type="text/javascript">

function checkfile() {
	if(jQuery("#bookFile").val().length == 0) {
		alert("请先选择文件！");
		return false;
	}
	return true;
}

function saveRes() {
	jQuery(".start:eq(0)").trigger("click");
}

$(function() {
	
	var template = '<tr class="template-upload fade in">'+
        '<td>'+
           ' <p class="name"><%=fileNameMarker%>               <%=fileSizeMarker%> KB</p>  '+     
           ' <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar" style="width:0%;"></div></div>'+
        '</td>'+
        '<td>' +
        '    <button style="display:none" class="btn btn-primary start">'+
        '       <i class="icon-upload icon-white"></i>'+
        '       <span>Start</span>'+
        '    </button>'+
        '    <button class="btn btn-warning cancel">'+
        '       <i class="icon-ban-circle icon-white"></i>'+
        '       <span>Cancel</span>'+
        '    </button>        '+    
        '</td>' +
    '</tr>';
    var url = '<%=ctx%>/book/batchUploadBookRes.do';
    var currentData = {};
    $('#fileupload').fileupload({autoUpload: true,
        url: url,
        dataType: 'json',
        add: function (e, data) {
    	   var templateImpl = $.tmpl(template,{"fileName_":data.files[0].name,"fileSize_":(data.files[0].size/1000).toFixed(2)}).appendTo( ".files" );
    	   data.content = templateImpl;
    	   $(".start", templateImpl).click(function () {
    		    currentData.bar = templateImpl;    		    
                $('<p/>').text('Uploading...').addClass("uploading").replaceAll($(this));
                data.submit();//上传文件
           });
    	   $(".cancel", templateImpl).click(function () {
                $('<p/>').text('cancel...').replaceAll($(this));
                data.abort();//取消上传
                $(templateImpl).remove();
    	   });
        },

        done: function (e, data) {
        	$(".uploading", data.content).text('上传成功');
        	if ($(".start").length > 0) {
        		$(".start:eq(0)").trigger("click");
        	} else {
        		alert("上传资源成功！");
    			window.location.href = "<%=ctx%>/book/bookRes.do?bookRes.bookId=<%=bookId%>&bookInfo.isAudit=-1";
        	}
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('.bar', currentData.bar).css(
                'width',
                progress + '%'
            );
        }
    });
});

</script>
</html>
