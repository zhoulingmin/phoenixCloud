package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookLog;

@Repository
public class RBookLogDao extends AbstractDao<RBookLog>{
	public RBookLogDao() {
		super(RBookLog.class);
	}
}
