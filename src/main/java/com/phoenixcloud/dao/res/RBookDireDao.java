package com.phoenixcloud.dao.res;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookDire;

@Repository
public class RBookDireDao extends AbstractResDao<RBookDire>{
	
	public RBookDireDao() {
		super(RBookDire.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<RBookDire> findSubDires(BigInteger bookId, BigInteger parentId) {
		Query query = entityManager.createQuery("select bd from RBookDire bd where bd.deleteState=0 and bd.bookId=?1 and bd.parentDireId=?2");
		query.setParameter(1, bookId);
		query.setParameter(2, parentId);
		return query.getResultList();
	}
	
	public RBookDire findByBookId(String id) {
		Query query = entityManager.createQuery("select bd from RBookDire bd where bd.deleteState=0 and bd.bookId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	public RBookDire find(String id) {
		Query query = entityManager.createQuery("select bd from RBookDire bd where bd.direId = ?1 and bd.deleteState = 0");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
}
