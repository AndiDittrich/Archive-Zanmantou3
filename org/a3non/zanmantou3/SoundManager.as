package org.a3non.zanmantou3{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.utils.ByteArray;

import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.engines.*;
import org.a3non.zanmantou3.events.ValueEvent;
import org.a3non.zanmantou3.listener.*;


public class SoundManager extends EventDispatcher{		

	private var soundTransform:SoundTransform;
	private var storedVolume:Number;
	private var spectrum:ByteArray;
	private var wave:ByteArray;
	private var isMuted:Boolean;
	private var zanmantou:Zanmantou3;

	private var unmuteByVolumeListener:UnmuteByVolumeListener;
	private var muteByVolumeListener:MuteByVolumeListener;

	public static var TransformUpdate:String = "TransformUpdate";

	public function SoundManager(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
		this.soundTransform = new SoundTransform();
		this.spectrum = new ByteArray()
		this.wave = new ByteArray();
		this.isMuted = false;
		this.unmuteByVolumeListener = new UnmuteByVolumeListener(zanmantou);
		this.muteByVolumeListener = new MuteByVolumeListener(zanmantou);
	}
	
	public function getSoundTransform():SoundTransform{
		return this.soundTransform;
	}

	/**
	 * Basic Sound Actions
	 */
	public function setVolume(volume:Number):void{
		if (!this.isMuted && volume==0){
			this.isMuted = true;
			this.muteByVolumeListener.actionPerformed(new Event("muteByVolume"));
		}
		
		if (this.isMuted && volume!=0){
			this.isMuted = false;
			this.unmuteByVolumeListener.actionPerformed(new Event("unmuteByVolume"));
		}
		
		this.soundTransform.volume = volume;
		this.dispatchEvent(new Event(SoundManager.TransformUpdate));
		
	}
	
	public function setPan(pan:Number):void{
		this.soundTransform.pan = pan;
		this.dispatchEvent(new Event(SoundManager.TransformUpdate));
	}
	
	public function getVolume():Number{
		return this.soundTransform.volume;
	}
	
	public function getPan():Number{
		return this.soundTransform.pan;
	}
	
	public function mute():void{
		this.isMuted = true;
		this.storedVolume = this.getVolume();
		this.setVolume(0);
	}
	
	public function unmute():void{
		this.isMuted = false;
		this.setVolume(this.storedVolume);
	}
	
	public function getSpectrum():Array{
		SoundMixer.computeSpectrum(this.spectrum, true, 0);
		var tmp:Array = new Array();
		for (var i:int = 0; i < 512; i++) {
			tmp.push(this.wave.readFloat());	
		}
		return tmp;
	}
	
	public function getWave():Array{
		SoundMixer.computeSpectrum(this.wave, false, 0);
		var tmp:Array = new Array();
		for (var i:int = 0; i < 512; i++) {
			tmp.push(this.wave.readFloat());	
		}
		return tmp;
	}
	/**
	 * Advanced Actions
	 */
	public function setLRTransform(ll:Number, lr:Number, rr:Number, rl:Number):void{
		this.soundTransform.leftToLeft = ll;
		this.soundTransform.leftToRight = lr;
		this.soundTransform.rightToRight = rr;
		this.soundTransform.rightToLeft = rl;
		this.dispatchEvent(new Event(SoundManager.TransformUpdate));
	}
	
}}
