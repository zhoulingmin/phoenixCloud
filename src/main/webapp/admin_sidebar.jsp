
<%@taglib uri="/WEB-INF/security.tld" prefix="security" %>

<div id="sidebar">
	<ul id="leftMenu">
		<li id="home_menu" style="display:none" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-home"></i> <span>报表管理</span></a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/home.jsp">报表呈现</a></li>
				<li><a href="#">报表导出</a></li>
				<li><a href="#">报表数据处理</a></li>
			</ul>
		</li>
		<security:phoenixSec purviewCode="queryAgency">
		<li id="usermgmt_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-user"></i> <span>机构管理</span></a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/agencyMgmt.jsp">机构管理</a></li>
			</ul>
		</li>
		</security:phoenixSec>
		<li id="eformmgmt_menu" style="display:none" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-th-list"></i><span>日志管理</span> <span class="label">4</span></a>
			<ul>
				<li><a href="#">分类管理</a></li>
				<li><a href="#">日志查询</a></li>
				<li><a href="#">日志写入接口</a></li>
			</ul>
		</li>
		<security:phoenixSec purviewCode="queryBook">
		<li id="search_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-search"></i> <span>书籍管理</span></a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/book/book_getAll.do">书籍管理</a></li>
				<li style="display:none"><a href="#">书籍目录管理</a></li>
				<li style="display:none"><a href="#">书籍上传管理</a></li>
				<li style="display:none"><a href="#">资源上传管理</a></li>
				<li><a href="<%=request.getContextPath()%>/book/bookRes_queryAll.do">资源查询</a></li>
			</ul>
		</li>
		</security:phoenixSec>
		<security:phoenixSec purviewCode="querySystem">
		<li id="favorite_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-star"></i> <span>系统管理</span></a>
			<ul>
				<security:phoenixSec purviewCode="queryUser">
				<li><a href="<%=request.getContextPath()%>/system/system_getAllUser.do">账号管理</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="queryPurview">
				<li><a href="<%=request.getContextPath()%>/system/system_getAllPurview.do?tabId=purviewTab">权限管理</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="queryHardware">
				<li><a href="<%=request.getContextPath()%>/system/system_getAllHw.do">硬件管理</a></li>
				</security:phoenixSec>
				<li style="display:none"><a href="#">硬件绑定</a></li>
			</ul>
		</li>
		</security:phoenixSec>
		<security:phoenixSec purviewCode="queryRegcode">
		<li id="settings_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-cog"></i> <span>注册码管理</span> </a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/book/bookRegCode_getAll.do">书籍注册码</a></li>
			</ul>
		</li>
		</security:phoenixSec>
		<li id="settings_menu" style="display:none" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-cog"></i> <span>字典管理</span> <span class="label">2</span></a>
			<ul>
				<li><a href="#">出版社管理</a></li>
				<li><a href="#">字典值管理</a></li>
			</ul>
		</li>
	</ul>
</div>

