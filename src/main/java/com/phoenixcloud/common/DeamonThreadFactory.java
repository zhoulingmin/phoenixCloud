package com.phoenixcloud.common;

import java.util.concurrent.ThreadFactory;

public class DeamonThreadFactory implements ThreadFactory {

	private String threadName;
	private int threadPriority;
	
	public DeamonThreadFactory(String threadName, int threadPriority)
	{
		this.threadName=threadName;	
		this.threadPriority=threadPriority;
	}
	
	public Thread newThread(Runnable r) {
		Thread thread=new Thread(r, threadName);
		thread.setDaemon(true);
		thread.setPriority(threadPriority);
		return(thread);
    }

}
