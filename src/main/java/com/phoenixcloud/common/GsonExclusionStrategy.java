package com.phoenixcloud.common;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.phoenixcloud.util.NotSerialize;
  
public class GsonExclusionStrategy implements ExclusionStrategy {  
  
    private final Class<?> typeToSkip;  
      
    public GsonExclusionStrategy(){  
        this.typeToSkip=null;  
    }  
      
    public GsonExclusionStrategy(Class<?> typeToSkip) {  
        this.typeToSkip = typeToSkip;  
    }  
      
    public boolean shouldSkipClass(Class<?> clazz) {  
        return (clazz == typeToSkip);  
    }  
  
    public boolean shouldSkipField(FieldAttributes f) {  
        return f.getAnnotation(NotSerialize.class) != null;  
    }  
  
}  