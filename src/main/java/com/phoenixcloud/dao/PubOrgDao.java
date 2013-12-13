package com.phoenixcloud.dao;

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
	public List<PubOrg> findByOrgCataId(long orgCataId) {
		Query query = entityManager.createQuery("select pubOrg from PubOrg pubOrg where pubOrg.orgCataId = ?1");
		query.setParameter(1, orgCataId);
		return query.getResultList();
	}
	
}
