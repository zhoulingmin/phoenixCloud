package com.phoenixcloud.dao;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaffPurview;

@Repository
public class SysStaffPurviewDao extends AbstractDao<SysStaffPurview> {
	public SysStaffPurviewDao() {
		super(SysStaffPurview.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaffPurview> getAll() {
		Query query = entityManager.createQuery("select sp from SysStaffPurview sp where sp.deleteState = 0");
		return query.getResultList();
	}
	
	public SysStaffPurview find(String id) {
		Query query = entityManager.createQuery("select sp from SysStaffPurview sp where sp.deleteState = 0 and sp.staPurId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	public SysStaffPurview findByStaffAndPurviewId(BigInteger staffId, BigInteger purviewId, boolean ignoreStatus) {
		String sql = "select sp from SysStaffPurview sp where sp.staffId = ?1 and sp.purviewId = ?2";
		if (!ignoreStatus) {
			sql += " and sp.deleteState = 0";
		}
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, staffId);
		query.setParameter(2, purviewId);
		return getSingleResultOrNull(query);
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaffPurview> findByStaff(BigInteger staffId) {
		Query query = entityManager.createQuery("select sp from SysStaffPurview sp where sp.deleteState = 0 and sp.staffId = ?1");
		query.setParameter(1, staffId);
		return query.getResultList();
	}
	
	public void removeAllPurviewByStaff(BigInteger staffId) {
		Query query = entityManager.createQuery("update SysStaffPurview sp set sp.deleteState=1 where sp.deleteState = 0 and sp.staffId = ?1");
		query.setParameter(1, staffId);
		query.executeUpdate();
	}
}
