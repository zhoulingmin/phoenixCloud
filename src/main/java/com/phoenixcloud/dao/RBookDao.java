package com.phoenixcloud.dao;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;
import java.util.Vector;

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
	
	public List<RBook> findByCriteria(RBook book) {
		String sql = "select rb from RBook rb where rb.deleteState = 0";
		int index = 1;
		Vector params = new Vector();
		if (book.getName() != null && book.getName().trim().length() > 0) {
			sql += " and rb.name like ?" + index;
			params.add("%" + book.getName().trim() + "%");
			index++;
		}
		if (book.getStuSegId() != null && book.getStuSegId().compareTo(BigInteger.ZERO) != 0) {
			sql += " and rb.stuSegId = ?" + index;
			params.add(book.getStuSegId());
			index++;
		}
		if (book.getSubjectId() != null && book.getSubjectId().compareTo(BigInteger.ZERO) != 0) {
			sql += " and rb.subjectId = ?" + index;
			params.add(book.getSubjectId());
			index++;
		}
		if (book.getClassId() != null && book.getClassId().compareTo(BigInteger.ZERO) != 0) {
			sql += " and rb.classId = ?" + index;
			params.add(book.getClassId());
			index++;
		}
		if (book.getPressId() != null && book.getPressId().compareTo(BigInteger.ZERO) != 0) {
			sql += " and rb.pressId = ?" + index;
			params.add(book.getPressId());
			index++;
		}
		
		if (book.getIsAudit() != (byte)-2) { // -2: indicates all book
			sql += " and rb.isAudit = " + book.getIsAudit();
		}
		
		Query query = entityManager.createQuery(sql);
		for (int i = 0; i < params.size(); i++) {
			query.setParameter((i + 1), params.get(i));
		}
		
		//if (book.getName() != null && book.getName().trim().length() > 0) {
		//	query.setParameter("name", "%" + book.getName().trim() + "%");
		//}
		
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<RBook> findByBookNo(String bookNo) {
		Query query = entityManager.createQuery("select rb from RBook rb where rb.deleteState = 0 and rb.bookNo = ?1");
		query.setParameter(1, bookNo);
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<RBook> findByAuditStatus(byte isAudit) {
		Query query = entityManager.createQuery("select rb from RBook rb where rb.deleteState = 0 and rb.isAudit = ?1");
		query.setParameter(1, isAudit);
		return query.getResultList();
	}
}
