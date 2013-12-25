package org.a3non.zanmantou3.engines{
	
import flash.display.*;
import flash.events.*;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.*;
import flash.text.*;

import org.a3non.event.ActionListener;
import org.a3non.ui.Component;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.engines.*;
import org.a3non.zanmantou3.listener.*;
        
public class AudioEngine
	extends Engine{		
		
	private var soundFactory:Sound = null;
	private var channel:SoundChannel;
	private var soundManager:SoundManager;
	private var position:Number = 0;
	private var isPlaying:Boolean = false;

	public function AudioEngine(zanmantou:Zanmantou3){
		super(zanmantou);
		
		// get sound manager
		this.soundManager = zanmantou.getSoundManager();

		// register sound transform update event
		this.soundManager.addEventListener(SoundManager.TransformUpdate, transformUpdate);
    }
	
	private function transformUpdate(event:Event):void{
		if (this.channel){
			// assign transform object
			this.channel.soundTransform = this.soundManager.getSoundTransform();
		}
	}
	
	public override function play(url:String, position:Number = 0):void{	
		if (this.channel){
			this.channel.stop();
		}

		this.isPlaying = true;
		
		// create new sound
		this.soundFactory = new Sound();
		this.soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		
		// load sound
		this.soundFactory.load(new URLRequest(url));
		
		// start playback
		this.channel = this.soundFactory.play(position/1000);
		this.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		this.channel.soundTransform = this.soundManager.getSoundTransform();
	}
	
	public override function pause():void{
		this.isPlaying = false;
		this.position = this.channel.position
		this.channel.stop();
	}
	
	public override function resume():void{
		this.isPlaying = true;
		if (this.channel){
			// start playback
			this.channel.stop();
			this.channel = this.soundFactory.play(this.position);		
			this.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			this.channel.soundTransform = this.soundManager.getSoundTransform();
		}
	}	
	public override function stop():void{
		this.isPlaying = false;
		
		if (this.channel){
			this.channel.stop();
		}
	}
	
	public override function seek(position:Number):void{
		this.position = position*1000;
		
		var isPlaying:Boolean = this.isPlaying;
		
		this.channel.stop();
		
		if (isPlaying && this.channel){
			this.channel = this.soundFactory.play(this.position);	
			this.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			this.channel.soundTransform = this.soundManager.getSoundTransform();
		}
	}
	
	private function soundCompleteHandler(e:Event):void{
		this.isPlaying = false;
		if (this.mediaCompleteListener!=null){
			this.mediaCompleteListener.actionPerformed(e);
		}
	}
	private function ioErrorHandler(errorEvent:IOErrorEvent):void{
		this.isPlaying = false;
		if (this.mediaErrorListener!=null){
			this.mediaErrorListener.actionPerformed(new Event("error"));
		}		
	}
	
	public override function getLength():int{
		if (this.soundFactory){
			return this.soundFactory.length/1000;
		}else{
			return 0;
		}
	}
	public override function getTime():int{
		if (this.channel){
			return this.channel.position/1000;
		}else{
			return 0;
		}
	}
	public override function getProgress():Number{
		if (this.soundFactory && this.soundFactory.length>0){
			return this.getTime()/this.getLength();
		}else{
			return 0;
		}
	}
	public override function getLoadingProgress():Number{
		if (this.soundFactory && this.soundFactory.bytesTotal>0){	
			return this.soundFactory.bytesLoaded/this.soundFactory.bytesTotal;
		}else{
			return 0;
		}
	}

}}