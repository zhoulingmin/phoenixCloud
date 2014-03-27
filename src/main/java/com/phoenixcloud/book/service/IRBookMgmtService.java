package com.phoenixcloud.book.service;

import java.math.BigInteger;
import java.util.List;

import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.RRegCode;

public interface IRBookMgmtService {
	List<RBook> getAllBooks();
	void saveBook(RBook book);
	RBook findBook(String bookId);
	void removeBook(String bookId);
	List<RBook> searchBook(RBook book);
	boolean checkBookNoExist(String bookNo);
	
	List<RBookDire> getBookDires(BigInteger bookId, BigInteger parentId);
	void saveBookDire(RBookDire bookDire);
	RBookDire findBookDire(String direId);
	void removeDire(BigInteger bookId, BigInteger direId);
	
	RBookRe findBookRes(String resId);
	List<BigInteger> getBookIdsHaveRes();
	List<RBookRe> getResByBookId(BigInteger bookId);
	List<RBookRe> getAllRes();
	void saveBookRes(RBookRe bookRes);
	void removeRes(String resId);
	List<RBookRe> searchRes(RBook book, RBookRe res);
	
	RRegCode findRegCode(String id);
	List<RRegCode> getAllRegCodes();
	void saveRegCode(RRegCode code);
	void removeRegCode(String id);
	
}
