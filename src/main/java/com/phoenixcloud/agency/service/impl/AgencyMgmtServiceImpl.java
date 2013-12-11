package com.phoenixcloud.agency.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.dao.PubOrgCataDao;
import com.phoenixcloud.dao.PubOrgDao;

@Component
public class AgencyMgmtServiceImpl implements IAgencyMgmtService {

	@Resource
	private PubOrgCataDao pubOrgCataDao;
	
	@Resource
	private PubOrgDao pubOrgDao;
	
	public void setPubOrgCataDao(PubOrgCataDao pubOrgCataDao) {
		this.pubOrgCataDao = pubOrgCataDao;
	}

	public void setPubOrgDao(PubOrgDao pubOrgDao) {
		this.pubOrgDao = pubOrgDao;
	}
	
	@Override
	public List<PubOrgCata> getAllOrgCata() {
		// TODO Auto-generated method stub
		List<PubOrgCata> list = pubOrgCataDao.findAll();
		if (null == list) {
			list = new ArrayList<PubOrgCata>();
		}
		return list;
	}

	@Override
	public List<PubOrg> getAllOrgByCataId(long orgCataId) {
		// TODO Auto-generated method stub
		List<PubOrg> list = pubOrgDao.findByOrgCataId(orgCataId);
		if (null == list) {
			list = new ArrayList<PubOrg>();
		}
		return list;
	}

//	@Override
//	public PubOrgCata findOrgCataById(long orgCataId) {
//		// TODO Auto-generated method stub
//		return pubOrgCataDao.find(orgCataId);
//	}
//
//	@Override
//	public PubOrg findOrgById(long orgId) {
//		// TODO Auto-generated method stub
//		return pubOrgDao.find(orgId);
//	}

}
