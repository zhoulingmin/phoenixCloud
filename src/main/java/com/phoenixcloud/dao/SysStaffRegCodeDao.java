package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaffRegCode;

@Repository
public class SysStaffRegCodeDao extends AbstractDao<SysStaffRegCode> {
	public SysStaffRegCodeDao(){
		super(SysStaffRegCode.class);
	}
}
