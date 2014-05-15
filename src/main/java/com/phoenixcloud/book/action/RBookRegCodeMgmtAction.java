package com.phoenixcloud.book.action;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonBeanProcessor;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RRegCode;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.bean.SysStaffRegCode;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.dao.ctrl.SysStaffDao;
import com.phoenixcloud.dao.ctrl.SysStaffRegCodeDao;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.dao.res.RRegCodeDao;
import com.phoenixcloud.util.MiscUtils;
import com.phoenixcloud.util.SpringUtils;

@Component("bookRegCodeMgmtAction")
public class RBookRegCodeMgmtAction extends ActionSupport implements RequestAware, ServletResponseAware {
	
	private static final long serialVersionUID = 19227428971335852L;
	
	private RequestMap request;
	private HttpServletResponse response;

	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	private RRegCode regCode;
	private String regCodeIdArr;
	private int num;
	private String bookIdArr;
	
	@Autowired
	private RBookDao bookDao;
	
	@Autowired
	private RRegCodeDao regCodeDao;
	
	@Autowired
	private SysStaffRegCodeDao staffRegCodeDao;
	
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}


	@Override
	public void setRequest(Map<String, Object> request) {
		// TODO Auto-generated method stub
		this.request = (RequestMap) request;
	}


	public RRegCode getRegCode() {
		return regCode;
	}


	public void setRegCode(RRegCode regCode) {
		this.regCode = regCode;
	}


	public String getRegCodeIdArr() {
		return regCodeIdArr;
	}


	public void setRegCodeIdArr(String regCodeIdArr) {
		this.regCodeIdArr = regCodeIdArr;
	}

	public String getAll() {
		List<RRegCode> codeList = iBookService.getAllRegCodes();
		request.put("codeList", codeList);
		return "success";
	}
	
	public int getNum() {
		return num;
	}


	public void setNum(int num) {
		this.num = num;
	}


	public String getBookIdArr() {
		return bookIdArr;
	}


	public void setBookIdArr(String bookIdArr) {
		this.bookIdArr = bookIdArr;
	}


	public String edit() {
		regCode = iBookService.findRegCode(regCode.getId());
		return "success";
	}
	
	public String remove() {
		String[] regCodeId = regCodeIdArr.split(",");
		for (String id : regCodeId) {
			iBookService.removeRegCode(id);
		}
		return null;
	}
	
	public String save() {
		regCode.setUpdateTime(new Date());
		iBookService.saveRegCode(regCode);
		return null;
	}
	
	public String add() {
		Date curDate = new Date();
		regCode.setUpdateTime(curDate);
		regCode.setCreateTime(curDate);
		regCode.setIsValid((byte)1);
		iBookService.saveRegCode(regCode);
		return null;
	}
	
	
	
	public String batchGenRegCode() {
		if (num < 0) {
			return null;
		}
		JSONArray jsonArr = new JSONArray();
		String[] ids = bookIdArr.split(",");
		Date date = new Date();
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(date);
		cal.add(1, 1); // 加1年
		/*gc.add(1,-1)表示年份减一.
		*gc.add(2,-1)表示月份减一.
		*gc.add(3.-1)表示周减一.
		*gc.add(5,-1)表示天减一.
		*第二参数如果为正数，表示加
		**/
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		for (String id: ids) {
			RBook book = bookDao.find(id);
			if (book == null) {
				continue;
			}
			
			for (int i = 0; i < num; i++) {
				//bookNo + time stamp + random number
				RRegCode regCode = new RRegCode();
				regCode.setBookId(new BigInteger(id));
				regCode.setCreateTime(date);
				regCode.setUpdateTime(date);
				regCode.setValidDate(cal.getTime());
				
				String code = book.getBookNo() + new Date().getTime() + MiscUtils.getRandomString(8);
				//String code = book.getBookNo() + MiscUtils.getRandomString(8);
				regCode.setCode(code);
				regCode.setStaffId(BigInteger.ZERO);
				
				regCodeDao.persist(regCode);
				
				JSONObject obj = new JSONObject();
				obj.put("regCodeId", regCode.getRegCodeId());
				obj.put("code", code);
				obj.put("bookName", book.getName());
				obj.put("validDate", sdf.format(cal.getTime()));
				obj.put("staffName", "未使用");
				
				jsonArr.add(obj);
			}
		}
		
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		try {
			PrintWriter out = response.getWriter();
			out.print(jsonArr.toString());
			out.flush();
			out.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
		
		return null;
	}
	
	public String batchDelRegcode() {
		
		String[] ids = regCodeIdArr.split(",");
		Date date = new Date();
		JSONArray jsonArr = new JSONArray();
		for (String id : ids) {
			RRegCode regCode = regCodeDao.find(id);
			if (regCode == null || (regCode.getStaffId() != null && regCode.getStaffId().compareTo(BigInteger.ZERO) == 1)) {
				continue;
			}
			regCode.setDeleteState((byte)1);
			regCode.setUpdateTime(date);
			regCodeDao.merge(regCode);
			jsonArr.add(id);
		}
		
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		try {
			PrintWriter out = response.getWriter();
			out.print(jsonArr.toString());
			out.flush();
			out.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
		
		return null;
	}
	
	public String queryRegcode() {
		String[] ids = bookIdArr.split(",");
		JSONArray jsonArr = new JSONArray();
		JsonConfig jsonCnf = new JsonConfig();
		jsonCnf.registerJsonBeanProcessor(RRegCode.class, new JsonBeanProcessor(){

			@Override
			public JSONObject processBean(Object bean, JsonConfig jsonConfig) {
				// TODO Auto-generated method stub
				if (!(bean instanceof RRegCode)) {
					return new JSONObject(true);
				}
				RRegCode regCode = (RRegCode)bean;
				RBookDao bookDao = (RBookDao)SpringUtils.getBean("RBookDao");
				RBook book = bookDao.find(regCode.getBookId().toString());
				if (book == null) {
					return new JSONObject(true);
				}
				JSONObject obj = new JSONObject();
				obj.put("regCodeId", regCode.getRegCodeId());
				obj.put("code", regCode.getCode());
				obj.put("bookName", book.getName());
				obj.put("validDate", new SimpleDateFormat("yyyy/MM/dd").format(regCode.getValidDate()));
				
				SysStaff staff = null;
				SysStaffRegCode staffReg = staffRegCodeDao.fingByBookIdAndCodeId(new BigInteger(book.getId()), new BigInteger(regCode.getId()));
				if (staffReg != null) {
					SysStaffDao staffDao = (SysStaffDao)SpringUtils.getBean(SysStaffDao.class);
					if (staffReg.getStaffId() != null && staffReg.getStaffId().compareTo(BigInteger.ZERO) == 1) {
						staff = staffDao.find(regCode.getStaffId().toString());
					}
				}
				
				if (staff != null) {
					obj.put("staffName", staff.getName());
				} else {
					obj.put("staffName", "未使用");
				}
				
				return obj;
			}
			
		});
		for (String id : ids) {
			List<RRegCode> codeList = regCodeDao.findByBookId(new BigInteger(id));
			jsonArr.addAll(codeList, jsonCnf);
		}
		
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		try {
			PrintWriter out = response.getWriter();
			out.print(jsonArr.toString());
			out.flush();
			out.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
		
		
		return null;
	}


	@Override
	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response;
	}
}
