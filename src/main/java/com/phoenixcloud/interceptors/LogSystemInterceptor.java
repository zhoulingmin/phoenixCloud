package com.phoenixcloud.interceptors;

import java.math.BigInteger;
import java.util.Date;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation; 
import com.opensymphony.xwork2.interceptor.MethodFilterInterceptor;
import com.phoenixcloud.agency.action.AgencyMgmtAction;
import com.phoenixcloud.bean.PubHwNum;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.SysLog;
import com.phoenixcloud.bean.SysPurview;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.dao.ctrl.PubHwNumDao;
import com.phoenixcloud.dao.ctrl.PubOrgDao;
import com.phoenixcloud.dao.ctrl.SysLogDao;
import com.phoenixcloud.dao.ctrl.SysPurviewDao;
import com.phoenixcloud.dao.ctrl.SysStaffDao;
import com.phoenixcloud.listener.Nowdatetime;
import com.phoenixcloud.system.action.SystemMgmtAction;
import com.phoenixcloud.user.action.LoginAction; 


@SuppressWarnings("serial") 
public class LogSystemInterceptor extends MethodFilterInterceptor{ 
	
	@Autowired
	private SysStaffDao sysStaffDao;
	
    @Autowired
	private  SysLogDao sysLogDao;
    
    @Autowired
   	private  PubHwNumDao hwNumDao;
    
    @Autowired
   	private SysPurviewDao sysPurviewDao;
    
    @Autowired
   	private PubOrgDao pubOrgDao;
    
	public PubOrgDao getPubOrgDao() {
		return pubOrgDao;
	}

	public void setPubOrgDao(PubOrgDao pubOrgDao) {
		this.pubOrgDao = pubOrgDao;
	}

	public SysPurviewDao getSysPurviewDao() {
		return sysPurviewDao;
	}

	public void setSysPurviewDao(SysPurviewDao sysPurviewDao) {
		this.sysPurviewDao = sysPurviewDao;
	}

	public PubHwNumDao getHwNumDao() {
		return hwNumDao;
	}

	public void setHwNumDao(PubHwNumDao hwNumDao) {
		this.hwNumDao = hwNumDao;
	}

	public SysLogDao getSysLogDao() {
		return sysLogDao;
	}

	public void setSysLogDao(SysLogDao sysLogDao) {
		this.sysLogDao = sysLogDao;
	}


	public SysStaffDao getSysStaffDao() {
		return sysStaffDao;
	}

	public void setSysStaffDao(SysStaffDao sysStaffDao) {
		this.sysStaffDao = sysStaffDao;
	}

	@Override
	protected String doIntercept(ActionInvocation invocation) throws Exception {
		SysLog sysLogInfo=new SysLog();
	    HttpServletRequest request = ServletActionContext.getRequest(); 
		//注册前查询用户名是否存在；
	    String staffcode1 = request.getParameter("staff.code");
		SysStaff staff1=sysStaffDao.findByCode(staffcode1);
		
		//删除前查询用户名；
		String    userremove=request.getParameter("userIdArr");
		SysStaff staffremove=sysStaffDao.find(userremove);
		
		String result=invocation.invoke();
		//得到action
	    Object action=invocation.getAction(); 
	    //得到action的方法；
	    String method=  invocation.getProxy().getMethod(); 
		
		//得到当前用户
		ActionContext ctx = invocation.getInvocationContext();  
	    Map session = ctx.getSession();
		SysStaff curStaff = (SysStaff)session.get("user");   
		//得到当前传来的参数
		Map actionParameters=invocation.getInvocationContext().getParameters();
	    //请求HttpServletRequest
	   
	    //获取IP地址；
	    String ip  =  request.getHeader( " x-forwarded-for " );  
	       if (ip  ==   null   ||  ip.length()  ==   0   ||   " unknown " .equalsIgnoreCase(ip))  {  
	          ip  =  request.getHeader( " Proxy-Client-IP " );  
	      }   
	       if (ip  ==   null   ||  ip.length()  ==   0   ||   " unknown " .equalsIgnoreCase(ip))  {  
	          ip  =  request.getHeader( " WL-Proxy-Client-IP " );  
	      }   
	       if (ip  ==   null   ||  ip.length()  ==   0   ||   " unknown " .equalsIgnoreCase(ip))  {  
	         ip  =  request.getRemoteAddr();  
	     }   
	     //操作结果
	    boolean opResult = invocation.getProxy().getExecuteResult();  
	    
	   
	    String logContentHead ="";
	    String logNotes="用户登录时IP地址为："+ip+"。操作结果："+opResult;

   try{
	    if(action instanceof LoginAction){
	    	/**
    		 * 登录日志
    		 */
	    	if(curStaff!=null){
		    	if(method.equals("login")){
		    		logContentHead ="登录记录。账号："+curStaff.getCode()+ ",用户名:"+curStaff.getName()+",在"+Nowdatetime.getdate()+"登录。"; 
	         		//System.out.println(logContentHead); 
		    		sysLogInfo.setLogTypeId(BigInteger.valueOf(74));
		    		sysLogInfo.setFunctionId(BigInteger.valueOf(74));
	                sysLogInfo.setContent(logContentHead);
		    	    sysLogInfo.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
		    	    sysLogInfo.setCreateTime(new Date());
		    		sysLogInfo.setUpdateTime(new Date());
		    		sysLogInfo.setDeleteState((byte)0);
		    		sysLogInfo.setNotes(logNotes);
		    		
		    		sysLogDao.saveSystemLog(sysLogInfo);
		    	}
	    	}
	    	/**
    		 * 注册日志
    		 */
	    	if(method.equals("register")){
         		String confirm_pass= request.getParameter("confirm_pass");
         		String orgNameTmp= request.getParameter("orgNameTmp");
         		String staffcode = request.getParameter("staff.code");
         		String staffdeleteState= request.getParameter("staff.deleteState");
         		String staffemail = request.getParameter("staff.email");
         		String staffname= request.getParameter("staff.name");
         		String staffnotes = request.getParameter("staff.notes");
         		String stafforgId= request.getParameter("staff.orgId");
         		String staffpassword = request.getParameter("staff.password");
         		String staffstaffTypeId= request.getParameter("staff.staffTypeId");
         		SysStaff staff=sysStaffDao.findByCode(staffcode);
         		if(staff1==null){
	         		if(staff!=null){
		         		logContentHead ="注册记录。注册账号为："+staffcode+";所属机构:"+orgNameTmp+"在："+Nowdatetime.getdate()+"注册"; 
		         		//System.out.println(logContentHead);
		         		sysLogInfo.setLogTypeId(BigInteger.valueOf(77));
			    		sysLogInfo.setFunctionId(BigInteger.valueOf(77));
		                sysLogInfo.setContent(logContentHead);
			    	    sysLogInfo.setStaffId(BigInteger.valueOf(Integer.parseInt(staff.getStaffId())));
			    	    sysLogInfo.setCreateTime(new Date());
			    		sysLogInfo.setUpdateTime(new Date());
			    		sysLogInfo.setDeleteState((byte)0);
			    		sysLogInfo.setNotes(logNotes);
			    		sysLogDao.saveSystemLog(sysLogInfo);
	         		}
         		}
	    	}
	    }
	    
	    if(action instanceof SystemMgmtAction){
	    	sysLogInfo.setLogTypeId(BigInteger.valueOf(76));
    		sysLogInfo.setFunctionId(BigInteger.valueOf(76));
    	    sysLogInfo.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
    	    sysLogInfo.setCreateTime(new Date());
    		sysLogInfo.setUpdateTime(new Date());
    		sysLogInfo.setDeleteState((byte)0);
    		sysLogInfo.setNotes(logNotes);
	    	/**y
    		 * 添加用户
    		 */
	    	if(method.equals("addUser")){
	    		String orgNameTmp=request.getParameter("orgNameTmp");
	    		String staffcode=request.getParameter("staff.code");
	    		String staffemail=request.getParameter("staff.email");
	    		String staffname=request.getParameter("staff.name");
	    		String staffnotes=request.getParameter("staff.notes");
	    		String stafforgId=request.getParameter("staff.orgId");
	    		String staffpassword=request.getParameter("staff.password");
	    		String staffstaffTypeId=request.getParameter("staff.staffTypeId");
	    		String staffvalidDate=request.getParameter("staff.validDate");
	    		logContentHead ="添加账号记录。账号："+curStaff.getCode()+ "增加新用户。登录名："+staffcode+"；密码:"+staffpassword+";在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	/**y
    		 * 删除用户
    		 */
	    	if(method.equals("removeUser")){
	    		logContentHead ="删除账号记录。账号："+curStaff.getCode()+ ";删除用户为："+staffremove.getCode()+"，在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	/**y
    		 * 保存别人的信息
    		 */
	    	if(method.equals("saveUser")){
	    		String orgNameTmp=request.getParameter("orgNameTmp");
	    		String staffcode=request.getParameter("staff.code");
	    		String staffcreateTime=request.getParameter("staff.createTime");
	    		String staffemail=request.getParameter("staff.email");
	    		String staffname=request.getParameter("staff.name");
	    		String staffnotes=request.getParameter("staff.notes");
	    		String stafforgId= request.getParameter("staff.orgId");
	    		String staffstaffId= request.getParameter("staff.staffId");
         		String staffpassword = request.getParameter("staff.password");
         		String staffstaffTypeId= request.getParameter("staff.staffTypeId");
         		logContentHead ="修改别人信息记录。账号："+curStaff.getCode()+ ";修改账号："+staffcode+"的信息，用户名修改为："+staffname
	    				+",邮箱修改："+staffemail+",机构编号修改："+stafforgId+"在"+Nowdatetime.getdate()+"时间。";
         		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	
	    		/**y
	    		 * 修改个人的信息
	    		 */
	    		if(method.equals("saveSelf")){
	         		String orgNameTmp= request.getParameter("orgNameTmp");
	         		String staffemail = request.getParameter("staff.email");
	         		String staffname= request.getParameter("staff.name");
	         		String stafforgId= request.getParameter("staff.orgId");
	         		String staffstaffId = request.getParameter("staff.staffId");
	         		PubOrg pubOrg=pubOrgDao.find(stafforgId);
	         		//System.out.println(orgNameTmp+"     "+staffemail+"   "+staffname+"      "+stafforgId+"   "+staffstaffId);
		    		logContentHead ="修改自己信息记录。账号："+curStaff.getCode()+ ";修改自己的信息，将用户名：由"+curStaff.getName()+"修改为"+staffname
		    				       +",邮箱修改为："+staffemail+",机构修改为："+pubOrg.getOrgName()+",在"+Nowdatetime.getdate()+"时间。";
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
	    		/**y
	    		 * 修改密码
	    		 */
		    	if(method.equals("savePass")){
		    		String staffpassword=request.getParameter("staff.password");
		    		String staffstaffId=request.getParameter("staff.staffId");
		    		logContentHead ="修改密码记录。账号："+curStaff.getCode()+ "的用户，修改密码，在"+Nowdatetime.getdate()+"时间";
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 给账号移出绑定的硬件
		    	 */
		    	if(method.equals("removeHw")){
		    		logContentHead ="移除绑定硬件记录。账号："+curStaff.getCode()+ ";用户名为："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 保存硬件
		    	 */
		    	if(method.equals("saveHw")){
		    		logContentHead ="保存硬件记录。账号："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 添加硬件
		    	 */
		    	if(method.equals("addHw")){
		    		logContentHead ="添加硬件记录。账号："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 删除权限
		    	 */
		    	if(method.equals("removePurview")){
		    		logContentHead ="删除权限记录。账号："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 保存权限
		    	 */
		    	if(method.equals("savePurview")){
		    		logContentHead ="保存权限记录。账号："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	
		    	/**
		    	 * 添加权限
		    	 */
		    	if(method.equals("addPurview")){
		    		logContentHead ="添加权限记录。账号："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 添加菜单权限
		    	 */
		    	if(method.equals("addStaffPur")){
		    		logContentHead ="添加菜单权限记录。账号："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	
		    	/**y
		    	 * 保存菜单权限
		    	 */
		    	if(method.equals("saveStaffPur")){
		    		String purIdArr= request.getParameter("purIdArr");
	         		String staffIdArr = request.getParameter("staffIdArr");
	         		SysStaff staffphn=sysStaffDao.find(staffIdArr.toString());
	         		String [] purlist=purIdArr.split(",");
	         		String  caidanming="";
	         		for (int i = 0; i < purlist.length; i++) {
                        SysPurview sysPurview=sysPurviewDao.find(purlist[i]);
	         			caidanming+=sysPurview.getName()+",";
					}
		    		logContentHead ="保存菜单权限记录。账号："+curStaff.getCode()+ ";为用户："+staffphn.getCode()+"修改菜单为："+caidanming+"。在"+Nowdatetime.getdate()+"时间。";
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	/**
		    	 * 移除菜单权限
		    	 */
		    	if(method.equals("removeStaffPur")){
		    		logContentHead ="移除菜单权限记录。账号为："+curStaff.getCode()+ ";用户名："+curStaff.getName()+"修改密码，在"+Nowdatetime.getdate();
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	
		    	/**y
		    	 * 保存硬件数量权限
		    	 */
		    	if(method.equals("saveHwNum")){
		    		String hwNumhwId=request.getParameter("hwNum.hwId");
		    		String hwNumnum=request.getParameter("hwNum.num");
		    		String hwtype="";
		    		PubHwNum pubHwNum=hwNumDao.find(hwNumhwId);
		    		SysStaff staffphn=sysStaffDao.find(pubHwNum.getStaffId().toString());
		    		if(pubHwNum.getHwType()==BigInteger.valueOf(70)){
		    			hwtype="硬盘";
		    		}
		    		if(pubHwNum.getHwType()==BigInteger.valueOf(71)){
		    			hwtype="网盘";
		    		}
		    		if(pubHwNum.getHwType()==BigInteger.valueOf(72)){
		    			hwtype="cpu";
		    		}
		    		logContentHead ="保存硬件数量记录。账号："+curStaff.getCode()+ ";为："+staffphn.getCode()+",添加"+hwtype+"硬件数量为："+hwNumnum+",在"+Nowdatetime.getdate()+"时间。";
		    		//System.out.println(logContentHead);
		    		sysLogInfo.setContent(logContentHead);
		    		sysLogDao.saveSystemLog(sysLogInfo);
	    	     }
		    	
	    }
	    if(action instanceof AgencyMgmtAction){
	    	/**
	    	 * 添加机构
	    	 */
	    	if(method.equals("addAgency")){
	    		String hwNumhwId=request.getParameter("hwNum.hwId");
	    		logContentHead ="添加机构记录。账号："+curStaff.getCode()+ "添加机构："+hwNumhwId+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	/**
	    	 * 修改机构
	    	 */
	    	if(method.equals("removeAgency")){
	    		String hwNumhwId=request.getParameter("hwNum.hwId");
	    		logContentHead ="修改机构记录。账号："+curStaff.getCode()+ "修改机构："+hwNumhwId+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	/**
	    	 * 删除机构
	    	 */
	    	if(method.equals("updateAgency")){
	    		String hwNumhwId=request.getParameter("hwNum.hwId");
	    		String hwNumnum=request.getParameter("hwNum.num");
	    		logContentHead ="删除机构记录。账号："+curStaff.getCode()+ "删除机构："+hwNumhwId+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    }

	}catch (Exception e) {
		e.printStackTrace();
	}

	return result;
		
	} 

	

} 