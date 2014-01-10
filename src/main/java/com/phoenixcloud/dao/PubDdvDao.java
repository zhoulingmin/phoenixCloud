package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubDdv;

@Repository
public class PubDdvDao extends AbstractDao<PubDdv> {
	public PubDdvDao() {
		super(PubDdv.class);
	}
}
