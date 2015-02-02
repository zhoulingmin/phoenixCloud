package com.phoenixcloud.dao.ctrl;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysLog;

@Repository
public class SysLogDao extends AbstractCtrlDao<SysLog> {
	public SysLogDao() {
		super(SysLog.class);
	}
	public void  saveSystemLog(SysLog sysLog){
		if (sysLog.getId() == null || "0".equals(sysLog.getId())) {
			persist(sysLog);
		} else {
			merge(sysLog);
		}
	}
	

	@SuppressWarnings("unchecked")
	public List<SysLog> findByMany(String hql) {
		Query query = entityManager.createQuery(hql);
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	public List<SysLog> findByManyfenye(String hql,int nowPage,int pageSize) {
		Query query = entityManager.createQuery(hql);
		query.setFirstResult(nowPage);
		query.setMaxResults(pageSize);
		return query.getResultList();
	}
}
