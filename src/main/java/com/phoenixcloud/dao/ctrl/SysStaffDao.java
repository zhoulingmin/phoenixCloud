package com.phoenixcloud.dao.ctrl;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaff;

@Repository
public class SysStaffDao extends AbstractCtrlDao<SysStaff> {
	public SysStaffDao() {
		super(SysStaff.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaff> getAll() {
		Query query = entityManager.createQuery("select staff from SysStaff staff where staff.deleteState = 0");
		return query.getResultList();
	}
	
	public SysStaff find(String id) {
		Query query = entityManager.createQuery("select staff from SysStaff staff where staff.deleteState=0 and staff.staffId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	public SysStaff findByCode(String code) {
		Query query = entityManager.createQuery("select staff from SysStaff staff where staff.deleteState = 0 and staff.code = ?1 order by staff.updateTime desc");
		query.setParameter(1, code);
		return getSingleResultOrNull(query);
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaff> findByOrgId(BigInteger orgId) {
		Query query = entityManager.createQuery("select staff from SysStaff staff where staff.deleteState = 0 and staff.orgId = ?1");
		query.setParameter(1, orgId);
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<SysStaff> findByOrgIdAndType(BigInteger orgId, BigInteger type) {
		Query query = entityManager.createQuery("select staff from SysStaff staff where staff.deleteState = 0 and staff.orgId = ?1 and staff.staffTypeId = ?2");
		query.setParameter(1, orgId);
		query.setParameter(2, type);
		return query.getResultList();
	}
}
