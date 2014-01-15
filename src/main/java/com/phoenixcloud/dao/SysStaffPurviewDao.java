package com.phoenixcloud.dao;

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
}
