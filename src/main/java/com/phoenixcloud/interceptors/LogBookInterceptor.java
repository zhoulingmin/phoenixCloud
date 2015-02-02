package com.phoenixcloud.interceptors;

import java.math.BigInteger;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest; 

import org.apache.struts2.ServletActionContext; 
import org.springframework.beans.factory.annotation.Autowired;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation; 
import com.opensymphony.xwork2.interceptor.MethodFilterInterceptor;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;
import com.phoenixcloud.bean.RBookLog;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.RRegCode;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.action.RBookDireMgmtAction;
import com.phoenixcloud.book.action.RBookMgmtAction;
import com.phoenixcloud.book.action.RBookRegCodeMgmtAction;
import com.phoenixcloud.book.action.RBookResMgmtAction;
import com.phoenixcloud.book.action.RBookResUploadAction;
import com.phoenixcloud.book.action.RBookUploadAction;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.dao.res.RBookDireDao;
import com.phoenixcloud.dao.res.RBookLogDao;
import com.phoenixcloud.dao.res.RBookPageResDao;
import com.phoenixcloud.dao.res.RBookReDao;
import com.phoenixcloud.dao.res.RRegCodeDao;
import com.phoenixcloud.listener.Nowdatetime;

@SuppressWarnings("serial") 

public class LogBookInterceptor extends MethodFilterInterceptor{

    @Autowired
	private  RBookLogDao bookLogDao;
    @Autowired
   	private  RBookDao rBookDao;
    @Autowired
   	private RBookDireDao bookDireDao;
    @Autowired
   	private RBookPageResDao rBookPageResDao;
    @Autowired
   	private RBookReDao rBookReDao;
    @Autowired
   	private RRegCodeDao rRegCodeDao;
    
    
	public RRegCodeDao getrRegCodeDao() {
		return rRegCodeDao;
	}
	public void setrRegCodeDao(RRegCodeDao rRegCodeDao) {
		this.rRegCodeDao = rRegCodeDao;
	}
	public RBookPageResDao getrBookPageResDao() {
		return rBookPageResDao;
	}
	public void setrBookPageResDao(RBookPageResDao rBookPageResDao) {
		this.rBookPageResDao = rBookPageResDao;
	}
	public RBookReDao getrBookReDao() {
		return rBookReDao;
	}
	public void setrBookReDao(RBookReDao rBookReDao) {
		this.rBookReDao = rBookReDao;
	}
	public RBookDireDao getBookDireDao() {
		return bookDireDao;
	}
	public void setBookDireDao(RBookDireDao bookDireDao) {
		this.bookDireDao = bookDireDao;
	}
	public RBookDao getrBookDao() {
		return rBookDao;
	}
	public void setrBookDao(RBookDao rBookDao) {
		this.rBookDao = rBookDao;
	}
	public RBookLogDao getBookLogDao() {
		return bookLogDao;
	}
	public void setBookLogDao(RBookLogDao bookLogDao) {
		this.bookLogDao = bookLogDao;
	}
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	
	public IRBookMgmtService getiBookService() {
		return iBookService;
	}
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}
	@Override
	protected String doIntercept(ActionInvocation invocation) throws Exception {
		RBookLog  bookLog =new RBookLog();    
		//请求HttpServletRequest
	    HttpServletRequest request = ServletActionContext.getRequest(); 
	    
		String selbookId=request.getParameter("bookIdArr");
	    RBook rBook= rBookDao.find(selbookId);
		
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
	   
	   /**
	    * 目录RBookDireMgmtAction
	    */
	    if(action instanceof RBookDireMgmtAction){
	    	
    	    bookLog.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
    	    bookLog.setCreateTime(new Date());
    		bookLog.setUpdateTime(new Date());
    		bookLog.setDeleteState((byte)0);
    		bookLog.setNotes(logNotes);
	    	/**
	    	 * 添加书籍目录
	    	 */
	    	if(method.equals("addDire")){
	    		String bookDirebookId=request.getParameter("bookDire.bookId");
	    		String bookDiredireType=request.getParameter("bookDire.direType");
	    		String bookDirelevel=request.getParameter("bookDire.level");
	    		String bookDirename=request.getParameter("bookDire.name");
	    		String bookDireparentDireId=request.getParameter("bookDire.parentDireId");
	    		String  bookDirestaffId=request.getParameter("bookDire.staffId");
	    		String num=request.getParameter("num");
	    		RBook Book= rBookDao.find(bookDirebookId);
	    		logContentHead ="添加书籍目录记录。账号："+curStaff.getCode()+ ";给书《"+Book.getName()+"》编号："+bookDirebookId+"；添加目录："+bookDirename+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookDirebookId)));
	    		bookLog.setLogTypeId(BigInteger.valueOf(82));
	    		bookLog.setFunctionId(BigInteger.valueOf(82));
	    		bookLog.setContent(logContentHead);
	    		bookLogDao.saveBookLog(bookLog);
    	     }
	    	/**
	    	 * 保存书籍目录
	    	 */
	    	if(method.equals("saveDire")){
	    		String bookDirebPageNum=request.getParameter("bookDire.bPageNum");
	    		String bookDiredireId=request.getParameter("bookDire.direId");
	    		String bookDireePageNum=request.getParameter("bookDire.ePageNum");
	    		String bookDirename=request.getParameter("bookDire.name");
	    		String bookDirenotes=request.getParameter("bookDire.notes");
	    		String  bookDireseqNo=request.getParameter("bookDire.pageOffset");
	    		RBookDire rBookDire= bookDireDao.find(bookDiredireId);
	    		RBook book=rBookDao.find(rBookDire.getBookId().toString());
	    		logContentHead ="保存书籍目录记录。账号："+curStaff.getCode()+ ";给书《"+book.getName()+"》保存目录："+rBookDire.getName()+"目录编号："+bookDiredireId+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookDiredireId)));
	    		bookLog.setLogTypeId(BigInteger.valueOf(82));
	    		bookLog.setFunctionId(BigInteger.valueOf(82));
	    		bookLog.setContent(logContentHead);
	    		bookLogDao.saveBookLog(bookLog);
    	     }
	    	/**
	    	 * 移除书籍目录
	    	 */
	    	if(method.equals("removeDire")){
	    		String bookId=request.getParameter("bookId");
	    		String direId=request.getParameter("direId");
	    		logContentHead ="删除书籍目录记录。账号："+curStaff.getCode()+ "删除书："+bookId+"的"+direId+"目录,在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookId)));
	    		bookLog.setLogTypeId(BigInteger.valueOf(82));
	    		bookLog.setFunctionId(BigInteger.valueOf(82));
	    		bookLog.setContent(logContentHead);
	    		bookLogDao.saveBookLog(bookLog);
    	     }
	    }
	 
		 /**
	    	 * 对书的操作
	    	 */
	    if(action instanceof RBookMgmtAction){
    	    bookLog.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
    	    bookLog.setCreateTime(new Date());
    		bookLog.setUpdateTime(new Date());
    		bookLog.setDeleteState((byte)0);
    		bookLog.setNotes(logNotes);
	    	/**y
	    	 * 添加书
	    	 */
	    	if(method.equals("addBook")){
	    		String bookInfobookNo=(String) invocation.getStack().findValue("bookInfo.bookNo"); 
	    		RBook book=iBookService.findBookNo(bookInfobookNo);
	    		String bookInfoallAddrInNet=request.getParameter("bookInfo.allAddrInNet");
	    		String bookInfoallAddrOutNet=request.getParameter("bookInfo.allAddrOutNet");
	    		String bookInfoclassId=request.getParameter("bookInfo.classId");
	    		String bookInfoipAddr=request.getParameter("bookInfo.ipAddr");
	    		String bookInfokindId=request.getParameter("bookInfo.kindId");
	    		String bookInfoname=request.getParameter("bookInfo.name");
	    		String bookInfonotes=request.getParameter("bookInfo.notes");
	    		String bookInfoorgId=request.getParameter("bookInfo.orgId");
	    		String bookInfopageNum=request.getParameter("bookInfo.pageNum");
	    		String bookInfopressId=request.getParameter("bookInfo.pressId");
	    		String bookInfostuSegId=request.getParameter("bookInfo.stuSegId");
	    		String bookInfosubjectId=request.getParameter("bookInfo.subjectId");
	    		String kindSeqNo=request.getParameter("kindSeqNo");
	    		String orgNameTmp=request.getParameter("orgNameTmp");
	    		String quarter=request.getParameter("quarter");
	    		String yearOfRls=request.getParameter("yearOfRls");
	    		
	    		logContentHead ="添加书记录。账号："+curStaff.getCode()+ "；添加书籍编号为："+book.getBookId()+"，书名：《"+bookInfoname+"》,在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(book.getBookId())));
	    		bookLog.setLogTypeId(BigInteger.valueOf(78));
	    		bookLog.setFunctionId(BigInteger.valueOf(78));
	    		bookLog.setContent(logContentHead);
	    		bookLogDao.saveBookLog(bookLog);
    	     }
	    	/**y
	    	 * 移除书
	    	 */
	    	if(method.equals("removeBook")){
	    		String bookIdArr=request.getParameter("bookIdArr");
	    		
	    		logContentHead ="删除书记录。账号："+curStaff.getCode()+ ";删除书《"+rBook.getName()+"》编号为："+bookIdArr+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
	    		bookLog.setLogTypeId(BigInteger.valueOf(80));
	    		bookLog.setFunctionId(BigInteger.valueOf(80));
	    		bookLog.setContent(logContentHead);
	    		bookLogDao.saveBookLog(bookLog);
    	     }
    	     /**y
 	    	 * 修改书
 	    	 */
 	    	if(method.equals("editBook")){
 	    		String bookInfobookId=(String) invocation.getStack().findValue("bookInfo.bookId"); 
 	    		RBook Book= rBookDao.find(bookInfobookId);
 	    		logContentHead ="修改书记录。账号："+curStaff.getCode()+ ";修改书《"+Book.getName()+"》编号为："+bookInfobookId+",在"+Nowdatetime.getdate()+"时间。";
 	    		//System.out.println(logContentHead);
 	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookInfobookId)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(79));
 	    		bookLog.setFunctionId(BigInteger.valueOf(79));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
     	     }
    	     /**y
 	    	 * changeAuditStatus
 	    	 */
 	    	if(method.equals("changeAuditStatus")){
 	    		String bookIdArr=request.getParameter("bookIdArr");
 	    		RBook book=rBookDao.find(bookIdArr);
 	    		String flag=request.getParameter("flag");
 	    		if(flag.equals("0")){
 	    			logContentHead ="书籍提交审核记录。账号："+curStaff.getCode()+ ";提交书《"+book.getName()+"》编号："+bookIdArr+"审核,审核状态：以提交,正在审核,在"+Nowdatetime.getdate()+"时间。";
 	    		}
 	    		if(flag.equals("1")){
 	    			logContentHead ="书籍提交审核记录。账号："+curStaff.getCode()+ ";提交书《"+book.getName()+"》编号："+bookIdArr+"审核,审核状态：审核成功,正在发布,在"+Nowdatetime.getdate()+"时间。";
 	    		}if(flag.equals("2")){
 	    			logContentHead ="书籍提交审核记录。账号："+curStaff.getCode()+ ";提交书《"+book.getName()+"》编号："+bookIdArr+"审核,状态：上架,在"+Nowdatetime.getdate()+"时间。";
 	    		}if(flag.equals("3")){
 	    			logContentHead ="书籍提交审核记录。账号："+curStaff.getCode()+ ";提交书《"+book.getName()+"》编号："+bookIdArr+"审核,状态：下架,在"+Nowdatetime.getdate()+"时间。";
 	    		}
 	    		if((flag.equals("-1"))){
 	    			logContentHead ="书籍提交审核记录。账号："+curStaff.getCode()+ ";提交书《"+book.getName()+"》编号："+bookIdArr+"审核,审核状态：审核失败,打回制作,"+Nowdatetime.getdate()+"时间。";
 	    		}
 	    		
 	    		//System.out.println(logContentHead);
 	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(81));
 	    		bookLog.setFunctionId(BigInteger.valueOf(81));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
     	     }
 	    	/**
 	    	 * checkBookNo
 	    	 */
	    	if(method.equals("checkBookNo")){
	    		String bookIdArr=request.getParameter("bookIdArr");
	    		logContentHead ="删除书籍目录记录。账号："+curStaff.getCode()+ "修改机构："+bookIdArr+",在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(81));
 	    		bookLog.setFunctionId(BigInteger.valueOf(81));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
    	     }
 	    	 /**
 	    	 * streamDownload
 	    	 */
 	    	if(method.equals("streamDownload")){
 	    		String bookIdArr=request.getParameter("bookIdArr");
 	    		logContentHead ="删除书籍目录记录。账号："+curStaff.getCode()+ "修改机构："+bookIdArr+",在"+Nowdatetime.getdate()+"时间。";
 	    		//System.out.println(logContentHead);
 	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(81));
 	    		bookLog.setFunctionId(BigInteger.valueOf(81));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
     	     }
 	    	 /**
 	    	 * download
 	    	 */
 	    	if(method.equals("download")){
 	    		String bookIdArr=request.getParameter("bookIdArr");
 	    		logContentHead ="删除书籍目录记录。账号："+curStaff.getCode()+ "修改机构："+bookIdArr+",在"+Nowdatetime.getdate()+"时间。";
 	    		//System.out.println(logContentHead);
 	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(81));
 	    		bookLog.setFunctionId(BigInteger.valueOf(81));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
     	     }
 	    	 /**
 	    	 * outputToInput
 	    	 */
 	    	if(method.equals("outputToInput")){
 	    		String bookIdArr=request.getParameter("bookIdArr");
 	    		logContentHead ="删除书籍目录记录。账号："+curStaff.getCode()+ "修改机构："+bookIdArr+",在"+Nowdatetime.getdate()+"时间。";
 	    		//System.out.println(logContentHead);
 	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(81));
 	    		bookLog.setFunctionId(BigInteger.valueOf(81));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
     	     }
 	    	/**
 	    	 * showCover
 	    	 */
 	    	if(method.equals("showCover")){
 	    		String bookIdArr=request.getParameter("bookIdArr");
 	    		logContentHead ="删除书籍目录记录。账号："+curStaff.getCode()+ "修改机构："+bookIdArr+",在"+Nowdatetime.getdate()+"时间。";
 	    		//System.out.println(logContentHead);
 	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 	    		bookLog.setLogTypeId(BigInteger.valueOf(81));
 	    		bookLog.setFunctionId(BigInteger.valueOf(81));
 	    		bookLog.setContent(logContentHead);
 	    		bookLogDao.saveBookLog(bookLog);
     	     }
	    }
      /**
	     * 上传附件
	     */
	    if(action instanceof RBookUploadAction){
	    	
    	    bookLog.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
    	    bookLog.setCreateTime(new Date());
    		bookLog.setUpdateTime(new Date());
    		bookLog.setDeleteState((byte)0);
    		bookLog.setNotes(logNotes);
    		/**
	    	 * 上传书籍附件
	    	 */
	    	if(method.equals("uploadBook")){
	    		String bookFile=request.getParameter("bookFile");
	    		String bookFileContentType=(String) invocation.getStack().findValue("bookFileContentType");
	    		String bookFileFileName=(String) invocation.getStack().findValue("bookFileFileName");
	    		
	    		String bookId=request.getParameter("bookId");
	    		String isUpload=request.getParameter("isUpload");
	    		String submit=request.getParameter("submit");
	    		RBook Book= rBookDao.find(bookId);
	    		logContentHead ="上传书籍附件记录。账号："+curStaff.getCode()+ ";给书《"+Book.getName()+"》编号为："+bookId+",添加附件文件名："+bookFileFileName+";在"+Nowdatetime.getdate()+"时间。";
	    		//System.out.println(logContentHead);
	    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookId)));
	    		bookLog.setLogTypeId(BigInteger.valueOf(80));
	    		bookLog.setFunctionId(BigInteger.valueOf(80));
	    		bookLog.setContent(logContentHead);
	    		bookLogDao.saveBookLog(bookLog);
    	     }
	    	
	    }
	    
	   /**
 		  * 上传资源
 		  */
 		    if(action instanceof RBookResUploadAction){
 		    	
 	    	    bookLog.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
 	    	    bookLog.setCreateTime(new Date());
 	    		bookLog.setUpdateTime(new Date());
 	    		bookLog.setDeleteState((byte)0);
 	    		bookLog.setNotes(logNotes);
 	    		/**
 		    	 * 上传书籍资源
 		    	 */
 		    	if(method.equals("batchUploadBookRes")){
 		    		String bookResbookId=request.getParameter("bookRes.bookId");
 		    		String bookRescataAddr=request.getParameter("bookRes.cataAddr");
 		    		String bookResformat=request.getParameter("bookRes.format");
 		    		String bookResnotes=request.getParameter("bookRes.notes");
 		    		String bookResparentResId=request.getParameter("bookRes.parentResId");
 		    		String resFile=request.getParameter("resFile");
 		    		String resFileContentType=request.getParameter("resFileContentType");
 		    		String resFileFileName=(String) invocation.getStack().findValue("resFileFileName");
 		    		RBook book=rBookDao.find(bookResbookId);
 		    		logContentHead ="上传书籍资源件记录。账号："+curStaff.getCode()+ "；给书《"+book.getName()+"》编号为："+bookResbookId+"；添加资源："+resFileFileName+",在"+Nowdatetime.getdate()+"时间。";
 		    		//System.out.println(logContentHead);
 		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookResbookId)));
 		    		bookLog.setLogTypeId(BigInteger.valueOf(83));
 		    		bookLog.setFunctionId(BigInteger.valueOf(83));
 		    		bookLog.setContent(logContentHead);
 		    		bookLogDao.saveBookLog(bookLog);
 	    	     }
 		    	/**
 		    	 * 修改书籍资源
 		    	 */
 		    	if(method.equals("uploadRes")){
 		    		String bookResbookId=request.getParameter("bookRes.bookId");
 		    		String bookRescataAddr=request.getParameter("bookRes.cataAddr");
 		    		String bookResformat=request.getParameter("bookRes.format");
 		    		String bookResnotes=request.getParameter("bookRes.notes");
 		    		String bookResparentResId=request.getParameter("bookRes.parentResId");
 		    		String resFile=request.getParameter("resFile");
 		    		String resFileContentType=request.getParameter("resFileContentType");
 		    		String resFileFileName=(String) invocation.getStack().findValue("resFileFileName");
 		    		RBook book=rBookDao.find(bookResbookId);
 		    		logContentHead ="上传书籍资源件记录。账号："+curStaff.getCode()+ "给书《"+book.getName()+"》编号为："+bookResbookId+"；更新资源："+resFileFileName+",在"+Nowdatetime.getdate()+"时间。";
 		    		//System.out.println(logContentHead);
 		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookResbookId)));
 		    		bookLog.setLogTypeId(BigInteger.valueOf(83));
 		    		bookLog.setFunctionId(BigInteger.valueOf(83));
 		    		bookLog.setContent(logContentHead);
 		    		bookLogDao.saveBookLog(bookLog);
 	    	     }
 		    }
 		   /**
 		     * 生成注册码
 		     */
 		    if(action instanceof RBookRegCodeMgmtAction){
 		    	
 	    	    bookLog.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
 	    	    bookLog.setCreateTime(new Date());
 	    		bookLog.setUpdateTime(new Date());
 	    		bookLog.setDeleteState((byte)0);
 	    		bookLog.setNotes(logNotes);
 	    		/**
 		    	 * 生成注册码
 		    	 */
 		    	if(method.equals("batchGenRegCode")){
 		    		String bookIdArr=request.getParameter("bookIdArr");
 		    		RBook book=rBookDao.find(bookIdArr);
 		    		String num=request.getParameter("num");
 		    		logContentHead ="书籍注册码增加记录。账号："+curStaff.getCode()+ "给书《"+book.getName()+"》编号为："+bookIdArr+",添加注册码数量"+num+";在"+Nowdatetime.getdate()+"时间。";
 		    		//System.out.println(logContentHead);
 		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 		    		bookLog.setLogTypeId(BigInteger.valueOf(85));
 		    		bookLog.setFunctionId(BigInteger.valueOf(85));
 		    		bookLog.setContent(logContentHead);
 		    		bookLogDao.saveBookLog(bookLog);
 	    	     }
 		    	/**
 		    	 * 删除注册码
 		    	 */
 		    	if(method.equals("batchDelRegcode")){
 		    		String bookIdArr=(String) invocation.getStack().findValue("bookIdArr");
 		    		RBook book=rBookDao.find(bookIdArr);
 		    		String regCodeIdArr=request.getParameter("regCodeIdArr");
 		    		String [] bookcodelist=regCodeIdArr.split(",");
 		    		String code="";
 		    		for (int i = 0; i < bookcodelist.length; i++) {
 		    			RRegCode rRegCode=rRegCodeDao.find(bookcodelist[i]);
 		    			code+=rRegCode.getCode()+",";
					}
 		    		logContentHead ="书籍注册码删除记录。账号："+curStaff.getCode()+ "给书《"+book.getName()+"》编号为："+bookIdArr+",删除注册码"+regCodeIdArr+";在"+Nowdatetime.getdate()+"时间。";
 		    		//System.out.println(logContentHead);
 		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
 		    		bookLog.setLogTypeId(BigInteger.valueOf(85));
 		    		bookLog.setFunctionId(BigInteger.valueOf(85));
 		    		bookLog.setContent(logContentHead);
 		    		bookLogDao.saveBookLog(bookLog);
 	    	     }
 		    	
 		    }
 		   
 		  /**
		     * 资源操作
		     */
		    if(action instanceof RBookResMgmtAction){
		    	
	    	    bookLog.setStaffId(BigInteger.valueOf(Integer.parseInt(curStaff.getStaffId())));
	    	    bookLog.setCreateTime(new Date());
	    		bookLog.setUpdateTime(new Date());
	    		bookLog.setDeleteState((byte)0);
	    		bookLog.setNotes(logNotes);
	    		/**
		    	 * 添加资源
		    	 */
		    	if(method.equals("batchGenRegCode")){
		    		String bookIdArr=request.getParameter("bookIdArr");
		    		String num=request.getParameter("num");
		    		logContentHead ="书籍添加资源记录。账号："+curStaff.getCode()+ "给书编号为："+bookIdArr+",添加资源"+num+";在"+Nowdatetime.getdate()+"时间。";
		    		//System.out.println(logContentHead);
		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
		    		bookLog.setLogTypeId(BigInteger.valueOf(85));
		    		bookLog.setFunctionId(BigInteger.valueOf(85));
		    		bookLog.setContent(logContentHead);
		    		bookLogDao.saveBookLog(bookLog);
	    	     }
		    	/**
		    	 * 删除资源
		    	 */
		    	if(method.equals("batchDelRegcode")){
		    		String bookIdArr=(String) invocation.getStack().findValue("bookIdArr");
		    		String regCodeIdArr=request.getParameter("regCodeIdArr");
		    		logContentHead ="书籍资源删除记录。账号："+curStaff.getCode()+ "给书编号为："+bookIdArr+",删除资源"+regCodeIdArr+";在"+Nowdatetime.getdate()+"时间。";
		    		//System.out.println(logContentHead);
		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(bookIdArr)));
		    		bookLog.setLogTypeId(BigInteger.valueOf(85));
		    		bookLog.setFunctionId(BigInteger.valueOf(85));
		    		bookLog.setContent(logContentHead);
		    		bookLogDao.saveBookLog(bookLog);
	    	     }
	    	     /**
		    	 *removeRes 删除资源
		    	 */
		    	if(method.equals("removeRes")){
		    		
		    		String resIdArr=(String) invocation.getStack().findValue("regCodeIdArr");
		    		logContentHead ="书籍资源删除记录。账号："+curStaff.getCode()+ ",删除书籍资源为："+resIdArr+";在"+Nowdatetime.getdate()+"时间。";
		    		//System.out.println(logContentHead);
		    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(resIdArr)));
		    		bookLog.setLogTypeId(BigInteger.valueOf(85));
		    		bookLog.setFunctionId(BigInteger.valueOf(85));
		    		bookLog.setContent(logContentHead);
		    		bookLogDao.saveBookLog(bookLog);
		    	 }
	    	     /**
			    	 * 保存资源
			    	 */
			    	if(method.equals("saveRes")){
			    		String bookRescataAddr=(String) invocation.getStack().findValue("bookRes.cataAddr");
			    		String bookResformat=request.getParameter("bookRes.format");
			    		String bookResname=request.getParameter("bookRes.name");
			    		String bookResnotes=request.getParameter("bookRes.notes");
			    		String bookResparentResId=request.getParameter("bookRes.parentResId");
			    		String bookResresId=request.getParameter("bookRes.resId");
			    		String pages=request.getParameter("pages");
			    		String resFormat=request.getParameter("resFormat");
			    		RBookRe bookRe=rBookReDao.find(bookResresId);//跟具资源编号查找资源列表；
			    		RBook book=rBookDao.find(bookRe.getBookId().toString());//跟具书籍编号查找书列表；
			    		logContentHead ="书籍保存资源记录。账号："+curStaff.getCode()+ "；给书《"+book.getName()+"》添加"+resFormat+"资源："+bookResname+",添加到书的"+pages+"页;在"+Nowdatetime.getdate()+"时间。";
			    		//System.out.println(logContentHead);
			    		bookLog.setBookId(BigInteger.valueOf(Integer.parseInt(book.getBookId())));
			    		bookLog.setLogTypeId(BigInteger.valueOf(85));
			    		bookLog.setFunctionId(BigInteger.valueOf(85));
			    		bookLog.setContent(logContentHead);
			    		bookLogDao.saveBookLog(bookLog);
		    	     }
		    	     /**
				    	 * 审核资源
				    	 */
				    	if(method.equals("changeAuditStatus")){
				    		
				    		String flag=request.getParameter("flag");
				    		String resIdArr=request.getParameter("resIdArr");
				    		String [] reslist=resIdArr.split(",");
				    		String resNames="";
				    		for (int i = 0; i < reslist.length; i++) {
				    			RBookRe bookRe=rBookReDao.find(reslist[i]);//跟具资源编号查找资源列表
				    			RBook book=rBookDao.find(bookRe.getBookId().toString());//跟具书籍编号查找书列表
				    			resNames=bookRe.getName();
				    			if(flag.equals("0")){
					    			logContentHead ="书籍资源审核记录。账号："+curStaff.getCode()+ "；提交书籍《"+book.getName()+"》的资源："+resNames+",资源正在审核;在"+Nowdatetime.getdate()+"时间。";
					    		}
					    		if(flag.equals("1")){
					    			logContentHead ="书籍资源审核记录。账号："+curStaff.getCode()+ "；提交书籍《"+book.getName()+"》的资源："+resNames+",资源审核通过，以发布;在"+Nowdatetime.getdate()+"时间。";
					    		}if(flag.equals("-1")){
					    			logContentHead ="书籍资源审核记录。账号："+curStaff.getCode()+ "；提交书籍《"+book.getName()+"》的资源："+resNames+",资源审核失败，以打回;在"+Nowdatetime.getdate()+"时间。";
					    		}
					    		if(flag.equals("2")){
					    			logContentHead ="书籍资源审核记录。账号："+curStaff.getCode()+ "；提交书籍《"+book.getName()+"》的资源："+resNames+",资源审核成功，以上架;在"+Nowdatetime.getdate()+"时间。";
					    		}
					    		if(flag.equals("3")){
				 	    			logContentHead ="书籍提交审核记录。账号："+curStaff.getCode()+"；提交书籍《"+book.getName()+"》的资源："+resNames+",资源以下架;在"+Nowdatetime.getdate()+"时间。";
				 	    		}
					    		//System.out.println(logContentHead);
					    		bookLog.setBookId(bookRe.getBookId());
					    		bookLog.setLogTypeId(BigInteger.valueOf(84));
					    		bookLog.setFunctionId(BigInteger.valueOf(84));
					    		bookLog.setContent(logContentHead);
					    		bookLogDao.saveBookLog(bookLog);
							}
				    	
				    		
				    		
			    	     }
		    }
 		    
	}catch (Exception e) {
		e.printStackTrace();
	}
	return result;
		
	} 



} 