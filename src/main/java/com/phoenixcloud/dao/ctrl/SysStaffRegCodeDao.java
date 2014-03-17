package com.phoenixcloud.dao.ctrl;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaffRegCode;

@Repository
public class SysStaffRegCodeDao extends AbstractDao<SysStaffRegCode> {
	public SysStaffRegCodeDao(){
		super(SysStaffRegCode.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaffRegCode> getAll() {
		Query query = entityManager.createQuery("select regcode from SysStaffRegCode regcode where regcode.deleteState = 0");
		return query.getResultList();
	}
	
	public SysStaffRegCode find(String id) {
		Query query = entityManager.createQuery("select regcode from SysStaffRegCode regcode where regcode.deleteState = 0 and regcode.ssrcId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}	
}
