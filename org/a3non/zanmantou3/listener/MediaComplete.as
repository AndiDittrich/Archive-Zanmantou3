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
        
public class MediaComplete
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function MediaComplete(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		// fire js event
		this.zanmantou.getJSAPI().triggerEvent("mediacomplete", e.type);

		if (this.zanmantou.getMediaManager().getMediaList().isRepeatEnabled()){
			this.zanmantou.getMediaManager().start();
		}else{
			this.zanmantou.getMediaManager().next(false);
		}
	}

}}