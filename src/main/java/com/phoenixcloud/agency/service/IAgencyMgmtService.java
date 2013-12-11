package com.phoenixcloud.agency.service;

import java.util.List;

import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;

public interface IAgencyMgmtService {
	List<PubOrgCata> getAllOrgCata();
	List<PubOrg> getAllOrgByCataId(long orgCataId);
	//PubOrgCata findOrgCataById(long orgCataId);
	//PubOrg findOrgById(long orgId);
}
