package com.phoenixcloud.dao.ctrl;

import java.math.BigInteger;
import java.util.List;
import java.util.Vector;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubHwNum;
import com.phoenixcloud.system.vo.Criteria;

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
	
	public List<PubHwNum> search(Criteria criteria) {
		String sql = "select num from PubHwNum num where num.deleteState=0";
		Vector vecParams = new Vector();
		if (criteria != null) {
			int index = 1;
			if (criteria.getStaffId() != null) {
				sql += " and num.staffId = ?" + index;
				vecParams.add(new BigInteger(criteria.getStaffId()));
				index++;
			}
			if (criteria.getHwType() != null && !"-1".equals("criteria.getHwType()")) {
				sql += " and num.hwType = ?" + index;
				index++;
				vecParams.add(new BigInteger(criteria.getHwType()));
			}
		}
		Query query = entityManager.createQuery(sql);
		for (int i = 0; i < vecParams.size(); i++) {
			query.setParameter(i+1, vecParams.get(i));
		}
		return query.getResultList();
	}
}
