package com.phoenixcloud.bean;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigInteger;
import java.util.Date;


/**
 * The persistent class for the r_book_log database table.
 * 
 */
@Entity
@Table(name="r_book_log")
public class RBookLog extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="LOG_ID", unique=true, nullable=false)
	private String logId;

	@Column(name="BOOK_ID")
	private BigInteger bookId;

	@Column(length=1000)
	private String content;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(name="FUNCTION_ID", nullable=false)
	private BigInteger functionId;

	@Column(name="LOG_TYPE_ID", nullable=false)
	private BigInteger logTypeId;

	@Column(length=255)
	private String notes;

	@Column(name="STAFF_ID", nullable=false)
	private BigInteger staffId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	public RBookLog() {
	}

	public String getLogId() {
		return this.logId;
	}

	public void setLogId(String logId) {
		this.logId = logId;
	}

	public BigInteger getBookId() {
		return this.bookId;
	}

	public void setBookId(BigInteger bookId) {
		this.bookId = bookId;
	}

	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public byte getDeleteState() {
		return this.deleteState;
	}

	public void setDeleteState(byte deleteState) {
		this.deleteState = deleteState;
	}

	public BigInteger getFunctionId() {
		return this.functionId;
	}

	public void setFunctionId(BigInteger functionId) {
		this.functionId = functionId;
	}

	public BigInteger getLogTypeId() {
		return this.logTypeId;
	}

	public void setLogTypeId(BigInteger logTypeId) {
		this.logTypeId = logTypeId;
	}

	public String getNotes() {
		return this.notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public BigInteger getStaffId() {
		return this.staffId;
	}

	public void setStaffId(BigInteger staffId) {
		this.staffId = staffId;
	}

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return logId;
	}

}