package com.phoenixcloud.agency.action;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrgCata;

@Component
public class AgencyMgmtAction extends ActionSupport implements SessionAware, RequestAware {
	private static final long serialVersionUID = 3155881995974380162L;
	private SessionMap session;
	private RequestMap request;
	
	@Resource(name="agencyMgmtServiceImpl")
	private IAgencyMgmtService iAgencyMgmt;
	
	public void setiAgencyMgmt(IAgencyMgmtService iAgencyMgmt) {
		this.iAgencyMgmt = iAgencyMgmt;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void setSession(Map map) {
		this.session = (SessionMap) map;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void setRequest(Map map) {
		this.request = (RequestMap) map;
	}
	
	public String listAllCata() {
		List<PubOrgCata> cataList = iAgencyMgmt.getAllOrgCata();
		this.request.put("cataList", cataList);
		return "success";
	}
}
