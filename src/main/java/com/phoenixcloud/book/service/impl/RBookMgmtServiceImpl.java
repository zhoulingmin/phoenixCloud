package com.phoenixcloud.book.service.impl;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.dao.RBookDao;
import com.phoenixcloud.dao.RBookDireDao;
import com.phoenixcloud.dao.RBookLogDao;
import com.phoenixcloud.dao.RBookReDao;
import com.phoenixcloud.dao.RRegCodeDao;

@Component("bookMgmtServiceImpl")
public class RBookMgmtServiceImpl implements IRBookMgmtService {
	
	@Resource
	private RBookDao bookDao;
	
	@Resource
	private RBookDireDao bookDireDao;
	
	@Resource
	private RBookLogDao bookLogDao;
	
	@Resource
	private RBookReDao bookReDao;
	
	@Resource
	private RRegCodeDao regCodeDao;
	
	public void setBookDao(RBookDao bookDao) {
		this.bookDao = bookDao;
	}

	public void setBookDireDao(RBookDireDao bookDireDao) {
		this.bookDireDao = bookDireDao;
	}

	public void setBookLogDao(RBookLogDao bookLogDao) {
		this.bookLogDao = bookLogDao;
	}

	public void setBookReDao(RBookReDao bookReDao) {
		this.bookReDao = bookReDao;
	}

	public void setRegCodeDao(RRegCodeDao regCodeDao) {
		this.regCodeDao = regCodeDao;
	}
	
	public List<RBook> getAllBooks() {
		List<RBook> bookList = bookDao.getAll();
		if (bookList == null) {
			bookList = new ArrayList<RBook>();
		}
		return bookList;
	}

	public void saveBook(RBook book) {
		if (book.getId() == null || book.getId().isEmpty() || book.getId() == "0") {
			bookDao.persist(book);
		} else {
			bookDao.merge(book);
		}
	}
	
	public RBook findBook(String bookId) {
		return bookDao.find(bookId);
	}
	
	public void removeBook(String bookId) {
		bookDao.remove(bookId);
	}
	
	public List<RBookDire> getBookDires(BigInteger bookId, BigInteger parentId) {
		List<RBookDire> bdList = bookDireDao.findSubDires(bookId, parentId);
		if (bdList == null) {
			bdList = new ArrayList<RBookDire>();
		}
		return bdList;
	}
	
	public void saveBookDire(RBookDire bookDire) {
		if (bookDire.getId() == null || bookDire.getId().isEmpty() || bookDire.getId() == "0") {
			bookDireDao.persist(bookDire);
		} else {
			bookDireDao.merge(bookDire);
		}
	}
	
	public RBookDire findBookDire(String direId) {
		return bookDireDao.find(direId);
	}
	
	private void removeSubDire(String bookId, BigInteger direId){
		List<RBookDire> direList = bookDireDao.findSubDires(BigInteger.valueOf(Long.parseLong(bookId)), direId);
		for (RBookDire dire : direList) {
			removeSubDire(bookId, BigInteger.valueOf(Long.parseLong(dire.getId())));
			dire.setDeleteState((byte)1);
			bookDireDao.merge(dire);
		}
	}
	
	public void removeDire(String bookId, BigInteger direId) {
		// 递归删除子节点
		removeSubDire(bookId, direId);
		bookDireDao.remove(direId);
	}
	
	public List<BigInteger> getBookIdsHaveRes() {
		return bookReDao.getAllBookIds();
	}
	
	public List<RBookRe> getResByBookId(String bookId) {
		return bookReDao.getAllResByBookId(bookId);
	}
	
	public RBookRe findBookRes(String resId) {
		return bookReDao.find(resId);
	}
	
	public void removeRes(String resId) {
		RBookRe bookRes = bookReDao.find(resId);
		bookRes.setDeleteState((byte)1);
		bookRes.setUpdateTime(new Date());
		bookReDao.merge(bookRes);
	}
	
	public void saveBookRes(RBookRe bookRes) {
		bookRes.setUpdateTime(new Date());
		bookReDao.merge(bookRes);
	}
}
