package com.phoenixcloud.dao.res;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookLog;
import com.phoenixcloud.dao.ctrl.AbstractDao;

@Repository
public class RBookLogDao extends AbstractDao<RBookLog>{
	public RBookLogDao() {
		super(RBookLog.class);
	}
}
