package org.a3non.zanmantou3.listener{
import flash.display.Sprite;
import flash.display.*;
import flash.text.*;
import flash.net.*;
import flash.media.Video;
import flash.ui.*;
import flash.events.*;

import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.util.*;
import org.a3non.event.*;
        
public class SmoothingOnListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function SmoothingOnListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		var ui:UserInterface = this.zanmantou.getUserInterface();
	
		// trigger js event
		this.zanmantou.getJSAPI().triggerEvent("smoothingon", "");
		
		// start item
		this.zanmantou.getMediaManager().getVideoEngine().enableSmoothing(true);
		
		// swap buttons
		ui.displayButtons("smoothingoff", true);
		ui.displayButtons("smoothingon", false);
	}

}}