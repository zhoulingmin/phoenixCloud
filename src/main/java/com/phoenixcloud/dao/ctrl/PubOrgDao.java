package com.phoenixcloud.dao.ctrl;

import java.util.Date;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubOrg;

@Repository
public class PubOrgDao extends AbstractDao<PubOrg>{
	
	public PubOrgDao() {
		super(PubOrg.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubOrg> findByOrgCataId(String orgCataId) {
		Query query = entityManager.createQuery("select pubOrg from PubOrg pubOrg where pubOrg.pubOrgCata.orgCataId = ?1 and pubOrg.deleteState = 0");
		query.setParameter(1, orgCataId);
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<PubOrg> findByOrgName(String orgName) {
		Query query = entityManager.createQuery("select org from PubOrg org where org.orgName like :code and org.deleteState = 0");
		query.setParameter("code", "%" + orgName + "%");
		return query.getResultList();
	}
	
	@Override
	public void remove(PubOrg org) {
		org.setDeleteState((byte)1);
		org.setUpdateTime(new Date());
		entityManager.merge(org);
	}
	
	public void removeByOrgCataId(String orgCataId) {
		Query query = entityManager.createQuery("update PubOrg set deleteState = 1, updateTime = ?1 where pubOrgCata.orgCataId = ?2 and deleteState = 0");
		query.setParameter(1, new Date());
		query.setParameter(2, orgCataId);
		query.executeUpdate();
	}
	
	public PubOrg find(String id) {
		Query query = entityManager.createQuery("select org from PubOrg org where org.deleteState=0 and org.orgId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
}
