package com.phoenixcloud.agency.action;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubDdv;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.SysStaffDao;
import com.phoenixcloud.util.MiscUtils;

@Scope("prototype")
@Component
public class AgencyMgmtAction extends ActionSupport implements RequestAware, ServletResponseAware {
	private static final long serialVersionUID = 3155881995974380162L;
	private RequestMap request;
	private javax.servlet.http.HttpServletResponse response;
	
	private String type;
	private String agencyName;
	private BigInteger orgTypeId;
	private String notes;
	private int number;
	private String cataId;
	private String createTime;

	//private String id;
	private BigInteger selfId;
	
	private String checkedNodes;
	
	com.phoenixcloud.agency.vo.Criteria criteria;
	
	@Autowired
	private SysStaffDao staffDao;
	
	@Autowired
	private PubDdvDao ddvDao;
	
	private boolean isClient;
	
	public javax.servlet.http.HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(javax.servlet.http.HttpServletResponse response) {
		this.response = response;
	}

	public void setRequest(RequestMap request) {
		this.request = request;
	}

	@Resource(name="agencyMgmtServiceImpl")
	private IAgencyMgmtService iAgencyMgmt;
	
	public void setiAgencyMgmt(IAgencyMgmtService iAgencyMgmt) {
		this.iAgencyMgmt = iAgencyMgmt;
	}
	
	public RequestMap getRequest() {
		return request;
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}
	
	public BigInteger getSelfId() {
		return selfId;
	}

	public void setSelfId(BigInteger selfId) {
		this.selfId = selfId;
	}

	public String getCataId() {
		return cataId;
	}

	public void setCataId(String cataId) {
		this.cataId = cataId;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public BigInteger getOrgTypeId() {
		return orgTypeId;
	}

	public void setOrgTypeId(BigInteger orgTypeId) {
		this.orgTypeId = orgTypeId;
	}

	public String getCheckedNodes() {
		return checkedNodes;
	}

	public void setCheckedNodes(String checkedNodes) {
		this.checkedNodes = checkedNodes;
	}
	
	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	
	public com.phoenixcloud.agency.vo.Criteria getCriteria() {
		return criteria;
	}

	public boolean isClient() {
		return isClient;
	}

	public void setClient(boolean isClient) {
		this.isClient = isClient;
	}

	public void setCriteria(com.phoenixcloud.agency.vo.Criteria criteria) {
		this.criteria = criteria;
	}
	
	private JSONObject searchCata(PubOrgCata cata) {
		String cataName = criteria.getCataName();
		String notes = criteria.getNotes();
		String orgName = criteria.getOrgName();
		if (cata == null) {
			return null;
		}
		JSONObject jsonObj = null;
		JSONArray cataArr = new JSONArray();
		
		// 判断下级机构目录是不是符合条件
		List<PubOrgCata> cataList = iAgencyMgmt.getAllOrgCataByParentCataId(
				BigInteger.valueOf(Long.parseLong(cata.getId())));
		for (PubOrgCata cataObj : cataList) {
			JSONObject cataJson = searchCata(cataObj);
			if (cataJson != null) {
				cataArr.add(cataJson);
			}
		}	
				
		// 判断本级机构目录下机构是不是符合条件
		if (!orgName.isEmpty() || !notes.isEmpty()) {
			List<PubOrg> orgList = iAgencyMgmt.getAllOrgByCataId(cata.getId());
			for (PubOrg org : orgList) {
				if ((!orgName.isEmpty() && org.getOrgName().indexOf(orgName) != -1)
					|| (!notes.isEmpty() && org.getNotes().indexOf(notes) != -1)) {
					JSONObject orgJson = new JSONObject();
					orgJson.put("type", "org");
					orgJson.put("selfId", org.getId());
					//jsonObj.put("id", "org-" + org.getId());
					//jsonObj.put("pid", "cata-" + cata.getId());
					orgJson.put("name", org.getOrgName());
					orgJson.put("isParent", false);
					cataArr.add(orgJson);
				}
			}
		}

		// 判断本级机构目录是不是符合条件
		if (!cataName.isEmpty() || !notes.isEmpty()) {
			if ((!cataName.isEmpty() && cata.getCataName().indexOf(cataName) != -1) 
					|| (!notes.isEmpty() && cata.getNotes().indexOf(notes) != -1)) {
				jsonObj = new JSONObject();
				jsonObj.put("type", "cata");
				jsonObj.put("selfId", cata.getId());
				//jsonObj.put("id", "cata-" + cata.getId());
				//jsonObj.put("pid", "cata-" + cata.getParentCataId());
				jsonObj.put("name", cata.getCataName());
				jsonObj.put("isParent", true);
			}
		}
		
		if (cataArr.size() > 0) {
			if (jsonObj == null) {
				jsonObj = new JSONObject();
				jsonObj.put("type", "cata");
				jsonObj.put("selfId", cata.getId());
				//jsonObj.put("id", "cata-" + cata.getId());
				//jsonObj.put("pid", "cata-" + cata.getParentCataId());
				jsonObj.put("name", cata.getCataName());
				jsonObj.put("isParent", true);
			}
			jsonObj.put("children", cataArr);
		}
		
		return jsonObj;
	}

	public String searchAgency(){
		JSONArray jsonArr = new JSONArray();
		if (criteria.getCataName().isEmpty() && criteria.getOrgName().isEmpty() && criteria.getNotes().isEmpty()) {
			return getAgency();
		}
		
		// 从0级机构目录搜索开始
		List<PubOrgCata> cataList = iAgencyMgmt.getAllOrgCataByParentCataId(BigInteger.ZERO);
		for (PubOrgCata cataObj : cataList) {
			JSONObject cataJson = searchCata(cataObj);
			if (cataJson != null) {
				jsonArr.add(cataJson);
			}
		}
		
		response.setCharacterEncoding("utf-8"); 
        response.setContentType("html/text");
        
        try {
        	PrintWriter out = response.getWriter();
        	out.print(jsonArr.toString());
        	out.flush();
        	out.close();
        } catch (Exception e) {
        	MiscUtils.getLogger().info(e.toString());
        }
        
		return null;
	}
	
	public String getStaff() {
		// 1.根据type判断是机构目录还是机构
		// 2.根据selfId获取子节点
		if (type != null && !"cata".equals(type) && !"org".equals(type)) {
			return null;
		}
		if (selfId == null) {
			selfId = BigInteger.ZERO;
		}
		JSONArray jsonArr = new JSONArray();
		if (type == null || "cata".equals(type)) {
			List<PubOrgCata> cataList = iAgencyMgmt.getAllOrgCataByParentCataId(selfId);
			List<PubOrg> orgList = iAgencyMgmt.getAllOrgByCataId(selfId.toString());
			
			// 3.convert cataList and orgList to json string
			for (PubOrgCata cata : cataList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("type", "cata");
				jsonObj.put("selfId", cata.getId());
				jsonObj.put("name", cata.getCataName());
				//jsonObj.put("id", "cata-" + cata.getId());
				//jsonObj.put("pid", "cata-" + cata.getParentCataId());
				jsonObj.put("isParent", true);
				jsonObj.put("nocheck", true);
				jsonArr.add(jsonObj);
			}
			
			for (PubOrg org : orgList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("type", "org");
				jsonObj.put("selfId", org.getId());
				jsonObj.put("name", org.getOrgName());
				//jsonObj.put("id", "org-" + org.getId());
				//jsonObj.put("pid", "cata-" + org.getPubOrgCata().getId());
				jsonObj.put("isParent", true);
				jsonObj.put("nocheck", true);
				jsonArr.add(jsonObj);
			}
		} else { 
			// get all staffs belong to this org
			PubDdv ddv = ddvDao.findClientUserDdv();
			do {
				if (isClient && ddv == null) {
					break;
				}
				List<SysStaff> staffList = staffDao.findByOrgId(selfId);
				for (SysStaff staff : staffList) {
					if ((isClient && !staff.getStaffTypeId().toString().equals(ddv.getId())) // 只显示客户端的用户
							|| (!isClient && staff.getStaffTypeId().toString().equals(ddv.getId()))) { // 只显示server用户
						continue;
					}
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("type", "staff");
					jsonObj.put("selfId", staff.getId());
					jsonObj.put("name", staff.getName());
					jsonObj.put("isParent", false);
					jsonArr.add(jsonObj);
				}
			} while(false);
		}
		
		response.setCharacterEncoding("utf-8"); 
        response.setContentType("html/text");
        
        try {
        	PrintWriter out = response.getWriter();
        	out.print(jsonArr.toString());
        	out.flush();
        	out.close();
        } catch (Exception e) {
        	MiscUtils.getLogger().info(e.toString());
        }
        
        type = null;
        selfId = BigInteger.ZERO;
        
		return null;
	}
	
	public String getAgency() {
		// 1.根据type判断是机构目录还是机构
		// 2.根据selfId获取子节点
		if (type != null && !"cata".equals(type)) {
			return null;
		}
		if (selfId == null) {
			selfId = BigInteger.ZERO;
		}
		List<PubOrgCata> cataList = iAgencyMgmt.getAllOrgCataByParentCataId(selfId);
		List<PubOrg> orgList = iAgencyMgmt.getAllOrgByCataId(selfId.toString());
		
		// 3.convert cataList and orgList to json string
		JSONArray jsonArr = new JSONArray();
		for (PubOrgCata cata : cataList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("type", "cata");
			jsonObj.put("selfId", cata.getId());
			jsonObj.put("name", cata.getCataName());
			//jsonObj.put("id", "cata-" + cata.getId());
			//jsonObj.put("pid", "cata-" + cata.getParentCataId());
			jsonObj.put("isParent", true);
			jsonArr.add(jsonObj);
		}
		
		for (PubOrg org : orgList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("type", "org");
			jsonObj.put("selfId", org.getId());
			jsonObj.put("name", org.getOrgName());
			//jsonObj.put("id", "org-" + org.getId());
			//jsonObj.put("pid", "cata-" + org.getPubOrgCata().getId());
			jsonObj.put("isParent", false);
			jsonArr.add(jsonObj);
		}
		
		response.setCharacterEncoding("utf-8"); 
        response.setContentType("html/text");
        
        try {
        	PrintWriter out = response.getWriter();
        	out.print(jsonArr.toString());
        	out.flush();
        	out.close();
        } catch (Exception e) {
        	MiscUtils.getLogger().info(e.toString());
        }
        
        type = null;
        selfId = BigInteger.ZERO;
        
		return null;
	}
	
	public String addAgency() {
		// type,name,number,cataId
		// 先分解cataId,再根据type在各个cataId下面创建number个agency
		
		if (cataId == null) {
			MiscUtils.getLogger().error("cataId is null！");
			return null;
		}
		
		String[] cataIdArr = cataId.split(",");
		if (cataIdArr == null || cataIdArr.length == 0) {
			MiscUtils.getLogger().error("没有合适的cata id列表！");
			number = 0;
			return null;
		}
		
		if ("cata".equals(type)) { // 机构目录
			for (String cataIdStr : cataIdArr) {
				BigInteger orgCataId = BigInteger.ZERO;
				try {
					orgCataId = BigInteger.valueOf(Long.parseLong(cataIdStr));
					for (int i = 0; i < number; i++) {
						PubOrgCata cataNew = new PubOrgCata();
						cataNew.setCataName(agencyName);
						cataNew.setNotes(notes);
						cataNew.setParentCataId(orgCataId);
						cataNew.setCreateTime(new Date());
						cataNew.setUpdateTime(new Date());
						cataNew.setDeleteState((byte)0);
						iAgencyMgmt.saveCata(cataNew);
					}
				} catch (Exception e) {
					MiscUtils.getLogger().info(e.toString());
					continue;
				}
			}
		} else if ("org".equals(type)) { // 机构
			for (String cataIdStr : cataIdArr) {
				PubOrgCata pubOrgCata = iAgencyMgmt.findOrgCataById(cataIdStr);
				if (pubOrgCata == null) {
					continue;
				}
				for (int i = 0; i < number; i++) {
					PubOrg orgNew = new PubOrg();
					orgNew.setOrgName(agencyName);
					orgNew.setNotes(notes);
					orgNew.setCreateTime(new Date());
					orgNew.setUpdateTime(new Date());
					orgNew.setDeleteState((byte)0);
					orgNew.setPubOrgCata(pubOrgCata);
					orgNew.setOrgTypeId(orgTypeId);
					iAgencyMgmt.saveOrg(orgNew);
				}
			}
		} else {
			MiscUtils.getLogger().info("创建机构目录或机构时，类型出错！");
		}
		return null;
	}
	
	public String removeAgency() {
		if (checkedNodes == null) {
			MiscUtils.getLogger().info("没有选择机构或机构目录！");
			return null;
		}
		JSONArray jsonNodes = JSONArray.fromObject(checkedNodes);
		if (jsonNodes == null || jsonNodes.size() == 0) {
			MiscUtils.getLogger().info("解析选中节点数据失败！");
			MiscUtils.getLogger().debug(checkedNodes);
			checkedNodes = null;
			return null;
		}
		
		for (int i = 0; i < jsonNodes.size(); i++) {
			JSONObject nodeObj = (JSONObject) jsonNodes.get(i);
			String id = (String) nodeObj.get("id");
			if ("cata".equals((String)nodeObj.get("type"))) {
				iAgencyMgmt.removeCata(id);
			} else {
				iAgencyMgmt.removeOrg(id);
			}
		}
		return null;
	}
	
	public String updateAgency() {
		if (cataId == null) {
			MiscUtils.getLogger().error("cataId is null！");
			return null;
		}
		
		String[] agencyIdArr = cataId.split(",");
		if (agencyIdArr == null || agencyIdArr.length == 0) {
			MiscUtils.getLogger().error("没有合适的cata id列表！");
			return null;
		}
		
		Date createDateTime = null;
		try {
			createDateTime = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").parse(createTime);
		} catch (Exception e) {
			MiscUtils.getLogger().warn(e.toString());
			createDateTime = new Date();
		}
		Date updateTime = new Date();
		if ("cata".equals(type)) {
			for (String id : agencyIdArr) {
				PubOrgCata pubOrgCata = iAgencyMgmt.findOrgCataById(id);
				if (pubOrgCata != null) {
					pubOrgCata.setCataName(agencyName);
					pubOrgCata.setCreateTime(createDateTime);
					pubOrgCata.setNotes(notes);
					pubOrgCata.setUpdateTime(updateTime);
					iAgencyMgmt.saveCata(pubOrgCata);
				}
			}
		} else {
			for (String id : agencyIdArr) {
				PubOrg pubOrg = iAgencyMgmt.findOrgById(id);
				if (pubOrg != null) {
					pubOrg.setCreateTime(createDateTime);
					pubOrg.setNotes(notes);
					pubOrg.setOrgName(agencyName);
					pubOrg.setOrgTypeId(orgTypeId);
					pubOrg.setUpdateTime(updateTime);
					iAgencyMgmt.saveOrg(pubOrg);
				}
			}
		}
		return null;
	}

}
