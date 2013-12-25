package org.a3non.zanmantou3.engines{

import com.adobe.fileformats.vcard.Email;
import com.adobe.utils.StringUtil;

import flash.display.*;
import flash.display.Sprite;
import flash.events.*;
import flash.geom.*;
import flash.geom.Rectangle;
import flash.media.*;
import flash.net.*;

import org.a3non.event.ActionListener;
import org.a3non.geom.*;
import org.a3non.ui.*;
import org.a3non.ui.components.Image;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.engines.*;


public class VideoEngine
	extends Engine
	implements ActionListener{		
	
	// net connnections
	private var con:NetConnection;	
	private var stream:NetStream;
	
	// video panels
	private var video:Video;
	private var stageVideo:StageVideo;
	
	private var soundManager:SoundManager;
	private var client:Object;
	private var length:int = 0;
	private var isPlaying:Boolean = false;
	private var isStageVideoEnabled:Boolean = false;
	
	private var completeEventLocked:Boolean = false;

	private var flash10fix:Sprite;
	
	// intializing conditions -> bug workaround BitmapData.draw(VIDEO)
	public static const VIDEO_OBJECT_SIZE_X:int = 200;
	public static const VIDEO_OBJECT_SIZE_Y:int = 100;
	
	public function VideoEngine(zanmantou:Zanmantou3){
		super(zanmantou);
	
		// get sound manager
		this.soundManager = zanmantou.getSoundManager()
		
		// create new stream client
        this.client = new Object();
        this.client.onMetaData = clientMetaHandler;
        
		// create new net connection
		this.con = new NetConnection();
        this.con.connect(null);

        // add handler
        this.con.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        this.con.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        
        // create new netstream
        this.stream = new NetStream(this.con);
        this.stream.client = this.client;
        this.stream.soundTransform = soundManager.getSoundTransform();

        // add handler
        this.stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
        this.stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        
        // create new video area and attach stream
        this.video = new Video(VideoEngine.VIDEO_OBJECT_SIZE_X, VideoEngine.VIDEO_OBJECT_SIZE_Y);
        this.video.attachNetStream(this.stream);
		this.video.smoothing = false;
		/*
		// get stage video vector
		var stageVideoVector:Vector.<StageVideo> = zanmantou.getStage().stageVideos; 
		
		// assign stage video object if avaible
		if (stageVideoVector.length>0){
			this.stageVideo = stageVideoVector[0];
		}		

		// add stage video event
		//stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, stageVideoAvaible);
		this.stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
		
		Zanmantou3.trace("stage video instances avaible: " +  stageVideoVector.length);
        */
		// add video to sprite
        this.addChild(this.video);
        
        // register sound transform update event
		this.soundManager.addEventListener(SoundManager.TransformUpdate, transformUpdate);

		// apply fix
		this.flash10fix = new Sprite();
		this.addChild(flash10fix);
    }

	public function enableStageVideo(enabled:Boolean):void{
		Zanmantou3.trace("StageVideo enabled: " + enabled);

		// enable ?
		if (enabled && this.stageVideo!=null){
			// get stage video vector
			var stageVideoVector:Vector.<StageVideo> = zanmantou.getStage().stageVideos; 
			
			// assign stage video object if avaible
			if (stageVideoVector.length>0){
				this.stageVideo = stageVideoVector[0];
			}		
			
			// add stage video event
			this.stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);

			// display instance count
			Zanmantou3.trace("stage video instances avaible: " +  stageVideoVector.length);

			this.isStageVideoEnabled = true;
			this.stageVideo.attachNetStream(this.stream);
			
			if (this.isThumbVisible()){
				this.video.visible = false;
			}
		}else{
			// enable software rendered playback
			this.isStageVideoEnabled = false;
			this.video.attachNetStream(this.stream);
			
			if (!this.isThumbVisible()){
				this.video.visible = true;
			}
		}
	}
	
	public override function setThumbnail(url:String):void{
		super.setThumbnail(url);
		this.video.visible = false;
	}
	
	public override function showThumb(show:Boolean):void{
		super.showThumb(show);
		
		if (show){
			this.video.visible = false;
		}
		
	}
	// STAGE VIDEO STATE listener
	private function stageVideoStateChange(event:StageVideoEvent):void{
		var status:String = event.status;

	}
	
	// sound transform update callback
	public function transformUpdate(event:Event):void{
		if (this.stream){
			// assign transform object
			this.stream.soundTransform = this.soundManager.getSoundTransform();
		}
	}

	 
	public override function play(url:String, position:Number = -2):void{
		super.play(url, position);
		
		//this.zanmantou.getVisionLightManager().startCapture();
		
		// show video, hide thumb
		if (this.isStageVideoEnabled){
			this.video.visible = false;			
		}else{
			this.video.visible = true;
		}
		this.showThumb(false);		
		
		this.stream.play(url, position);
		this.stream.client = this.client;
		
		// flag
		this.isPlaying = true;
	}
	
	public override function pause():void{
		super.pause();
		
		this.stream.pause();
	}
	
	public override function stop():void{
		super.stop();
		
		//this.zanmantou.getVisionLightManager().stopCapture();
		
		this.stream.seek(0);
		this.stream.pause();
		//this.stream.close();

		//if (this.isThumbVisible()){
			// hide video, show thumb
		//}
		this.video.visible = false;
		this.showThumb(true);
	}
	
	public override function seek(position:Number):void{
		this.completeEventLocked = true;
		this.stream.seek(position);
		this.completeEventLocked = false;
	}
	
	public override function resume():void{
		this.stream.resume();
	}
	
	private function clientMetaHandler(data:Object):void{
		//for (var key:String in data){
		//	Zanmantou.trace("key: " + key + "-" + data[key]);
		//}
		//for (var key2:String in data.seekpoints[0]){
		//	Zanmantou.trace("sp: " + key2 + "-" + data.seekpoints[20][key2]);
		//}
		// dirty workaround for flash10, contextmenu bug
		/*this.flash10fix.graphics.clear();
		this.flash10fix.graphics.beginFill(0x000000,0);
		this.flash10fix.graphics.drawRect(0,0,data.width, data.height);
		this.flash10fix.graphics.endFill();
		*/
		// update length
		this.length = data.duration;		
		
		Zanmantou3.trace("video size: "+ data.width + " - " + data.height);
	
		// set real video size
		this.getSizeManager().setRAWVideoSize(data.width, data.height);
		
		// calculate size
		this.calculateSize();
		
		// rerender ui
		this.zanmantou.render();	
	}
	
	  private function get_nearest_seekpoint(second:Number, seekpoints:Array):int{
		var index1:int = 0;
		var index2:int = 0;
		
		// Iterate through array to find keyframes before and after scrubber second
		for(var i:int = 0; i != seekpoints.length; i++){
			if(seekpoints[i]["time"] < second){
				index1 = i;
			}else{
				index2 = i;
				break;
			}
		}
		// Calculate nearest keyframe
		if(second - seekpoints[index1]["time"] < seekpoints[index2]["time"] - second){
			return index1;
		}else{
			return index2;
		}
	  }
	 
	// netstream status callback
	private function netStatusHandler(event:NetStatusEvent):void {
		switch (event.info.code) {
			case "NetStream.Play.StreamNotFound":
				if (this.mediaErrorListener!=null){
					this.mediaErrorListener.actionPerformed(event);
				}	
				break;
			case "NetStream.Play.Stop":
				if (this.mediaCompleteListener!=null && !this.completeEventLocked){
					this.mediaCompleteListener.actionPerformed(new Event("complete"));
				}
				break;		
		}
	}
	
	private function ioErrorHandler(errorEvent:IOErrorEvent):void{
		if (this.mediaErrorListener!=null){
			this.mediaErrorListener.actionPerformed(new Event("error"));
		}		
	}
	
	private function securityErrorHandler(event:SecurityErrorEvent):void {
		if (this.mediaErrorListener!=null){
			this.mediaErrorListener.actionPerformed(event);
		}	
    }
	
	public override function getLength():int{
		return this.length;
	}
	public override function getTime():int{
		return this.stream.time;
	}
	public override function getProgress():Number{
		if (this.length>0){
			return this.getTime()/this.getLength();
		}else{
			return 0;
		}
	}
	public override function getLoadingProgress():Number{
		if (this.stream.bytesTotal>0){
			return this.stream.bytesLoaded/this.stream.bytesTotal;
		}else{
			return 0;
		}
	}
	public override function getFPS():int{
		return Math.floor(this.stream.currentFPS);
	} 
	
	public function getVideoObject():Video{
		return this.video;
	}
	
	// set video size on render
	public override function render():void{
		super.render();

		if (this.isStageVideoEnabled){
			// set stage video size+position
			this.stageVideo.viewPort = this.getDimension().getViewport();			
		}else{
			// set video size
			this.video.width = this.getDimension().getWidth();
			this.video.height = this.getDimension().getHeight();
		}
	} 
	
	// enable smoothing - only for normal video mode
	public function enableSmoothing(e:Boolean):void{
		this.video.smoothing = e;
	}
}}