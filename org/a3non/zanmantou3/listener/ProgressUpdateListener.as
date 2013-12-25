package org.a3non.zanmantou3.listener{
import flash.events.*;

import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.events.*;
import org.a3non.util.*;
import org.a3non.event.*;
        
public class ProgressUpdateListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function ProgressUpdateListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		var vevent:ValueEvent = e as ValueEvent;
		
		// set position
		this.zanmantou.getMediaManager().seek(vevent.getValue()*this.zanmantou.getMediaManager().getEngine().getLength());
	}

}}