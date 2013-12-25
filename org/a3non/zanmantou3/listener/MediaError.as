package org.a3non.zanmantou3.listener{
import flash.display.*;
import flash.display.Sprite;
import flash.events.*;
import flash.media.Video;
import flash.net.*;
import flash.text.*;
import flash.ui.*;

import org.a3non.event.*;
import org.a3non.ui.components.*;
import org.a3non.util.*;
import org.a3non.zanmantou3.*;
        
public class MediaError
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function MediaError(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		// fire js event
		this.zanmantou.getJSAPI().triggerEvent("mediaerror", "");
		
		// debug msg
		Zanmantou3.error("Mediaerror: " + this.zanmantou.getMediaManager().getMediaPath() + this.zanmantou.getMediaManager().getMediaList().getCurrentItem().source);

		// remove file
		this.zanmantou.getMediaManager().getMediaList().removeCurrentItem();
		
		// trigger next
		this.zanmantou.getMediaManager().next(true);
	}

}}