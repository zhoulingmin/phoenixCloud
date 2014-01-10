package com.phoenixcloud.system.service;

import java.util.List;

import com.phoenixcloud.bean.PubHw;
import com.phoenixcloud.bean.SysStaff;

public interface ISysService {
	List<SysStaff> getAllStaff();
	void removeStaff(String id);
	void saveStaff(SysStaff staff);
	SysStaff findStaffById(String id);
	
	List<PubHw> getAllHw();
	void removeHw(String id);
	void saveHw(PubHw hw);
	PubHw findHwById(String id);
	
}
