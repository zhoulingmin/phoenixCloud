package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysPurview;

@Repository
public class SysPurviewDao extends AbstractDao<SysPurview> {
	public SysPurviewDao() {
		super(SysPurview.class);
	}
}
