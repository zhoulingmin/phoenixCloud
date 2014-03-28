package com.phoenixcloud.dao.res;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookPageRes;

@Repository
public class RBookPageResDao extends AbstractResDao<RBookPageRes>{
	
	public RBookPageResDao(){
		super(RBookPageRes.class);
	}
	
	public RBookPageRes find(String id) {
		Query query = entityManager.createQuery("select pgRs from RBookPageRes pgRs where pgRs.deleteState=0 and pgRs.pageResId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	public String getResRelatedPages(BigInteger resId) {
		Query query = entityManager.createQuery("select pgRs from RBookPageRes pgRs where pgRs.deleteState=0 and pgRs.resId = ?1");
		query.setParameter(1, resId);
		List<RBookPageRes> pgRsList = query.getResultList();

		StringBuffer pagesBuf = new StringBuffer();
		for (RBookPageRes pgRs : pgRsList) {
			pagesBuf.append(pgRs.getPageNum() + ",");
		}
		String pages = pagesBuf.toString();
		if (pages.length() > 1) {
			pages = pages.substring(0, pages.length()-1);
		}
		return pages;
	}
	
	public void removeByResId(BigInteger resId) {
		Query query = entityManager.createQuery("update RBookPageRes set deleteState = 1, updateTime = ?1 where resId = ?2 and deleteState = 0");
		query.setParameter(1, new java.util.Date());
		query.setParameter(2, resId);
		query.executeUpdate();
	}
	
	public RBookPageRes findByResIdPageNum(BigInteger resId, int pageNum) {
		Query query = entityManager.createQuery("select pgRs from RBookPageRes pgRs where pgRs.resId = ?1 and pgRs.pageNum = ?2");
		query.setParameter(1, resId);
		query.setParameter(2, pageNum);
		return getSingleResultOrNull(query);
	}
	
	public List<BigInteger> getResIdsByBookIdPageRange(BigInteger bookId, int start, int end){
		Query query = entityManager.createQuery("select pgRs.resId from RBookPageRes pgRs where pgRs.deleteState = 0 and pgRs.bookId = ?1 and pgRs.pageNum >= ?2 and pgRs.pageNum <= ?3");
		query.setParameter(1, bookId);
		query.setParameter(2, start);
		query.setParameter(3, end);
		return query.getResultList();
	}
}
