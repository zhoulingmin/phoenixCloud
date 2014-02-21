package com.phoenixcloud.dao;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookDire;

@Repository
public class RBookDireDao extends AbstractDao<RBookDire>{
	
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
	
	public void remove(BigInteger direId) {
		RBookDire dire = find(direId.toString());
		if (dire != null) {
			dire.setDeleteState((byte)1);
		}
		entityManager.merge(dire);
	}
	
	public RBookDire findByBookId(String id) {
		Query query = entityManager.createQuery("select bd from RBookDire bd where bd.deleteState=0 and bd.bookId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
}
