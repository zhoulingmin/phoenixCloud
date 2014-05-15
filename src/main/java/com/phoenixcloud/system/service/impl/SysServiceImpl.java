package com.phoenixcloud.system.service.impl;

import java.io.IOException;
import java.math.BigInteger;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.phoenixcloud.bean.PubDdv;
import com.phoenixcloud.bean.PubHw;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.SysPurview;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.bean.SysStaffPurview;
import com.phoenixcloud.bean.SysStaffRegCode;
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.PubHwDao;
import com.phoenixcloud.dao.ctrl.PubOrgCataDao;
import com.phoenixcloud.dao.ctrl.PubOrgDao;
import com.phoenixcloud.dao.ctrl.PubServerAddrDao;
import com.phoenixcloud.dao.ctrl.SysPurviewDao;
import com.phoenixcloud.dao.ctrl.SysStaffDao;
import com.phoenixcloud.dao.ctrl.SysStaffPurviewDao;
import com.phoenixcloud.dao.ctrl.SysStaffRegCodeDao;
import com.phoenixcloud.system.service.ISysService;
import com.phoenixcloud.util.MiscUtils;

@Service
public class SysServiceImpl implements ISysService{
	
	@Autowired
	private SysStaffDao staffDao;
	
	@Autowired
	private PubHwDao hwDao;
	
	@Autowired
	private SysPurviewDao purviewDao;
	
	@Autowired
	private SysStaffPurviewDao staffPurDao;
	
	@Autowired
	private SysStaffRegCodeDao staffRegCodeDao;
	
	@Autowired
	private PubServerAddrDao serverAddrDao;
	
	@Autowired
	private PubDdvDao ddvDao;
	
	@Autowired
	private PubOrgDao orgDao;
	
	@Autowired
	private PubOrgCataDao cataDao;
	
	@PersistenceContext(unitName="ctrlDbUnit")
	private EntityManager entityManager;
	
	public void setPurviewDao(SysPurviewDao purviewDao) {
		this.purviewDao = purviewDao;
	}

	public void setHwDao(PubHwDao hardwareDao) {
		this.hwDao = hardwareDao;
	}

	public void setStaffDao(SysStaffDao staffDao) {
		this.staffDao = staffDao;
	}

	public void setStaffPurDao(SysStaffPurviewDao staffPurDao) {
		this.staffPurDao = staffPurDao;
	}

	public void setStaffRegCodeDao(SysStaffRegCodeDao staffRegCodeDao) {
		this.staffRegCodeDao = staffRegCodeDao;
	}
	
	public void setServerAddrDao(PubServerAddrDao serverAddrDao) {
		this.serverAddrDao = serverAddrDao;
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
	
	public boolean isAdmin(SysStaff staff) {
		if (staff == null) {
			return false;
		}
		PubDdv ddv = ddvDao.find(staff.getStaffTypeId().toString());
		if (ddv == null) {
			return false;
		}
		if ("机构管理员".equals(ddv.getValue()) || "超级管理员".equals(ddv.getValue())) {
			return true;
		}
		return false;
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
	
	@Override
	public List<SysPurview> getAllPurview() {
		List<SysPurview> purviewList = purviewDao.getAll();
		if (purviewList == null) {
			purviewList = new ArrayList<SysPurview>();
		}
		return purviewList;
	}
	
	@Override
	public void removePurview(String id) {
		SysPurview purview = purviewDao.find(id);
		if (purview != null) {
			purview.setDeleteState((byte)1);
			purview.setUpdateTime(new Date());
			purviewDao.merge(purview);
		}
	}
	
	@Override
	public void savePurview(SysPurview purview) {
		if (purview.getId() == null || "0".equals(purview.getId())) {
			purviewDao.persist(purview);
		} else {
			purviewDao.merge(purview);
		}
	}
	
	@Override
	public SysPurview findPurviewById(String id) {
		return purviewDao.find(id);
	}
	
	@Override
	public List<SysStaffPurview> getAllStaffPur() {
		List<SysStaffPurview> staffPurList = staffPurDao.getAll();
		if (staffPurList == null) {
			staffPurList = new ArrayList<SysStaffPurview>();
		}
		return staffPurList;
	}

	@Override
	public void removeStaffPur(String id) {
		SysStaffPurview staffPur = staffPurDao.find(id);
		if (staffPur != null) {
			staffPur.setDeleteState((byte)1);
			staffPur.setUpdateTime(new Date());
			staffPurDao.merge(staffPur);
		}
	}

	@Override
	public void saveStaffPur(SysStaffPurview staffPur) {
		if (staffPur.getId() == null || "0".equals(staffPur.getId())) {
			staffPurDao.persist(staffPur);
		} else {
			staffPurDao.merge(staffPur);
		}
	}

	@Override
	public SysStaffPurview findStaffPurById(String id) {
		return staffPurDao.find(id);
	}
	
	@Override
	public List<SysStaffRegCode> getAllStaffRegCodeList() {
		List<SysStaffRegCode> regCodeList = staffRegCodeDao.getAll();
		if (regCodeList == null) {
			regCodeList = new ArrayList<SysStaffRegCode>();
		}
		return regCodeList;
	}

	@Override
	public void removeStaffRegCode(String id) {
		SysStaffRegCode regCode = staffRegCodeDao.find(id);
		if (regCode != null) {
			regCode.setUpdateTime(new Date());
			regCode.setDeleteState((byte)1);
			staffRegCodeDao.merge(regCode);
		}
	}

	@Override
	public void saveStaffRegCode(SysStaffRegCode staffRegCode) {
		if (staffRegCode.getId() == null || "0".equals(staffRegCode.getId())) {
			staffRegCodeDao.persist(staffRegCode);
		} else {
			staffRegCodeDao.merge(staffRegCode);
		}
	}

	@Override
	public SysStaffRegCode findStaffRegCodeById(String id) {
		return staffRegCodeDao.find(id);
	}
	
	public PubServerAddr findServerAddrByOrgId(BigInteger orgId, String netType) {
		return serverAddrDao.findByOrgId(orgId, netType);
	}
	
	public PubServerAddr findParentAddrByOrgId(BigInteger orgId, String netType) {
		// 1. find parent cata
		// 2. find all org and get addr
		
		PubServerAddr addr = null;
		PubOrg org = orgDao.find(orgId.toString());
		if (org == null) {
			return null;
		}
		PubOrgCata cata = org.getPubOrgCata();
		while (cata != null) {
			cata = entityManager.merge(cata);
			List<PubOrg> orgList = cata.getPubOrgs();
			if (orgList != null) {
				for (PubOrg orgTmp : orgList) {
					addr = serverAddrDao.findByOrgId(new BigInteger(orgTmp.getId()), netType);
					if (addr != null) {
						break;
					}
				}
			}
			if (addr != null) {
				break;
			}
			cata = cataDao.find(cata.getParentCataId().toString());
		}
		
		return addr;
	}
	
	public PubServerAddr getProperAddr(PubServerAddr inAddr, PubServerAddr outAddr) {
		if (inAddr == null && outAddr == null) {
			return null;
		}
		InetAddress local = null;
		InetAddress inInetAddr = null;
		InetAddress outInetAddr = null;

		try {
			local = InetAddress.getLocalHost();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			MiscUtils.getLogger().info(e.toString());
			return null;
		}
		
		PubServerAddr addr = null;
		if (inAddr != null) {
			try {
				inInetAddr = InetAddress.getByName(inAddr.getBookSerIp());
				if (inInetAddr != null && isReachable(local, inInetAddr, inAddr.getBookSerPort(), 3000)) {
					addr = inAddr;
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				MiscUtils.getLogger().info(e.toString());
			}
		}
		
		if (addr == null && outAddr != null) {
			try {
				outInetAddr = InetAddress.getByName(outAddr.getBookSerIp());
				if (outInetAddr != null && isReachable(local, outInetAddr, outAddr.getBookSerPort(), 3000)) {
					addr = outAddr;
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				MiscUtils.getLogger().info(e.toString());
			}
		}
		
		return addr;
	}
	
	private boolean isReachable(InetAddress localInetAddr, 
			InetAddress remoteInetAddr, int port, int timeout) {

		boolean isReachable = false;
		Socket socket = null;
		try {
			socket = new Socket();
			// 端口号设置为 0 表示在本地挑选一个可用端口进行连接
			SocketAddress localSocketAddr = new InetSocketAddress(
					localInetAddr, 0);
			socket.bind(localSocketAddr);
			InetSocketAddress endpointSocketAddr = new InetSocketAddress(
					remoteInetAddr, port);
			socket.connect(endpointSocketAddr, timeout);
			MiscUtils.getLogger().info("SUCCESS - connection established! Local: "
					+ localInetAddr.getHostAddress() + " remote: "
					+ remoteInetAddr.getHostAddress() + " port" + port);
			isReachable = true;
		} catch (Exception e) {
			MiscUtils.getLogger().info("FAILRE - CAN not connect! Local: "
					+ localInetAddr.getHostAddress() + " remote: "
					+ remoteInetAddr.getHostAddress() + " port" + port);
		} finally {
			if (socket != null) {
				try {
					socket.close();
				} catch (Exception e) {
					MiscUtils.getLogger().info("Error occurred while closing socket..");
				}
			}
		}
		
		return isReachable;
	}
}
