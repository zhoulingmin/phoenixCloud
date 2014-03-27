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
		if (pages.length() > 0) {
			pages = pages.substring(0, pages.length());
		}
		return pages;
	}
}
