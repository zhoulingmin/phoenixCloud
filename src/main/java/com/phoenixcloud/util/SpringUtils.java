package com.phoenixcloud.util;

import org.apache.commons.lang.WordUtils;
import org.springframework.beans.factory.BeanFactory;

public class SpringUtils {
    /**
     * This variable is populated by one of the context listeners.
     */
    public static BeanFactory beanFactory = null;

    public static Object getBean(String beanName)
    {
        return(beanFactory.getBean(beanName));
    }
    
    public static <T> T getBean(Class clazz){
    	return (T) beanFactory.getBean(WordUtils.uncapitalize(clazz.getSimpleName()));
    }
}
