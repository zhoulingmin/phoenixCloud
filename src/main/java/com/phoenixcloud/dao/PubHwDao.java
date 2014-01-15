package com.phoenixcloud.dao;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubHw;

@Repository
public class PubHwDao extends AbstractDao<PubHw> {
	public PubHwDao() {
		super(PubHw.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubHw> getAll(){
		Query query = entityManager.createQuery("select ph from PubHw ph where ph.deleteState = 0");
		return query.getResultList();
	}
	
	public PubHw find(String id) {
		Query query = entityManager.createQuery("select hw from PubHw hw where hw.deleteState = 0 and hw.hwId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
}
