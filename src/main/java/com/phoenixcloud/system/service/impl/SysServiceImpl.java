package com.phoenixcloud.system.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.phoenixcloud.bean.PubHw;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.dao.PubHwDao;
import com.phoenixcloud.dao.SysStaffDao;
import com.phoenixcloud.system.service.ISysService;

@Service
public class SysServiceImpl implements ISysService{
	
	@Resource
	private SysStaffDao staffDao;
	
	@Resource
	private PubHwDao hwDao;
	
	public void setHwDao(PubHwDao hardwareDao) {
		this.hwDao = hardwareDao;
	}

	public void setStaffDao(SysStaffDao staffDao) {
		this.staffDao = staffDao;
	}

	@Override
	public List<SysStaff> getAllStaff() {
		List<SysStaff> staffList = staffDao.getAll();
		if (staffList == null) {
			staffList = new ArrayList<SysStaff>();
		}
		return staffList;
	}
	
	@Override
	public void removeStaff(String id) {
		SysStaff staff = staffDao.find(id);
		if (staff == null) {
			return;
		}
		staff.setUpdateTime(new Date());
		staff.setDeleteState((byte)1);
		staffDao.merge(staff);
	}
	
	@Override
	public void saveStaff(SysStaff staff) {
		if (staff.getId() == null || "0".equals(staff.getId())) {
			staffDao.persist(staff);
		} else {
			staffDao.merge(staff);
		}
	}
	
	@Override
	public SysStaff findStaffById(String id) {
		return staffDao.find(id);
	}

	@Override
	public List<PubHw> getAllHw() {
		// TODO Auto-generated method stub
		List<PubHw> hardwareList = hwDao.getAll();
		if (hardwareList == null) {
			hardwareList = new ArrayList<PubHw>();
		}
		return hardwareList;
	}

	@Override
	public void removeHw(String id) {
		// TODO Auto-generated method stub
		PubHw hw = hwDao.find(id);
		if (hw == null) {
			return;
		}
		hw.setUpdateTime(new Date());
		hw.setDeleteState((byte)1);
		hwDao.merge(hw);
	}

	@Override
	public void saveHw(PubHw hw) {
		// TODO Auto-generated method stub
		if (hw.getId() == null || "0".equals(hw.getId())) {
			hwDao.persist(hw);
		} else {
			hwDao.merge(hw);
		}
	}

	@Override
	public PubHw findHwById(String id) {
		// TODO Auto-generated method stub
		return hwDao.find(id);
	}
}
