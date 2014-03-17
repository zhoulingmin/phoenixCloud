package com.phoenixcloud.dao.res;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RRegCode;
import com.phoenixcloud.dao.ctrl.AbstractDao;

@Repository
public class RRegCodeDao extends AbstractDao<RRegCode>{
	public RRegCodeDao() {
		super(RRegCode.class);
	}
	
	public RRegCode find(String id) {
		Query query = entityManager.createQuery("select rr from RRegCode rr where rr.deleteState=0 and rr.regCodeId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	@SuppressWarnings("unchecked")
	public List<RRegCode> getAll() {
		Query query = entityManager.createQuery("select rr from RRegCode rr where rr.deleteState=0");
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<RRegCode> findByBookId(BigInteger bookId) {
		Query query = entityManager.createQuery("select rr from RRegCode rr where rr.deleteState=0 and rr.bookId = ?1");
		query.setParameter(1, bookId);
		return query.getResultList();
	}
}
