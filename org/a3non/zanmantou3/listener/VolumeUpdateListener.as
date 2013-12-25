package org.a3non.zanmantou3.listener{
import flash.events.*;

import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.events.*;
import org.a3non.util.*;
import org.a3non.event.*;
        
public class VolumeUpdateListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function VolumeUpdateListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		var vevent:ValueEvent = e as ValueEvent;
		
		// set volume
		this.zanmantou.getSoundManager().setVolume(vevent.getValue());
	}

}}