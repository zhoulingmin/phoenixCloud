package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubPress;

@Repository
public class PubPressDao extends AbstractDao<PubPress> {
	public PubPressDao() {
		super(PubPress.class);
	}
}
