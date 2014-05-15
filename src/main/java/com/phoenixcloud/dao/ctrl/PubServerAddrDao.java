package com.phoenixcloud.dao.ctrl;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubServerAddr;

@Repository
public class PubServerAddrDao extends AbstractCtrlDao<PubServerAddr> {
	public PubServerAddrDao() {
		super(PubServerAddr.class);
	}
	
	@SuppressWarnings("unchecked")
	public PubServerAddr findByOrgId(BigInteger orgId, String netType) {
		Query query = entityManager.createQuery("select psa from PubServerAddr psa where psa.deleteState = 0 and psa.orgId = ?1 and psa.netType = ?2 order by psa.updateTime desc");
		query.setParameter(1, orgId);
		query.setParameter(2, netType);
		return getSingleResultOrNull(query);
	}
}
