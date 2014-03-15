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
 * The persistent class for the pub_server_addr database table.
 * 
 */
@Entity
@Table(name="pub_server_addr")
public class PubServerAddr extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="SADDR_ID", unique=true, nullable=false)
	private String saddrId;

	@Column(name="APP_PASSWORD", nullable=false, length=15)
	private String appPassword;

	@Column(name="APP_SER_IP", nullable=false, length=16)
	private String appSerIp;

	@Column(name="APP_USER_NAME", nullable=false, length=15)
	private String appUserName;

	@Column(name="BOOK_DIR", nullable=false, length=255)
	private String bookDir;
	
	@Column(name="RES_DIR", nullable=false, length=255)
	private String resDir;

	@Column(name="BOOK_SER_IP", nullable=false, length=16)
	private String bookSerIp;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DB_NAME", nullable=false, length=15)
	private String dbName;

	@Column(name="DB_SER_IP", nullable=false, length=16)
	private String dbSerIp;

	@Column(name="DB_STRING", nullable=false, length=60)
	private String dbString;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(length=255)
	private String notes;

	@Column(name="ORG_ID", nullable=false)
	private BigInteger orgId;

	@Column(nullable=false, length=15)
	private String password;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	@Column(name="USER_NAME", nullable=false, length=15)
	private String userName;

	public PubServerAddr() {
	}

	public String getSaddrId() {
		return this.saddrId;
	}

	public void setSaddrId(String saddrId) {
		this.saddrId = saddrId;
	}

	public String getAppPassword() {
		return this.appPassword;
	}

	public void setAppPassword(String appPassword) {
		this.appPassword = appPassword;
	}

	public String getAppSerIp() {
		return this.appSerIp;
	}

	public void setAppSerIp(String appSerIp) {
		this.appSerIp = appSerIp;
	}

	public String getAppUserName() {
		return this.appUserName;
	}

	public void setAppUserName(String appUserName) {
		this.appUserName = appUserName;
	}

	public String getBookDir() {
		return this.bookDir;
	}

	public void setBookDir(String bookDir) {
		this.bookDir = bookDir;
	}

	public String getBookSerIp() {
		return this.bookSerIp;
	}

	public void setBookSerIp(String bookSerIp) {
		this.bookSerIp = bookSerIp;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getDbName() {
		return this.dbName;
	}

	public void setDbName(String dbName) {
		this.dbName = dbName;
	}

	public String getDbSerIp() {
		return this.dbSerIp;
	}

	public void setDbSerIp(String dbSerIp) {
		this.dbSerIp = dbSerIp;
	}

	public String getDbString() {
		return this.dbString;
	}

	public void setDbString(String dbString) {
		this.dbString = dbString;
	}

	public byte getDeleteState() {
		return this.deleteState;
	}

	public void setDeleteState(byte deleteState) {
		this.deleteState = deleteState;
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

	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return saddrId;
	}

	public String getResDir() {
		return resDir;
	}

	public void setResDir(String resDir) {
		this.resDir = resDir;
	}

}