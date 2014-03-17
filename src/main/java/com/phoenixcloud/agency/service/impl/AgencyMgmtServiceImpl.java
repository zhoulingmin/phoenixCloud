package com.phoenixcloud.agency.service.impl;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.dao.ctrl.PubOrgCataDao;
import com.phoenixcloud.dao.ctrl.PubOrgDao;

@Service
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
	public List<PubOrgCata> getAllOrgCataByParentCataId(BigInteger parentId) {
		// TODO Auto-generated method stub
		List<PubOrgCata> list = pubOrgCataDao.findAllByParentId(parentId);
		if (null == list) {
			list = new ArrayList<PubOrgCata>();
		}
		return list;
	}

	@Override
	public List<PubOrg> getAllOrgByCataId(String orgCataId) {
		// TODO Auto-generated method stub
		List<PubOrg> list = pubOrgDao.findByOrgCataId(orgCataId);
		if (null == list) {
			list = new ArrayList<PubOrg>();
		}
		return list;
	}
	@Override
	public List<PubOrgCata> searchOrgCata(String orgCataName) {
		List<PubOrgCata> list = pubOrgCataDao.findByCataName(orgCataName);
		if (null == list) {
			list = new ArrayList<PubOrgCata>();
		}
		return list;
	}
	
	@Override
	public List<PubOrg> searchOrg(String orgName) {
		List<PubOrg> list = pubOrgDao.findByOrgName(orgName);
		if (null == list) {
			list = new ArrayList<PubOrg>();
		}
		return list;
	}
	
	@Override
	public PubOrgCata findOrgCataById(String orgCataId){
		return pubOrgCataDao.find(orgCataId);
	}
	
	@Override
	public PubOrg findOrgById(String orgId){
		return pubOrgDao.find(orgId);
	}
	
	@Override
	public void saveCata(PubOrgCata orgCata) {
		if (orgCata.getId() == null || orgCata.getId() == "0") {
			pubOrgCataDao.persist(orgCata);
		} else {
			pubOrgCataDao.merge(orgCata);
		}
	}
	
	private void removeChild(String orgCataId) {
		List<PubOrgCata> childCata = pubOrgCataDao.findAllByParentId(BigInteger.valueOf(Long.parseLong(orgCataId)));
		for (PubOrgCata cata : childCata) {
			removeChild(cata.getId());
		}
		pubOrgDao.removeByOrgCataId(orgCataId);
		pubOrgCataDao.remove(orgCataId);
	}

	@Transactional
	@Override
	public void removeCata(String orgCataId) {
		removeChild(orgCataId);
	}
	
	public void saveOrg(PubOrg orgNew) {
		if (orgNew.getId() == null || orgNew.getId() == "0") {
			pubOrgDao.persist(orgNew);
		} else {
			pubOrgDao.merge(orgNew);
		}
	}
	
	public void removeOrg(String orgId) {
		pubOrgDao.remove(orgId);
	}
}
