package com.phoenixcloud.bean;

import java.io.Serializable;
import java.math.BigInteger;
import java.text.DecimalFormat;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
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

	@Column(name="ALL_ADDR_IN_NET")
	private String allAddrInNet;
	
	@Column(name="ALL_ADDR_OUT_NET")
	private String allAddrOutNet;
	
	@Column(name="COVER_URL_IN_NET")
	private String coverUrlInNet;
	
	@Column(name="COVER_URL_OUT_NET")
	private String coverUrlOutNet;

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
	private int pageNum;
	
	@Lob
	@Column(name="COVER_IMG")
	private byte[] coverImg;
	
	@Column(name="COVER_CONT_TYPE", length=50)
	private String coverContType;
	
	@Column(name="BOOK_SIZE", length=10)
	private int bookSize = 0;

	public RBook() {
	}

	public String getBookId() {
		return this.bookId;
	}

	public void setBookId(String bookId) {
		this.bookId = bookId;
	}

	public String getAllAddrInNet() {
		return allAddrInNet;
	}

	public void setAllAddrInNet(String allAddrInNet) {
		this.allAddrInNet = allAddrInNet;
	}

	public String getAllAddrOutNet() {
		return allAddrOutNet;
	}

	public void setAllAddrOutNet(String allAddrOutNet) {
		this.allAddrOutNet = allAddrOutNet;
	}

	public String getCoverUrlInNet() {
		return coverUrlInNet;
	}

	public void setCoverUrlInNet(String coverUrlInNet) {
		this.coverUrlInNet = coverUrlInNet;
	}

	public String getCoverUrlOutNet() {
		return coverUrlOutNet;
	}

	public void setCoverUrlOutNet(String coverUrlOutNet) {
		this.coverUrlOutNet = coverUrlOutNet;
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

	public int getPageNum() {
		return pageNum;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	
	public String getLocalPath() {
		String localPath = "";
		
		if (this.isUpload == (byte)0) {
			return localPath;
		}
		
		int startIdx = this.allAddrInNet.indexOf(":");
		if (startIdx == -1){
			return localPath;
		}
		
		startIdx = this.allAddrInNet.indexOf(":", startIdx + 1);
		if (startIdx == -1){
			return localPath;
		}
		
		startIdx = this.allAddrInNet.indexOf("/", startIdx);
		if (startIdx == -1) {
			return localPath;
		}
		if (System.getProperty("os.name").toLowerCase().indexOf("windows") != -1) {
			localPath = this.allAddrInNet.substring(startIdx + 1);
		} else {
			localPath = this.allAddrInNet.substring(startIdx);
		}
		
		return localPath;
	}
	
	public String getBookFileName() {
		if (isUpload == (byte)0 || allAddrInNet == null || allAddrInNet.trim().length() == 0) {
			return "";
		}
		int lastIdx = allAddrInNet.lastIndexOf("/");
		if (lastIdx == (allAddrInNet.length() - 1)) {
			return "";
		}

		return allAddrInNet.substring(lastIdx + 1);
	}

	public String getCoverContType() {
		return coverContType;
	}

	public void setCoverContType(String coverContType) {
		this.coverContType = coverContType;
	}

	public byte[] getCoverImg() {
		return coverImg;
	}

	public void setCoverImg(byte[] coverImg) {
		this.coverImg = coverImg;
	}

	public int getBookSize() {
		return bookSize;
	}
	
	public String getBeatifySize() {
		return new DecimalFormat(",###").format(bookSize);
	}

	public void setBookSize(int bookSize) {
		this.bookSize = bookSize;
	}
	
	public String getYearOfRls() {
		if (bookNo == null || bookNo.length() != 18) {
			return "";
		}
		return bookNo.substring(8, 12);
	}
	
	public String getQuarter() {
		if (bookNo == null || bookNo.length() != 18) {
			return "";
		}
		return bookNo.substring(12, 14);
	}
	
	public String getKindSeqNo() {
		if (bookNo == null || bookNo.length() != 18) {
			return "";
		}
		return bookNo.substring(7, 8);
	}
}