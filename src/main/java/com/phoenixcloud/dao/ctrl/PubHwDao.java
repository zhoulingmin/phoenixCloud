package com.phoenixcloud.dao.ctrl;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubHw;

@Repository
public class PubHwDao extends AbstractCtrlDao<PubHw> {
	public PubHwDao() {
		super(PubHw.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubHw> getAll(){
		Query query = entityManager.createQuery("select ph from PubHw ph where ph.deleteState = 0");
		return query.getResultList();
	}
	
	public PubHw find(String id) {
		Query query = entityManager.createQuery("select hw from PubHw hw where hw.deleteState = 0 and hw.hwId = ?1");
		query.setParameter(1, id);
		return getSingleResultOrNull(query);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubHw> getAllByStaffId(BigInteger staffId) {
		Query query = entityManager.createQuery("select hw from PubHw hw where hw.deleteState = 0 and hw.staffId = ?1 order by hw.hwType");
		query.setParameter(1, staffId);
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public List<PubHw> findByStaffIdHwType(BigInteger staffId, BigInteger hwType) {
		Query query = entityManager.createQuery("select hw from PubHw hw where hw.deleteState = 0 and hw.staffId = ?1 and hw.hwType = ?2");
		query.setParameter(1, staffId);
		query.setParameter(2, hwType);
		return query.getResultList();
	}
	
	public long getCountOfHw(BigInteger staffId, BigInteger hwType){
		Query query = entityManager.createQuery("select count(hw) from PubHw hw where hw.deleteState = 0 and hw.staffId = ?1 and hw.hwType = ?2");
		query.setParameter(1, staffId);
		query.setParameter(2, hwType);
		Object result = query.getSingleResult();
		if (result != null) {
			return (Long)result;
		}
		return 0L;
	}
}
