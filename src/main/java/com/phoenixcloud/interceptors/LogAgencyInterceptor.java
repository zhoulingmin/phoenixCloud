package com.phoenixcloud.interceptors;

import java.math.BigInteger;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.MethodFilterInterceptor;
import com.phoenixcloud.agency.action.AgencyMgmtAction;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.bean.SysLog;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.dao.ctrl.PubOrgCataDao;
import com.phoenixcloud.dao.ctrl.SysLogDao;
import com.phoenixcloud.listener.Nowdatetime;


@SuppressWarnings("serial") 
public class LogAgencyInterceptor extends MethodFilterInterceptor{ 
	
    
    @Autowired
	private  SysLogDao sysLogDao;
    @Autowired
   	private  PubOrgCataDao pubOrgCataDao;
    
	public PubOrgCataDao getPubOrgCataDao() {
		return pubOrgCataDao;
	}

	public void setPubOrgCataDao(PubOrgCataDao pubOrgCataDao) {
		this.pubOrgCataDao = pubOrgCataDao;
	}

	public SysLogDao getSysLogDao() {
		return sysLogDao;
	}

	public void setSysLogDao(SysLogDao sysLogDao) {
		this.sysLogDao = sysLogDao;
	}


	@Override
	protected String doIntercept(ActionInvocation invocation) throws Exception {
		SysLog sysLogInfo=new SysLog();
		
		
		
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
	    HttpServletRequest request = ServletActionContext.getRequest(); 
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
	    if(action instanceof AgencyMgmtAction){
	    	sysLogInfo.setLogTypeId(BigInteger.valueOf(75));
    		sysLogInfo.setFunctionId(BigInteger.valueOf(75));
    	    sysLogInfo.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
    	    sysLogInfo.setCreateTime(new Date());
    		sysLogInfo.setUpdateTime(new Date());
    		sysLogInfo.setDeleteState((byte)0);
    		sysLogInfo.setNotes(logNotes);
	    	/**
	    	 * 添加机构
	    	 */
	    	if(method.equals("addAgency")){
	    		String agencyName=request.getParameter("agencyName");
	    		String cataId=request.getParameter("cataId");
	    		String notes=request.getParameter("notes");
	    		String number=request.getParameter("number");
	    		String type=request.getParameter("type");
	    		if(type.equals("org")){
	    			logContentHead ="添加机构记录。账号："+curStaff.getCode()+ "；添加机构："+agencyName+",在"+Nowdatetime.getdate()+"时间。";
	    		}else{
	    			logContentHead ="添加机构目录记录。账号："+curStaff.getCode()+ "；添加机构目录："+agencyName+",在"+Nowdatetime.getdate()+"时间。";
	    		}
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	/**
	    	 * 删除机构
	    	 */
	    	if(method.equals("removeAgency")){
	    		String  checkedNodes=request.getParameter("checkedNodes");
	    		JSONArray jsonNodes = JSONArray.fromObject(checkedNodes);
	    		for (int i = 0; i < jsonNodes.size(); i++) {
	    			JSONObject nodeObj = (JSONObject) jsonNodes.get(i);
	    			String id = (String) nodeObj.get("id");
	    			PubOrgCata pubOrgCata=pubOrgCataDao.find(id);
	    			
	    			if ("cata".equals((String)nodeObj.get("type"))) {
	    				logContentHead ="删除机构目录记录。账号："+curStaff.getCode()+ "；删除机构目录编号："+pubOrgCata.getCataName()+",在"+Nowdatetime.getdate()+"时间。";
	    			} else {
	    				logContentHead ="删除机构记录。账号："+curStaff.getCode()+ "；删除机构编号："+id+",在"+pubOrgCata.getCataName()+"时间。";
	    			}
	    		}
	    		//System.out.println(logContentHead);
	    		sysLogInfo.setContent(logContentHead);
	    		sysLogDao.saveSystemLog(sysLogInfo);
    	     }
	    	/**
	    	 * 修改机构
	    	 */
	    	if(method.equals("updateAgency")){
	    		String agencyName=request.getParameter("agencyName");
	    		String cataId=request.getParameter("cataId");
	    		String createTime=request.getParameter("agencyName");
	    		String notes=request.getParameter("notes");
	    		String orgTypeId=request.getParameter("orgTypeId");
	    		String type=request.getParameter("type");
	    		
	    		String checkedNodes=request.getParameter("checkedNodes");
	    		logContentHead ="修改机构记录。账号："+curStaff.getCode()+ "；修改机构名为："+agencyName+",在"+Nowdatetime.getdate()+"时间。";
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
