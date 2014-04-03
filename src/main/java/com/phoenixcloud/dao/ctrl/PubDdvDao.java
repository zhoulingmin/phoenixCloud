package com.phoenixcloud.dao.ctrl;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubDdv;

@Repository
public class PubDdvDao extends AbstractCtrlDao<PubDdv> {
	public PubDdvDao() {
		super(PubDdv.class);
	}
	
	public PubDdv findByDdvCode(BigInteger ddvCode) {
		Query query = entityManager.createQuery("select pd from PubDdv pd where pd.ddvCode = ?1 and pd.deleteState = '0'");
		query.setParameter(1, ddvCode);
		try {
			return (PubDdv) query.getSingleResult();
		} catch (Exception e) {}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public List<PubDdv> findByTblAndField(String tblName, String fieldName) {
		Query query = entityManager.createQuery("select pd from PubDdv pd where pd.tableName = ?1 and pd.fieldName = ?2");
		query.setParameter(1, tblName);
		query.setParameter(2, fieldName);
		List<PubDdv> ddvList = query.getResultList();
		if (ddvList == null) {
			ddvList = new ArrayList<PubDdv>();
		}
		return ddvList;
	}
	
	public PubDdv findClientUserDdv() {
		Query query = entityManager.createQuery("select pd from PubDdv pd " +
				"where pd.tableName = 'sys_staff' and pd.fieldName = 'STAFF_TYPE_ID' " +
				"and pd.value='客户端账号' and pd.deleteState = '0'");
		return getSingleResultOrNull(query);
	}
}
