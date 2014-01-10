package com.phoenixcloud.system.action;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.PubHw;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.system.service.ISysService;

@Scope("prototype")
@Component
public class SystemMgmtAction extends ActionSupport implements RequestAware,ServletResponseAware{
	
	private static final long serialVersionUID = 735713101705200424L;
	
	private RequestMap request;
	private HttpServletResponse response;
	
	@Resource(name="sysServiceImpl")
	private ISysService iSysService;
	
	private SysStaff staff;
	private String userIdArr;
	
	private PubHw hw;
	private String hwIdArr;
	
	public void setiSysService(ISysService iSysService) {
		this.iSysService = iSysService;
	}

	@Override
	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response;
	}

	@Override
	public void setRequest(Map<String, Object> request) {
		// TODO Auto-generated method stub
		this.request = (RequestMap)request;
	}
	
	public SysStaff getStaff() {
		return staff;
	}

	public void setStaff(SysStaff staff) {
		this.staff = staff;
	}

	public String getUserIdArr() {
		return userIdArr;
	}

	public void setUserIdArr(String userIdArr) {
		this.userIdArr = userIdArr;
	}

	public PubHw getHw() {
		return hw;
	}

	public void setHw(PubHw hw) {
		this.hw = hw;
	}

	public String getHwIdArr() {
		return hwIdArr;
	}

	public void setHwIdArr(String hwIdArr) {
		this.hwIdArr = hwIdArr;
	}

	public String getAllUser(){
		List<SysStaff> staffList = iSysService.getAllStaff();
		request.put("staffList", staffList);
		return "success";
	}
	
	public String addUser() {
		Date curDate = new Date();
		staff.setCreateTime(curDate);
		staff.setUpdateTime(curDate);
		iSysService.saveStaff(staff);
		return null;
	}
	
	public String editUser() {
		staff = iSysService.findStaffById(staff.getId());
		return "success";
	}
	
	public String removeUser() {
		if (userIdArr.length() == 0) {
			return null;
		}
		String userId[] = userIdArr.split(",");
		for (String id : userId) {
			iSysService.removeStaff(id);
		}
		return null;
	}
	
	public String saveUser() {
		staff.setUpdateTime(new Date());
		iSysService.saveStaff(staff);
		return null;
	}
		
	public String getAllHw() {
		List<PubHw> hwList = iSysService.getAllHw();
		request.put("hwList", hwList);
		return "success";
	}
	
	public String editHw() {
		hw = iSysService.findHwById(hw.getId());
		return "success";
	}
	
	public String removeHw() {
		if (hwIdArr.length() == 0) {
			return null;
		}
		String hwId[] = hwIdArr.split(",");
		for (String id : hwId) {
			iSysService.removeHw(id);
		}
		return null;
	}
	
	public String saveHw() {
		hw.setUpdateTime(new Date());
		iSysService.saveHw(hw);
		return null;
	}
	
	public String addHw() {
		Date curDate = new Date();
		hw.setCreateTime(curDate);
		hw.setUpdateTime(curDate);
		iSysService.saveHw(hw);
		return null;
	}

}
