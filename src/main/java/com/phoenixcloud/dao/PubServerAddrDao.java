package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.PubServerAddr;

@Repository
public class PubServerAddrDao extends AbstractDao<PubServerAddr> {
	public PubServerAddrDao() {
		super(PubServerAddr.class);
	}
}
