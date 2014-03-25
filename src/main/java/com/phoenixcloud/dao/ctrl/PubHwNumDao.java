package com.phoenixcloud.dao.ctrl;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubHwNum;

@Repository
public class PubHwNumDao extends AbstractCtrlDao<PubHwNum>{
	public PubHwNumDao() {
		super(PubHwNum.class);
	}
	
	public PubHwNum find(String id) {
		Query query = entityManager.createQuery("select num from PubHwNum num where num.deleteState = 0 and num.hwId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubHwNum> findByStaffId(BigInteger staffId) {
		Query query = entityManager.createQuery("select num from PubHwNum num where num.deleteState = 0 and num.staffId = ?1 order by num.hwType");
		query.setParameter(1, staffId);
		return query.getResultList();
	}
}
