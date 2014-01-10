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


/**
 * The persistent class for the r_book_res database table.
 * 
 */
@Entity
@Table(name="r_book_res")
public class RBookRe extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="RES_ID", unique=true, nullable=false)
	private String resId;

	@Column(name="ALL_ADDR", length=60)
	private String allAddr;

	@Column(name="AUDIT_STAFF_ID", nullable=false)
	private BigInteger auditStaffId;

	@Column(name="BOOK_ID", nullable=false)
	private BigInteger bookId;

	@Column(name="CATA_ADDR", length=255)
	private String cataAddr;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(nullable=false)
	private BigInteger format;

	@Column(name="IP_ADDR", length=16)
	private String ipAddr;

	@Column(name="IS_AUDIT", nullable=false)
	private byte isAudit = (byte)-1;

	@Column(name="IS_UPLOAD", nullable=false)
	private byte isUpload;

	@Column(nullable=false, length=60)
	private String name;

	@Column(length=255)
	private String notes;

	@Column(name="PARENT_RES_ID")
	private BigInteger parentResId;

	@Column(name="STAFF_ID", nullable=false)
	private BigInteger staffId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	public RBookRe() {
	}

	public String getResId() {
		return this.resId;
	}

	public void setResId(String resId) {
		this.resId = resId;
	}

	public String getAllAddr() {
		return this.allAddr;
	}

	public void setAllAddr(String allAddr) {
		this.allAddr = allAddr;
	}

	public BigInteger getAuditStaffId() {
		return this.auditStaffId;
	}

	public void setAuditStaffId(BigInteger auditStaffId) {
		this.auditStaffId = auditStaffId;
	}

	public BigInteger getBookId() {
		return this.bookId;
	}

	public void setBookId(BigInteger bookId) {
		this.bookId = bookId;
	}

	public String getCataAddr() {
		return this.cataAddr;
	}

	public void setCataAddr(String cataAddr) {
		this.cataAddr = cataAddr;
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

	public BigInteger getFormat() {
		return this.format;
	}

	public void setFormat(BigInteger format) {
		this.format = format;
	}

	public String getIpAddr() {
		return this.ipAddr;
	}

	public void setIpAddr(String ipAddr) {
		this.ipAddr = ipAddr;
	}

	public byte getIsAudit() {
		return this.isAudit;
	}

	public void setIsAudit(byte isAudit) {
		this.isAudit = isAudit;
	}

	public byte getIsUpload() {
		return this.isUpload;
	}

	public void setIsUpload(byte isUpload) {
		this.isUpload = isUpload;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNotes() {
		return this.notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public BigInteger getParentResId() {
		return this.parentResId;
	}

	public void setParentResId(BigInteger parentResId) {
		this.parentResId = parentResId;
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
		return resId;
	}

}