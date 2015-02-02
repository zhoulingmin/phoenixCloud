package com.phoenixcloud.dao.res;

import java.util.List;

import javax.persistence.Query;
import org.springframework.stereotype.Repository;
import com.phoenixcloud.bean.RBookLog;

@Repository
public class RBookLogDao extends AbstractResDao<RBookLog>{
	public RBookLogDao() {
		super(RBookLog.class);
	}
	public void  saveBookLog(RBookLog bookLog){
		if (bookLog.getId() == null || "0".equals(bookLog.getId())) {
			persist(bookLog);
		} else {
			merge(bookLog);
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<RBookLog> findByMany(String hql) {
		Query query = entityManager.createQuery(hql);
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	public List<RBookLog> findByManyfenye(String hql,int nowPage,int pageSize) {
		Query query = entityManager.createQuery(hql);
		query.setFirstResult(nowPage);
		query.setMaxResults(pageSize);
		return query.getResultList();
	}
	
}
