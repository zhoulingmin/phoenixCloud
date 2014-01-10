package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaffPurview;

@Repository
public class SysStaffPurviewDao extends AbstractDao<SysStaffPurview> {
	public SysStaffPurviewDao() {
		super(SysStaffPurview.class);
	}
}
