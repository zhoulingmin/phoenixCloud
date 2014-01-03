package com.phoenixcloud.bean;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the pub_press database table.
 * 
 */
@Entity
@Table(name="pub_press")
public class PubPress extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="PRESS_ID", unique=true, nullable=false)
	private String pressId;

	@Column(length=60)
	private String code;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(nullable=false, length=60)
	private String name;

	@Column(length=255)
	private String notes;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	public PubPress() {
	}

	public String getPressId() {
		return this.pressId;
	}

	public void setPressId(String pressId) {
		this.pressId = pressId;
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

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return pressId;
	}

}