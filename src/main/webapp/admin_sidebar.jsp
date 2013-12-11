<div id="sidebar">
	<ul id="leftMenu">
		<li style="display:none" id="home_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-home"></i> <span>报表管理</span></a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/home.jsp">报表呈现</a></li>
				<li><a href="#">报表导出</a></li>
				<li><a href="#">报表数据处理</a></li>
			</ul>
		</li>
		<li id="usermgmt_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-user"></i> <span>机构管理</span></a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/agency/listAllCata.do?method=listAllCata">机构</a></li>
			</ul>
		</li>
		<li style="display:none" id="eformmgmt_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-th-list"></i><span>日志管理</span> <span class="label">4</span></a>
			<ul>
				<li><a href="#">分类管理</a></li>
				<li><a href="#">日志查询</a></li>
				<li><a href="#">日志写入接口</a></li>
			</ul>
		</li>
		<li id="search_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-search"></i> <span>书籍管理</span></a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/booklistmanagement.jsp"">书籍目录管理</a></li>
				<li><a href="#">书籍信息管理</a></li>
				<li><a href="#">书籍上传管理</a></li>
				<li><a href="#">资源上传管理</a></li>
				<li><a href="#">书籍资源审核</a></li>
			</ul>
		</li>
		<li id="favorite_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-star"></i> <span>系统管理</span></a>
			<ul>
				<li><a href="#">账号管理</a></li>
				<li><a href="<%=request.getContextPath()%>/rightsmanagement.jsp">权限管理</a></li>
				<li><a href="#">硬件管理</a></li>
				<li><a href="#">硬件绑定管理</a></li>
			</ul>
		</li>
		<li id="settings_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-cog"></i> <span>注册码管理</span> <span class="label">2</span></a>
			<ul>
				<li><a href="#">书籍注册码管理</a></li>
			</ul>
		</li>
		<li style="display:none" id="settings_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-cog"></i> <span>字典管理</span> <span class="label">2</span></a>
			<ul>
				<li><a href="#">出版社管理</a></li>
				<li><a href="#">字典值管理</a></li>
			</ul>
		</li>
	</ul>
</div>

