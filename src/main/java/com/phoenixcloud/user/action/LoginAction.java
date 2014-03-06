package com.phoenixcloud.user.action;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.PubDdv;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.dao.PubDdvDao;
import com.phoenixcloud.dao.SysStaffDao;

@Scope("prototype")
@Component
public class LoginAction extends ActionSupport implements RequestAware,
		ServletResponseAware, SessionAware {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4096920054621958080L;
	private RequestMap request;
	private HttpServletResponse response;
	private SessionMap session;
	
	private SysStaff staff;
	@Resource
	private SysStaffDao staffDao;
	@Resource
	private PubDdvDao ddvDao;
	
	
	public void setDdvDao(PubDdvDao ddvDao) {
		this.ddvDao = ddvDao;
	}

	public void setStaffDao(SysStaffDao staffDao) {
		this.staffDao = staffDao;
	}

	public SysStaff getStaff() {
		return staff;
	}

	public void setStaff(SysStaff staff) {
		this.staff = staff;
	}

	@Override
	public void setSession(Map<String, Object> session) {
		// TODO Auto-generated method stub
		this.session = (SessionMap) session;
	}

	@Override
	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response;
	}

	@Override
	public void setRequest(Map<String, Object> request) {
		// TODO Auto-generated method stub
		this.request = (RequestMap) request;
	}

	public String execute() {
		String ret = "NotFound";
		SysStaff user = staffDao.findByCode(staff.getCode());
		if (user != null) {
			if (!user.getPassword().equals(staff.getPassword())) {
				ret = "ErrorPass";
			} else if (user.isExpired()) {
				ret = "Expired";
			} else {
				session.put("user", user);
				PubDdv ddv = ddvDao.find(user.getStaffTypeId().toString());
				ret = "success";
				if (ddv != null) {
					String role = ddv.getValue();
					if ("超级管理员".equals(role)) {
						session.put("role", "admin");
						ret += "_admin";
					} else if ("管理员".equals(role)) {
						session.put("role", "manager");
						ret += "_manager";
					} else if  ("普通用户".equals(role)) {
						session.put("role", "user");
						ret += "_user";
					}					
				}
			}
		}
		return ret;
	}
}
