package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysLog;

@Repository
public class SysLogDao extends AbstractDao<SysLog> {
	public SysLogDao() {
		super(SysLog.class);
	}
}
