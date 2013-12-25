package org.a3non.zanmantou3.events{

import flash.events.*;
import org.a3non.zanmantou3.*;

        
public class ValueEvent
	extends Event{		
	
	private var value:Number = 0;
	
	public function ValueEvent(type:String, value:Number){
		super(type);
		this.value = value;
	}
	
	public function getValue():Number{
		return this.value;
	}


}}