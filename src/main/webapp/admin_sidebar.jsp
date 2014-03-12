
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
		<security:phoenixSec purviewCode="ORG_MANAGE">
		<li id="usermgmt_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-user"></i> <span>机构管理</span></a>
			<ul>
				<security:phoenixSec purviewCode="ORG_MENU">
				<li><a href="<%=request.getContextPath()%>/agencyMgmt.jsp">机构管理</a></li>
				</security:phoenixSec>
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
		<security:phoenixSec purviewCode="BOOK_MANAGE">
		<li id="search_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-search"></i> <span>书籍管理</span></a>
			<ul>
				<security:phoenixSec purviewCode="BOOK_MENU">
				<li><a href="<%=request.getContextPath()%>/book/book_getAll.do?bookInfo.isAudit=-1">书籍制作</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_ADUIT_MENU">
				<li><a href="<%=request.getContextPath()%>/book/book_getAll.do?bookInfo.isAudit=0">书籍审核</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RELESE_MENU">
				<li><a href="<%=request.getContextPath()%>/book/book_getAll.do?bookInfo.isAudit=1">书籍发布</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_QUERY_MENU">
				<li><a href="#">书籍查询</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="BOOK_RES_QUERY_MENU">
				<li><a href="#">书籍资源查询</a></li>
				</security:phoenixSec>
			</ul>
		</li>
		</security:phoenixSec>
		<security:phoenixSec purviewCode="SYS_MANAGE">
		<li id="favorite_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-star"></i> <span>系统管理</span></a>
			<ul>
				<security:phoenixSec purviewCode="STAFF_MANAGE_MENU">
				<li><a href="<%=request.getContextPath()%>/system/system_getAllUser.do">账号管理</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="PURVIEW_MANAGE_MENU">
				<li><a href="<%=request.getContextPath()%>/system/system_getAllPurview.do?tabId=purviewTab">权限管理</a></li>
				</security:phoenixSec>
				<security:phoenixSec purviewCode="HARDWARE_MANAGE_MENU">
				<li><a href="<%=request.getContextPath()%>/system/system_getAllHw.do">硬件管理</a></li>
				</security:phoenixSec>
				<li style="display:none"><a href="#">硬件绑定</a></li>
			</ul>
		</li>
		</security:phoenixSec>
		<security:phoenixSec purviewCode="REG_CODE_MANAGE">
		<li id="settings_menu" onclick="javascript:void(0);" class="submenu"><a href="#"><i class="icon icon-cog"></i> <span>注册码管理</span> </a>
			<ul>
				<security:phoenixSec purviewCode="BOOK_REG_CODE_MENU">
				<li><a href="<%=request.getContextPath()%>/book/bookRegCode_getAll.do">书籍注册码</a></li>
				</security:phoenixSec>
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

