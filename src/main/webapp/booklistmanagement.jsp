<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
		<link rel="stylesheet" href="<%=ctx%>/css/demo.css" type="text/css">
		<link rel="stylesheet" href="<%=ctx%>/css/zTreeStyle.css" type="text/css">
		<script src="<%=ctx%>/js/jquery-1.4.4.min.js"></script>
		<script src="<%=ctx%>/js/jquery.ztree.core-3.5.js"></script>
		<script src="<%=ctx%>/js/jquery.ztree.excheck-3.5.js"></script>
		<script src="<%=ctx%>/js/jquery.ztree.exedit-3.5.js"></script>
		<title>凤凰云端</title>
		<script type="text/javascript">
	
		var IDMark_A = "_a";
	var setting = {
		view: {
			dblClickExpand: false,
			addDiyDom: addDiyDom
		},
		edit: {
			enable: true
		},
		check: {
			enable: true,
			chkboxType:{ "Y" : "s", "N" : "s" }
		},
		callback: {
			onRightClick: OnRightClick,
			beforeDrag: beforeDrag
			
		}
	};

	var zNodes =[
		{id:1,pId:0, name:"封面", open:true, noR:true,
		},
			{id:2,pId:0, name:"目录", open:true, noR:true,
		},
		{id:3, pId:0,name:"第1章", open:true,
			children:[
				   {id:31,pId:3, name:"节点 2-1"},
				   {id:32,pId:3, name:"节点 2-2"},
				   {id:33,pId:3, name:"节点 2-3"},
				   {id:34,pId:3, name:"节点 2-4"}
			]},
		{id:4, name:"第2章", open:true,
			children:[
				   {id:41,pId:4, name:"节点 3-1"},
				   {id:42,pId:4, name:"节点 3-2"},
				   {id:43,pId:4, name:"节点 3-3"},
				   {id:44,pId:4, name:"节点 3-4"}
			]}
	 	];
	function beforeDrag(treeId, treeNodes) {
		return false;
	}
	function OnRightClick(event, treeId, treeNode) {
		if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
			zTree.cancelSelectedNode();
			showRMenu("root", event.clientX, event.clientY);
		} else if (treeNode && !treeNode.noR) {
			zTree.selectNode(treeNode);
			showRMenu("node", event.clientX, event.clientY);
		}
	}

	function showRMenu(type, x, y) {
		$("#rMenu ul").show();
		if (type=="root") {
			$("#m_del").hide();
			$("#m_check").hide();
			$("#m_unCheck").hide();
		} else {
			$("#m_del").show();
			$("#m_check").show();
			$("#m_unCheck").show();
		}
		rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});

		$("body").bind("mousedown", onBodyMouseDown);
	}
	function hideRMenu() {
		if (rMenu) rMenu.css({"visibility": "hidden"});
		$("body").unbind("mousedown", onBodyMouseDown);
	}
	function onBodyMouseDown(event){
		if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
			rMenu.css({"visibility" : "hidden"});
		}
	}
	var addCount = 1;
	function addTreeNode() {
		hideRMenu();
		var newNode = { name:"增加" + (addCount++)};
		if (zTree.getSelectedNodes()[0]) {
			newNode.checked = zTree.getSelectedNodes()[0].checked;
			zTree.addNodes(zTree.getSelectedNodes()[0], newNode);
		} else {
			zTree.addNodes(null, newNode);
		}
	}
	function removeTreeNode() {
		hideRMenu();
		var nodes = zTree.getCheckedNodes();
		if (nodes && nodes.length>0) {
			if (nodes[0].children && nodes[0].children.length > 0) {
				var msg = "要删除的节点是父节点，如果删除将连同子节点一起删掉。\n\n请确认！";
				if (confirm(msg)==true){
					for(var i=0;i<nodes.length;i++){
				zTree.removeNode(nodes[i]);
				}
				}
			} else {
				for(var i=0;i<nodes.length;i++){
				zTree.removeNode(nodes[i]);
				}
			}
		}
	}
	function checkTreeNode(checked) {
		var nodes = zTree.getSelectedNodes();
		if (nodes && nodes.length>0) {
			zTree.checkNode(nodes[0], checked, true);
		}
		hideRMenu();
	}
	function resetTree() {
		hideRMenu();
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
	}
		function setEdit() {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
		remove = $("#remove").attr("checked"),
		rename = $("#rename").attr("checked"),
		removeTitle = $.trim($("#removeTitle").get(0).value),
		renameTitle = $.trim($("#renameTitle").get(0).value);
		zTree.setting.edit.showRemoveBtn = remove;
		zTree.setting.edit.showRenameBtn = rename;
		zTree.setting.edit.removeTitle = removeTitle;
		zTree.setting.edit.renameTitle = renameTitle;
		showCode(['setting.edit.showRemoveBtn = ' + remove, 'setting.edit.showRenameBtn = ' + rename,
			'setting.edit.removeTitle = "' + removeTitle +'"', 'setting.edit.renameTitle = "' + renameTitle + '"']);
	}
	function addDiyDom(treeId, treeNode) {
		
		var aObj = $("#" + treeNode.tId + IDMark_A);
			if(treeNode.level==0){
			var editStr = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='bPageNum' style='width:30px' >&nbsp;<input type='text' name='ePageNum' style='width:30px' >";
			}else{
			var editStr = "<input type='text' name='bPageNum' style='width:30px' >&nbsp;<input type='text' name='ePageNum' style='width:30px' >";

			}
			aObj.after(editStr);
	}
	var zTree, rMenu;
	$(document).ready(function(){
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		zTree = $.fn.zTree.getZTreeObj("treeDemo");
		rMenu = $("#rMenu");
	});
	
		</script>
		<style type="text/css">
			div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}
			div#rMenu ul li{
			margin: 1px 0;
			padding: 0 5px;
			cursor: pointer;
			list-style: none outside none;
			background-color: #DFDFDF;
}
	</style>
	</head>
	<body>
	<jsp:include page="mainfrm.min.jsp" flush="true" />
	
		<div id="content">
			<div id="content-header">
				<h1>凤凰云端</h1>
			</div>
			<div id="breadcrumb">
				<a href="#" title="Go to Home" class="tip-bottom"><i class="icon-home"></i>&nbsp;主菜单</a>
				<a href="#" class="current">书籍目录管理</a>
			</div>
			<jsp:include page="booklist.jsp" flush="true"></jsp:include>
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