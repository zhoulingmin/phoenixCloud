package com.phoenixcloud.agency.service;

import java.util.List;

import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;

public interface IAgencyMgmtService {
	List<PubOrgCata> getAllOrgCataByParentCataId(long parentId);
	List<PubOrg> getAllOrgByCataId(long orgCataId);
	List<PubOrgCata> searchOrgCata(String orgCataName, String orgName);
	//PubOrgCata findOrgCataById(long orgCataId);
	//PubOrg findOrgById(long orgId);
}
