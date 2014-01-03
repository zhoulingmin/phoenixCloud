package com.phoenixcloud.dao;

import java.math.BigInteger;
import java.util.Date;
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
	public List<PubOrgCata> findAllByParentId(BigInteger parentId) {
		Query query = entityManager.createQuery("select orgCata from PubOrgCata orgCata where orgCata.parentCataId = ?1 and orgCata.deleteState=0");
		query.setParameter(1, parentId);
		return query.getResultList();
	}
	
	public void save(PubOrgCata cata) {
		if (cata.getId() == null || cata.getId() == "0") {
			//cata.setOrgCataId(getCountAll() + 10);
			entityManager.persist(cata);
		} else {
			entityManager.merge(cata);
		}
		entityManager.flush();
	}
	
	@Override
	public void remove(PubOrgCata cata) {
		cata.setDeleteState((byte)1);
		cata.setUpdateTime(new Date());
		entityManager.merge(cata);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubOrgCata> findByCataName(String cataName) {
		Query query = entityManager.createQuery("select cata from PubOrgCata cata where cata.cataName like :code and cata.deleteState=0");
		query.setParameter("code", "%" + cataName + "%");
		return query.getResultList();
	}
}
