package com.phoenixcloud.bean;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigInteger;
import java.util.Date;


/**
 * The persistent class for the r_reg_code database table.
 * 
 */
@Entity
@Table(name="r_reg_code")
public class RRegCode extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="REG_CODE_ID", unique=true, nullable=false)
	private String regCodeId;

	@Column(name="BOOK_ID", nullable=false)
	private BigInteger bookId;

	@Column(nullable=false, length=60)
	private String code;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(name="IS_VALID", nullable=false)
	private byte isValid;

	@Column(length=255)
	private String notes;

	@Column(name="STAFF_ID", nullable=false)
	private BigInteger staffId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	@Temporal(TemporalType.DATE)
	@Column(name="VALID_DATE")
	private Date validDate;

	public RRegCode() {
	}

	public String getRegCodeId() {
		return this.regCodeId;
	}

	public void setRegCodeId(String regCodeId) {
		this.regCodeId = regCodeId;
	}

	public BigInteger getBookId() {
		return this.bookId;
	}

	public void setBookId(BigInteger bookId) {
		this.bookId = bookId;
	}

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
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

	public byte getIsValid() {
		return this.isValid;
	}

	public void setIsValid(byte isValid) {
		this.isValid = isValid;
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

	public Date getValidDate() {
		return this.validDate;
	}

	public void setValidDate(Date validDate) {
		this.validDate = validDate;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return regCodeId;
	}

}