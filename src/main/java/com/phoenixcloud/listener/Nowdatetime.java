package com.phoenixcloud.listener;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Nowdatetime {
	 public static String getdate() {
	     SimpleDateFormat format = new SimpleDateFormat(
	             "yyyy-MM-dd HH:mm:ss");
	     Date currentTime = new Date(); //得到当前系统时间
	     String new_date = format.format(currentTime); //将日期时间格式化
	     return new_date;
	 }
}
