package com.phoenixcloud.dao;

import java.util.Date;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBook;

@Repository
public class RBookDao extends AbstractDao<RBook>{

	public RBookDao() {
		super(RBook.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<RBook> getAll() {
		Query query = entityManager.createQuery("select rbook from RBook rbook where rbook.deleteState = 0");
		return query.getResultList();
	}
	
	public void remove(String id) {
		Query query = entityManager.createQuery("update RBook set deleteState = 1, updateTime = ?1 where bookId = ?2 and deleteState = 0");
		query.setParameter(1, new Date());
		query.setParameter(2, id);
		query.executeUpdate();
	}
	
	public RBook find(String id) {
		Query query = entityManager.createQuery("select rb from RBook rb where rb.deleteState=0 and rb.bookId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
}
