package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaffOrgBook;

@Repository
public class SysStaffOrgBookDao extends AbstractDao<SysStaffOrgBook> {
	public SysStaffOrgBookDao() {
		super(SysStaffOrgBook.class);
	}
}
