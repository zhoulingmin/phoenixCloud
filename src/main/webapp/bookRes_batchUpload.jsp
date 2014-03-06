<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.math.BigInteger" %>
<%@page import="com.phoenixcloud.bean.*" %>
<%@page import="com.phoenixcloud.dao.*" %>
<%@page import="com.phoenixcloud.util.SpringUtils" %>
<%@page import="java.util.*" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.opensymphony.xwork2.util.*"%>
<!DOCTYPE html>

<%
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

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-responsive.min.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/bootstrap-fileinput.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.main.css" />
	<link rel="stylesheet" href="<%=ctx%>/css/unicorn.grey.css" class="skin-color" />
	
	<link rel="stylesheet" href="<%=ctx%>/css/jquery.fileupload-ui.css">
	<script src="<%=ctx%>/js/jquery-1.8.1.js"></script>
	<script src="<%=ctx%>/js/jquery.ui.widget.js"></script>
	<script src="<%=ctx%>/js/jquery.iframe-transport.js"></script>
	<script src="<%=ctx%>/js/jquery.fileupload.js"></script>
	<script src="<%=ctx%>/js/jquery.tmpl.js"></script>

	<title>修改资源</title>
</head>
<body>

	<div class="widget-box">
		<div class="widget-title">
			<span class="icon"><i class="icon-align-justify"></i></span>
			<h5>输入资源信息</h5>
		</div>
		
		<div class="widget-content nopadding">
			<form id="editRes" class="form-horizontal" method="POST" action="#">
				<input type="hidden" name="bookRes.bookId" value="<%=bookId%>"/>
				<input type="hidden" name="bookRes.parentResId" value="<%=parentId%>"/>
				
				<div class="control-group">
					<div class="container">    
						<span class="btn btn-success fileinput-button">
							<i class="icon-plus icon-white"></i>
							<span>Select files...</span>
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
				
				<div class="control-group" >
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
					<button class="btn btn-primary" style="margin-left:50px" onclick="cancel();return false;">取消</button>
				</div>
				
			</form>
		</div>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>

<script type="text/javascript">

function checkfile() {
	if(jQuery("#resFile").val().length == 0) {
		alert("请先选择文件！");
		return false;
	}
	return true;
}

function cancel() {
	self.close();
}

function saveRes() {
	/*jQuery.ajax({
		url: "<%=ctx%>/book/bookRes_saveRes.do",
		type: "post",
		data: jQuery("#editRes").serialize(),
		async: "false",
		timeout: 30000,
		success: function() {
			alert("保存资源成功！");
			if (window.opener != null) {
				window.opener.location.href = "<%=ctx%>/book/bookRes_getAll.do?bookRes.bookId=<%=bookId%>";
			}
			self.close();
		},
		error: function() {
			alert("保存资源失败！");
		}
	});*/
	
	
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
        		if (window.opener != null) {
    				window.opener.location.href = "<%=ctx%>/book/bookRes_getAll.do?bookRes.bookId=<%=bookId%>";
    			}
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