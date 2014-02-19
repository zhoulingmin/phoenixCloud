package com.phoenixcloud.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubPress;

@Repository
public class PubPressDao extends AbstractDao<PubPress> {
	public PubPressDao() {
		super(PubPress.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubPress> getAll() {
		Query query = entityManager.createQuery("select pp from PubPress pp where pp.deleteState = '0'");
		List<PubPress> pressList = query.getResultList();
		if (pressList == null) {
			pressList = new ArrayList<PubPress>();
		}
		return pressList;
	}
}
