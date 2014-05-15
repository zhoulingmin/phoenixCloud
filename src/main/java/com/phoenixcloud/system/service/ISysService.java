package com.phoenixcloud.system.service;

import java.math.BigInteger;
import java.util.List;

import com.phoenixcloud.bean.PubHw;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.SysPurview;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.bean.SysStaffPurview;
import com.phoenixcloud.bean.SysStaffRegCode;

public interface ISysService {
	List<SysStaff> getAllStaff();
	void removeStaff(String id);
	void saveStaff(SysStaff staff);
	SysStaff findStaffById(String id);
	boolean isAdmin(SysStaff staff);
	
	List<PubHw> getAllHw();
	void removeHw(String id);
	void saveHw(PubHw hw);
	PubHw findHwById(String id);
	
	List<SysPurview> getAllPurview();
	void removePurview(String id);
	void savePurview(SysPurview purview);
	SysPurview findPurviewById(String id);
	
	List<SysStaffPurview> getAllStaffPur();
	void removeStaffPur(String id);
	void saveStaffPur(SysStaffPurview staffPur);
	SysStaffPurview findStaffPurById(String id);
	
	List<SysStaffRegCode> getAllStaffRegCodeList();
	void removeStaffRegCode(String id);
	void saveStaffRegCode(SysStaffRegCode staffRegCode);
	SysStaffRegCode findStaffRegCodeById(String id);
	
	PubServerAddr findServerAddrByOrgId(BigInteger orgId, String netType);
	PubServerAddr findParentAddrByOrgId(BigInteger orgId, String netType);
	
	PubServerAddr getProperAddr(PubServerAddr inAddr, PubServerAddr outAddr);
	
}
