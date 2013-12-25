package org.a3non.zanmantou3.listener{
import flash.events.*;

import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.util.*;
import org.a3non.event.*;

import org.a3non.zanmantou3.events.*;
        
public class ProgressCompleteListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function ProgressCompleteListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		var vevent:ValueEvent = e as ValueEvent;
		
		// set progress
		var mm:MediaManager = this.zanmantou.getMediaManager();
	
		// start media after seek ?
		if (mm.playingBeforeSeek()){
			mm.start();
		}
	
		// trigger js event
		this.zanmantou.getJSAPI().triggerEvent("progresscomplete", vevent.getValue() + "");
		
		// update slider
		this.zanmantou.getUserInterface().updateSlider("progress", vevent.getValue());
		this.zanmantou.getUserInterface().enableProgressUpdate(true);
	}

}}