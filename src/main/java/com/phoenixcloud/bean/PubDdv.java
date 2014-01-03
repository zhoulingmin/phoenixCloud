package com.phoenixcloud.bean;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigInteger;
import java.util.Date;


/**
 * The persistent class for the pub_ddv database table.
 * 
 */
@Entity
@Table(name="pub_ddv")
public class PubDdv extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="DDV_ID", unique=true, nullable=false)
	private String ddvId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DDV_CODE", nullable=false)
	private BigInteger ddvCode;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(name="FIELD_NAME", length=60)
	private String fieldName;

	@Column(length=255)
	private String notes;

	@Column(name="TABLE_NAME", length=60)
	private String tableName;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	@Column(length=60)
	private String value;

	public PubDdv() {
	}

	public String getDdvId() {
		return this.ddvId;
	}

	public void setDdvId(String ddvId) {
		this.ddvId = ddvId;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public BigInteger getDdvCode() {
		return this.ddvCode;
	}

	public void setDdvCode(BigInteger ddvCode) {
		this.ddvCode = ddvCode;
	}

	public byte getDeleteState() {
		return this.deleteState;
	}

	public void setDeleteState(byte deleteState) {
		this.deleteState = deleteState;
	}

	public String getFieldName() {
		return this.fieldName;
	}

	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	public String getNotes() {
		return this.notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public String getTableName() {
		return this.tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getValue() {
		return this.value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return ddvId;
	}

}