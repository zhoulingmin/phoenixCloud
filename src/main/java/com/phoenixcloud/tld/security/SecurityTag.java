package com.phoenixcloud.tld.security;

import java.math.BigInteger;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.Tag;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.phoenixcloud.bean.SysPurview;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.bean.SysStaffPurview;
import com.phoenixcloud.dao.ctrl.SysPurviewDao;
import com.phoenixcloud.dao.ctrl.SysStaffPurviewDao;

public class SecurityTag implements Tag{

	private PageContext pageContext;
	private Tag parentTag;
	private String purviewCode;
	private boolean reverse = false;
	
	@Override
	public void setPageContext(PageContext pc) {
		// TODO Auto-generated method stub
		this.pageContext = pc;
	}

	@Override
	public void setParent(Tag t) {
		// TODO Auto-generated method stub
		this.parentTag = t;
	}

	@Override
	public Tag getParent() {
		// TODO Auto-generated method stub
		return this.parentTag;
	}

	@Override
	public int doStartTag() throws JspException {
        int ret = SKIP_BODY;        
        do {
        	SysStaff curStaff = (SysStaff)pageContext.getSession().getAttribute("user");
        	if (curStaff == null) {
        		break;
        	}
        	
        	SysPurviewDao purDao = (SysPurviewDao)getAppContext().getBean(SysPurviewDao.class);
        	SysPurview purview = purDao.findByCode(purviewCode);
        	if (purview == null) {
        		break;
        	}
       
    		SysStaffPurviewDao staffPurDao = (SysStaffPurviewDao)getAppContext().getBean(SysStaffPurviewDao.class);
        	SysStaffPurview staffPur = staffPurDao.findByStaffAndPurviewId(new BigInteger(curStaff.getId())
        		, new BigInteger(purview.getPurviewId()), false);
        	if (staffPur == null) {
        		break;
        	}
            
        	ret = EVAL_BODY_INCLUDE;
        	
        } while(false);
        
        
        if (reverse) {           
            if (ret == EVAL_BODY_INCLUDE) {
                ret = SKIP_BODY;
            } else {
                ret = EVAL_BODY_INCLUDE;
            }
        }
        return ret;
	}

	@Override
	public int doEndTag() throws JspException {
		// TODO Auto-generated method stub
		return EVAL_PAGE;
	}

	@Override
	public void release() {
		// TODO Auto-generated method stub
		
	}

	public String getPurviewCode() {
		return purviewCode;
	}

	public void setPurviewCode(String purviewCode) {
		this.purviewCode = purviewCode;
	}

	public boolean isReverse() {
		return reverse;
	}

	public void setReverse(boolean reverse) {
		this.reverse = reverse;
	}
	
	public ApplicationContext getAppContext() {
		return WebApplicationContextUtils.getWebApplicationContext(pageContext.getServletContext());
	}
}
