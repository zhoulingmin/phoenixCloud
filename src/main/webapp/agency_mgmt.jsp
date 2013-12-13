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
		<style type="text/css">
		#contextMenu {
		    position: absolute;
		    display:none;
		}
		</style>
		
		<title>凤凰云端</title>
	</head>
	<body>
		<jsp:include page="mainfrm.jsp" flush="true" />
		<div id="contextMenu" class="dropdown clearfix">
		    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" style="display:block;position:absolute;margin-bottom:5px;">
		        <li><a tabindex="-1" href="#">新建</a></li>
		        <li><a tabindex="-1" href="#">删除</a></li>
		        <li><a tabindex="-1" href="#">重命名</a></li>
		        <li class="divider"></li>
		        <li><a tabindex="-1" href="#">刷新</a></li>
		    </ul>
		</div>
		<div id="content">
			<div id="content-header">
				<h1>凤凰云端</h1>
			</div>
			<div class="widget-box">
				<div class="widget-content">
				<form action="<%=ctx%>/agency/listAllCata.do?method=searchCata" method="GET">
					&nbsp;&nbsp;&nbsp;&nbsp;机构目录名称&nbsp;<input id="orgCataName" name="orgCataName" type="text" style="width:50px;"/>
					&nbsp;&nbsp;&nbsp;&nbsp;机构名称&nbsp;<input id="orgName" name="orgName" type="text" style="width:50px;"/>
					&nbsp;&nbsp;&nbsp;&nbsp;<input id="search-Btn" name="criteral" class="btn" value="搜索" type="submit" style="margin-bottom:10px;width:50px;"/>
				</form>
				</div>
			</div>
			<%@include file="agency_mgmt_content.jsp"%>
			<jsp:include page="footer.jsp" flush="true" />
		</div>
	</body>
	<script type="text/javascript">
	function openCata(which){
		var className = jQuery("div[cataId='" + which.getAttribute("cataId") + "'] > .accordion-heading > .widget-title > a > span > i").attr("class");
		if (className == "icon-folder-close") {
			jQuery.ajax({
				type: "GET",
				url: "<%=ctx%>" + "/agency/listAllCata.do?method=listAllCata",
				data: {type:"ajax", cataId:which.getAttribute("cataId")},
				dataType: "json",
				async: false,
				success: function(data,textStatus,jqXHR){
					//alert(data);
					if (data != undefined && data != null && data.length != 0) {
						
						if (data[0].cataName != null) {
							jQuery("div[cataId='" + data[0].parentCataId + "'] > .accordion-heading > .widget-title > a > span > i").removeAttr("class");
							jQuery("div[cataId='" + data[0].parentCataId + "'] > .accordion-heading > .widget-title > a > span > i").addClass("icon-folder-open");
						} else if (data[0].orgName != null) {
							jQuery("div[cataId='" + data[0].orgCataId + "'] > .accordion-heading > .widget-title > a > span > i").removeAttr("class");
							jQuery("div[cataId='" + data[0].orgCataId + "'] > .accordion-heading > .widget-title > a > span > i").addClass("icon-folder-open");
						}
						
						for (var i = 0; i < data.length; i ++) {
							if (data[i].cataName != null) {
								// this is a cata node
								var cataDiv = "<div style=\"margin-left:20px; cursor:pointer;\" class=\"accordion-group widget-box\" cataId=\"" + data[i].orgCataId + "\">";
								cataDiv += "<div class=\"accordion-heading\">";
								cataDiv += "<div class=\"widget-title\">";
								cataDiv += "<a data-toggle=\"collapse\" href=\"#orgCata-" + data[i].orgCataId + "\" data-parent=\"#collapse-group\">";
								cataDiv += "<span class=\"icon\">";
								cataDiv += "<i class=\"icon-folder-close\"></i>";
								cataDiv += "<input id=\"cata-" + data[i].orgCataId + "\" type=\"checkbox\" style=\"margin-left:5px;margin-bottom:5px;\" value=\"" + data[i].orgCataId + "\" />";
								cataDiv += "</span>";
								cataDiv += "<h5>" + data[i].cataName + "</h5>";
								cataDiv += "</a>";
								cataDiv += "</div></div></div>";
								
								jQuery(jQuery("div[cataId='" + data[i].parentCataId + "']")[0]).append(jQuery(cataDiv));
								jQuery("div[cataId='" + data[i].orgCataId + "']").click(function(){
									return openCata(this);
								});
							} else if (data[i].orgName != null) {
								// this is a org node
								var orgDiv = jQuery("#orgCataId-" + data[i].orgCataId)[0];
								if (orgDiv == null) {
									orgDiv = "<div id=\"orgCataId-" + data[i].orgCataId + "\" class=\"accordion-body collapse\" style=\"margin-left:20px; height: auto;\">";
									orgDiv += "</div>";
									jQuery(jQuery("div[cataId='" + data[i].orgCataId + "']")[0]).append(jQuery(orgDiv));
									orgDiv = jQuery("#orgCataId-" + data[i].orgCataId)[0];
								}
								var orgNode = "<div class=\"widget-content\">";
								orgNode += "<input id=\"leaf-" + data[i].orgId + "\" type=\"checkbox\" style=\"margin-bottom:6px; margin-right:5px;\" value=\"" + data[i].orgId + "\"/>";
								orgNode += data[i].orgName + "</div>";
								jQuery(orgDiv).append(jQuery(orgNode));
								jQuery(".accordion-group > .accordion-body").on("click", function(event) {
									if (event.stopPropagation) { // W3C/addEventListener()
								        event.stopPropagation();
								    } else { // Older IE.
								        event.cancelBubble = true;
								}
								});
							}
						}
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					alert("Error happened!");
				}
			});
		} else if (className == "icon-folder-open"){
			// 1.remove children nodes
			jQuery("div[cataId='" + which.getAttribute("cataId") + "']").children(".accordion-group").remove();
			jQuery("div[cataId='" + which.getAttribute("cataId") + "']").children(".accordion-body").remove();
			// 2.change the icon
			jQuery("div[cataId='" + which.getAttribute("cataId") + "'] > .accordion-heading > .widget-title > a > span > i").removeAttr("class");
			jQuery("div[cataId='" + which.getAttribute("cataId") + "'] > .accordion-heading > .widget-title > a > span > i").addClass("icon-folder-close");
		}
		setSelectOperation();
		return false;
	};
	
	function setSelectOperation() {
		var checkBoxArr = jQuery(".accordion-group").find("input:checkbox");
		for (var i = 0; i < checkBoxArr.length; i++) {
		    jQuery(checkBoxArr[i]).on("click", function(e){
		        if (e.stopPropagation) {
		            e.stopPropagation();
		        } else {
		            e.cancelBubble = true;
		        }
		        if (jQuery(this).attr("checked") != null) {
					checkChildren(this);
		        } else {
		        	unCheckChildren(this);
		        }
		    });
		}
	}
	
	function isCataNode(which) {
		return jQuery(which).parentsUntil(".widget-title").length == 2;
	}
	
	function checkChildren(which) {
		if (isCataNode(which)) {
			var childInputArr = jQuery("div[cataId='" + jQuery(which).val() + "']").find("input");
			for (var i = 0; i < childInputArr.length; i++) {
				jQuery(childInputArr[i]).attr("checked", "true");
			}
		}
	}
	
	function unCheckChildren(which) {
		if (isCataNode(which)) {
			var childInputArr = jQuery("div[cataId='" + jQuery(which).val() + "']").find("input");
			for (var i = 0; i < childInputArr.length; i++) {
				jQuery(childInputArr[i]).removeAttr("checked");
			}
		}
	}
	
	function removeAgency(which) {
		
	}
	
	jQuery(document).ready(function(){
		jQuery(".accordion-group").css("cursor", "pointer");
		jQuery(".accordion-group").click(function() {
			return openCata(this);
		});
		setSelectOperation();
	});
	
	var $contextMenu = $("#contextMenu");
    var $rowClicked;
    $("body").on("contextmenu", ".accordion-group", function (e) {
        $rowClicked = $(this)
        $contextMenu.css({
            display: "block",
            left: e.pageX,
            top: e.pageY
        });
        return false;
    });
    $contextMenu.on("click", "a", function () {
    	var msg = null;
		if ($rowClicked.attr("cataId") != null) {
			msg = "机构目录:" + jQuery($rowClicked.find("h5")[0]).text();
		} else {
			msg = "机构:" + jQuery($rowClicked).text();
		}
		msg += " 被选中！";
		alert(msg);
        $contextMenu.hide();
    });
    $(document).click(function () {
        $contextMenu.hide();
    });
	
	</script>
	
</html>