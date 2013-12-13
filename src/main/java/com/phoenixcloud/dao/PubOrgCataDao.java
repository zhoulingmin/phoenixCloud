package com.phoenixcloud.dao;

import java.math.BigDecimal;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubOrgCata;

@Repository
public class PubOrgCataDao extends AbstractDao<PubOrgCata>{
	
	public PubOrgCataDao() {
		super(PubOrgCata.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubOrgCata> findAllByParentId(long parentId) {
		Query query = entityManager.createQuery("select orgCata from PubOrgCata orgCata where orgCata.parentCataId = ?1");
		query.setParameter(1, new BigDecimal(parentId));
		return query.getResultList();
	}
}
