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
        
public class MuteByVolumeListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function MuteByVolumeListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		this.zanmantou.getJSAPI().triggerEvent("mute", "");
		
		var ui:UserInterface = this.zanmantou.getUserInterface();
	
		// swap start/pause buttons
		ui.displayButtons("unmute", true);
		ui.displayButtons("mute", false);
	}

}}