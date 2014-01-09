package com.phoenixcloud.dao;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookRe;

@Repository
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
	public List<RBookRe> getAllResByBookId(String bookId) {
		Query query = entityManager.createQuery("select rr from RBookRe rr where rr.bookId = ?1 and rr.deleteState = 0");
		query.setParameter(1, BigInteger.valueOf(Long.parseLong(bookId)));
		return query.getResultList();
	}
}
