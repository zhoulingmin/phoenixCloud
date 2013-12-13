package com.phoenixcloud.agency.action;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.util.MiscUtils;

@Component
public class AgencyMgmtAction extends ActionSupport implements SessionAware, RequestAware, ServletResponseAware {
	private static final long serialVersionUID = 3155881995974380162L;
	private SessionMap session;
	private RequestMap request;
	private javax.servlet.http.HttpServletResponse response;
	private String cataId;
	private String type;
	private String orgCataName;
	private String orgName;
	
	public javax.servlet.http.HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(javax.servlet.http.HttpServletResponse response) {
		this.response = response;
	}

	public void setSession(SessionMap session) {
		this.session = session;
	}

	public void setRequest(RequestMap request) {
		this.request = request;
	}

	@Resource(name="agencyMgmtServiceImpl")
	private IAgencyMgmtService iAgencyMgmt;
	
	public void setiAgencyMgmt(IAgencyMgmtService iAgencyMgmt) {
		this.iAgencyMgmt = iAgencyMgmt;
	}

	public SessionMap getSession() {
		return session;
	}

	
	public RequestMap getRequest() {
		return request;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String listAllCata() throws Exception {
		List<PubOrgCata> cataList = null;
		if (null == type || type.isEmpty()) {
			cataList = iAgencyMgmt.getAllOrgCataByParentCataId(0L);
			this.request.put("cataList", cataList);
		} else if (cataId != null && !cataId.isEmpty()){
			try {
				long orgCataId = Long.parseLong(cataId);
				cataList = iAgencyMgmt.getAllOrgCataByParentCataId(orgCataId);
				Vector vList = new Vector();
				for (int i = 0; i < cataList.size(); i++) {
					vList.add(cataList.get(i));
				}
				List<PubOrg> orgList = iAgencyMgmt.getAllOrgByCataId(orgCataId);
				for (int i = 0; i < orgList.size(); i++) {
					vList.add(orgList.get(i));
				}
				String json = new Gson().toJson(vList);
				response.setContentType("text/html;charset=UTF-8");
				response.getWriter().write(json);
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
			}
			type = null;
			cataId = null;
			return null;
		} else {
			MiscUtils.getLogger().error("UNKNOWN ERROR!");
		}
		type = null;
		cataId = null;
		return "success";
	}

	public String searchCata() throws Exception {
		//List<PubOrgCata> cataList = iAgencyMgmt.searchOrgCata(orgCataName, orgName);
		//this.request.put("cataList", cataList);
		return listAllCata();
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

	@Override
	public void setSession(Map<String, Object> session) {
		// TODO Auto-generated method stub
		this.session = (SessionMap) session;
	}

	public String getCataId() {
		return cataId;
	}

	public void setCataId(String cataId) {
		this.cataId = cataId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getOrgCataName() {
		return orgCataName;
	}

	public void setOrgCataName(String orgCataName) {
		this.orgCataName = orgCataName;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

}
