package com.phoenixcloud.dao;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaff;

@Repository
public class SysStaffDao extends AbstractDao<SysStaff> {
	public SysStaffDao() {
		super(SysStaff.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaff> getAll() {
		Query query = entityManager.createQuery("select staff from SysStaff staff where staff.deleteState = 0");
		return query.getResultList();
	}
}
