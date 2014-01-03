package com.phoenixcloud.agency.service;

import java.math.BigInteger;
import java.util.List;

import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;

public interface IAgencyMgmtService {
	List<PubOrgCata> getAllOrgCataByParentCataId(BigInteger parentId);
	List<PubOrg> getAllOrgByCataId(String orgCataId);
	List<PubOrgCata> searchOrgCata(String orgCataName);
	List<PubOrg> searchOrg(String orgName);
	PubOrgCata findOrgCataById(String orgCataId);
	PubOrg findOrgById(String orgId);
	void saveCata(PubOrgCata orgCata);
	void removeCata(String orgCataId);
	void saveOrg(PubOrg orgNew);
	void removeOrg(String orgId);
}
