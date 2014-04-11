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
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.SysStaffDao;
import com.phoenixcloud.util.SpringUtils;

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
	private SessionMap<String, Object> session;
	
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
		this.session = (SessionMap<String, Object>) session;
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

	@SuppressWarnings("unchecked")
	public String execute() {
		
		if (session.get("user") != null) {
			return "success";
		}
		
		if (staff == null) {
			return "login";
		}
		
		String ret = "NotFound";
		
		SysStaff user = staffDao.findByCode(staff.getCode());
		if (user != null) {
			
			PubDdv clientUserDdv = ddvDao.findClientUserDdv();
			if (clientUserDdv != null && clientUserDdv.getId().equals(user.getStaffTypeId().toString())) {
				ret = "clientUser";
			} else if (!user.getPassword().equals(staff.getPassword())) {
				ret = "ErrorPass";
			} else if (user.isExpired()) {
				ret = "Expired";
			} else {
				session.put("user", user);
				ret = "success";
			}
		}
		return ret;
	}
}
