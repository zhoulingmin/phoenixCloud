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
 * The persistent class for the r_book database table.
 * 
 */
@Entity
@Table(name="r_book")
public class RBook extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="BOOK_ID", unique=true, nullable=false)
	private String bookId;

	@Column(name="ALL_ADDR", length=60)
	private String allAddr;

	@Column(name="CATA_ADDR_ID")
	private BigInteger cataAddrId;

	@Column(name="CLASS_ID", nullable=false)
	private BigInteger classId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(name="IP_ADDR", length=16)
	private String ipAddr;

	@Column(name="IS_UPLOAD", nullable=false)
	private byte isUpload = (byte)0;
	
	@Column(name="IS_AUDIT", nullable=false)
	private byte isAudit = (byte)-1;

	@Column(name="KIND_ID", nullable=false)
	private BigInteger kindId;

	@Column(nullable=false, length=255)
	private String name;

	@Column(length=255)
	private String notes;

	@Column(name="ORG_ID", nullable=false)
	private BigInteger orgId;

	@Column(name="PRESS_ID", nullable=false)
	private BigInteger pressId;

	@Column(name="STAFF_ID", nullable=false)
	private BigInteger staffId;

	@Column(name="STU_SEG_ID", nullable=false)
	private BigInteger stuSegId;

	@Column(name="SUBJECT_ID", nullable=false)
	private BigInteger subjectId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;
	
	@Column(name="BOOK_NO", nullable=false)
	private String bookNo;
	
	@Column(name="PAGE_NUM")
	private BigInteger pageNum;

	public RBook() {
	}

	public String getBookId() {
		return this.bookId;
	}

	public void setBookId(String bookId) {
		this.bookId = bookId;
	}

	public String getAllAddr() {
		return this.allAddr;
	}

	public void setAllAddr(String allAddr) {
		this.allAddr = allAddr;
	}

	public BigInteger getCataAddrId() {
		return this.cataAddrId;
	}

	public void setCataAddrId(BigInteger cataAddrId) {
		this.cataAddrId = cataAddrId;
	}

	public BigInteger getClassId() {
		return this.classId;
	}

	public void setClassId(BigInteger classId) {
		this.classId = classId;
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

	public String getIpAddr() {
		return this.ipAddr;
	}

	public void setIpAddr(String ipAddr) {
		this.ipAddr = ipAddr;
	}

	public byte getIsUpload() {
		return this.isUpload;
	}

	public void setIsUpload(byte isUpload) {
		this.isUpload = isUpload;
	}

	public BigInteger getKindId() {
		return this.kindId;
	}

	public byte getIsAudit() {
		return isAudit;
	}

	public void setIsAudit(byte isAudit) {
		this.isAudit = isAudit;
	}

	public void setKindId(BigInteger kindId) {
		this.kindId = kindId;
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

	public BigInteger getOrgId() {
		return this.orgId;
	}

	public void setOrgId(BigInteger orgId) {
		this.orgId = orgId;
	}

	public BigInteger getPressId() {
		return this.pressId;
	}

	public void setPressId(BigInteger pressId) {
		this.pressId = pressId;
	}

	public BigInteger getStaffId() {
		return this.staffId;
	}

	public String getBookNo() {
		return bookNo;
	}

	public void setBookNo(String bookNo) {
		this.bookNo = bookNo;
	}

	public void setStaffId(BigInteger staffId) {
		this.staffId = staffId;
	}

	public BigInteger getStuSegId() {
		return this.stuSegId;
	}

	public void setStuSegId(BigInteger stuSegId) {
		this.stuSegId = stuSegId;
	}

	public BigInteger getSubjectId() {
		return this.subjectId;
	}

	public void setSubjectId(BigInteger subjectId) {
		this.subjectId = subjectId;
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
		return bookId;
	}

	public BigInteger getPageNum() {
		return pageNum;
	}

	public void setPageNum(BigInteger pageNum) {
		this.pageNum = pageNum;
	}
	
	public String getLocalPath() {
		String localPath = "";
		
		if (this.isUpload == (byte)0) {
			return localPath;
		}
		
		int startIdx = this.allAddr.indexOf(":");
		if (startIdx == -1){
			return localPath;
		}
		
		startIdx = this.allAddr.indexOf(":", startIdx + 1);
		if (startIdx == -1){
			return localPath;
		}
		
		startIdx = this.allAddr.indexOf("/", startIdx);
		if (startIdx == -1) {
			return localPath;
		}
		if (System.getProperty("os.name").toLowerCase().indexOf("windows") != -1) {
			localPath = this.allAddr.substring(startIdx + 1);
		} else {
			localPath = this.allAddr.substring(startIdx);
		}
		
		return localPath;
	}
}