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
        
public class PlayListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;
	private var source:String = "";
	private var type:String = "";
	private var position:int;


	public function PlayListener(zanmantou:Zanmantou3, source:String, type:String, position:int){
		this.zanmantou = zanmantou;
		this.source = source;
		this.type = type;
		this.position = position;
	}

	public function actionPerformed(e:Event):void{
		var ui:UserInterface = this.zanmantou.getUserInterface();
	
		// create item
		var item:Object = new Object();
		item.source = this.source;
		item.type = this.type;
		
		// start item
		this.zanmantou.getMediaManager().play(item, this.position);
		
		// swap start/pause buttons
		ui.displayButtons("start", false);
		ui.displayButtons("pause", true);
	}

}}