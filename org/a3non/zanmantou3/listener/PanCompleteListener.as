package org.a3non.zanmantou3.listener{
import flash.events.*;

import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.util.*;
import org.a3non.event.*;

import org.a3non.zanmantou3.events.*;
        
public class PanCompleteListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function PanCompleteListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		var vevent:ValueEvent = e as ValueEvent;
		
		// set pan
		this.zanmantou.getSoundManager().setPan(vevent.getValue()*2-1);
	
		// trigger js event
		this.zanmantou.getJSAPI().triggerEvent("pancomplete", vevent.getValue() + "");
		
		// update slider
		this.zanmantou.getUserInterface().updateSlider("pan", vevent.getValue());
	}

}}