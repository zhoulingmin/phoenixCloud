package com.phoenixcloud.dao.res;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.dao.ctrl.AbstractDao;

@Repository("rBookReDao")
public class RBookReDao extends AbstractDao<RBookRe>{
	public RBookReDao() {
		super(RBookRe.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<BigInteger> getAllBookIds() {
		Query query = entityManager.createQuery("select distinct rr.bookId from RBookRe rr where rr.deleteState = 0");
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<RBookRe> getAllResByBookId(BigInteger bookId) {
		Query query = entityManager.createQuery("select rr from RBookRe rr where rr.bookId = ?1 and rr.deleteState = 0");
		query.setParameter(1, bookId);
		return query.getResultList();
	}
	
	public RBookRe find(String id) {
		Query query = entityManager.createQuery("select rr from RBookRe rr where rr.deleteState=0 and rr.resId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<RBookRe> getSubRes(BigInteger bookId, BigInteger parentResId) {
		Query query = entityManager.createQuery("select rr from RBookRe rr where rr.bookId = ?1 and rr.parentResId = ?2 and rr.deleteState = 0");
		query.setParameter(1, bookId);
		query.setParameter(2, parentResId);
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<RBookRe> getAll() {
		Query query = entityManager.createQuery("select rr from RBookRe rr where rr.deleteState = 0");
		return query.getResultList();
	}
}
