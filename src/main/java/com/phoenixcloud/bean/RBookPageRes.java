package com.phoenixcloud.bean;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name="r_book_page_res")
public class RBookPageRes extends AbstractModel<String> implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="PAGE_RES_ID", unique=true, nullable=false)
	private String pageResId;
	
	@Column(name="BOOK_ID", nullable=false)
	private BigInteger bookId;
	
	@Column(name="RES_ID", nullable=false)
	private BigInteger resId;
	
	@Column(name="PAGE_NUM")
	private int pageNum;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;
	
	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState = (byte)0;
	
	@Column(name="STAFF_ID", nullable=false)
	private BigInteger staffId;
	
	@Column(length=255)
	private String notes;

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return pageResId;
	}

	public String getPageResId() {
		return pageResId;
	}

	public void setPageResId(String pageResId) {
		this.pageResId = pageResId;
	}

	public BigInteger getBookId() {
		return bookId;
	}

	public void setBookId(BigInteger bookId) {
		this.bookId = bookId;
	}

	public BigInteger getResId() {
		return resId;
	}

	public void setResId(BigInteger resId) {
		this.resId = resId;
	}

	public int getPageNum() {
		return pageNum;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public byte getDeleteState() {
		return deleteState;
	}

	public void setDeleteState(byte deleteState) {
		this.deleteState = deleteState;
	}

	public BigInteger getStaffId() {
		return staffId;
	}

	public void setStaffId(BigInteger staffId) {
		this.staffId = staffId;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

}
