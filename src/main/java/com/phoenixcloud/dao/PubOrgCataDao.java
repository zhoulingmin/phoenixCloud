package com.phoenixcloud.dao;

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
	public List<PubOrgCata> findAll() {
		Query query = entityManager.createQuery("select orgCata from PubOrgCata orgCata");
		return query.getResultList();
	}
}
