package com.phoenixcloud.dao.ctrl;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysLog;

@Repository
public class SysLogDao extends AbstractCtrlDao<SysLog> {
	public SysLogDao() {
		super(SysLog.class);
	}
}
