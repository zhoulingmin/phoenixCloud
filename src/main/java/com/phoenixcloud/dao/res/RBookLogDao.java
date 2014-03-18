package com.phoenixcloud.dao.res;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookLog;

@Repository
public class RBookLogDao extends AbstractResDao<RBookLog>{
	public RBookLogDao() {
		super(RBookLog.class);
	}
}
