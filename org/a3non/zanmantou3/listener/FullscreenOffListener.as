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
        
public class FullscreenOffListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function FullscreenOffListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		var ui:UserInterface = this.zanmantou.getUserInterface();
	
		// trigger js event
		this.zanmantou.getJSAPI().triggerEvent("fullscreenoff", "");
			
		this.zanmantou.getComponentManager().enableFullscreen(false);

		// swap buttons
		ui.displayButtons("fullscreenoff", false);
		ui.displayButtons("fullscreenon", true);
	}

}}