package com.phoenixcloud.agency.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.stereotype.Component;

import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.dao.PubOrgCataDao;
import com.phoenixcloud.dao.PubOrgDao;

@Component
public class AgencyMgmtServiceImpl implements IAgencyMgmtService {

	@PersistenceContext
	private EntityManager entityManager;
	
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
	public List<PubOrgCata> getAllOrgCataByParentCataId(long parentId) {
		// TODO Auto-generated method stub
		List<PubOrgCata> list = pubOrgCataDao.findAllByParentId(parentId);
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
	@Override
	public List<PubOrgCata> searchOrgCata(String orgCataName, String orgName) {
		Query query = entityManager.createQuery("select pubOrgCata from PubOrgCata pubOrgCata left outer join PubOrg pubOrg on pubOrgCata.orgCataId=pubOrg.orgCataId where pubOrgCata.orgCataName like :code1 or pubOrg.orgName like :code2");
		query.setParameter("code1", "%" + orgCataName + "%");
		query.setParameter("code2", "%" + orgName + "%");
		@SuppressWarnings("unchecked")
		List<PubOrgCata> list = query.getResultList();
		if (null == list) {
			list = new ArrayList<PubOrgCata>();
		}
		return list;
	}
}
