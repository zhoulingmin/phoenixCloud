package com.phoenixcloud.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;


public class DateTypeConvertor extends StrutsTypeConverter{
	//时间字符串转成Date(即是你页面传来的时间字符串)
	@Override
	public Object convertFromString(Map context, String[] values, @SuppressWarnings("rawtypes") Class toClass) {
		Date date=null;
		if(values!=null&&values.length>0){
			SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			try {
				date = df.parse(values[0]);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		return (date != null) ? date : new Date();
	}

	//将Date类型的数据转成时间字符串
	@Override
	public String convertToString(Map context, Object o) {
		return new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format((Date)o);
	}
}

