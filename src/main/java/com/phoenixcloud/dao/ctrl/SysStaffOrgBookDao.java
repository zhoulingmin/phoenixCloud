package com.phoenixcloud.dao.ctrl;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.SysStaffOrgBook;

@Repository
public class SysStaffOrgBookDao extends AbstractCtrlDao<SysStaffOrgBook> {
	public SysStaffOrgBookDao() {
		super(SysStaffOrgBook.class);
	}
}
