package org.a3non.zanmantou3{
	
import com.adobe.serialization.json.JSON;

import flash.events.Event;
import flash.external.ExternalInterface;
import flash.utils.ByteArray;

import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.events.*;
import org.a3non.zanmantou3.listener.*;
        
public class JavascriptAPI{		
	
	private var zanmantou:Zanmantou3;
	private var instanceID:String;
	private var eventpipe:Array;

	public function JavascriptAPI(zanmantou:Zanmantou3, javascriptEnabled:Boolean){
		this.zanmantou = zanmantou;
		this.instanceID = "";
		this.eventpipe = new Array();
		
		try{
			if (ExternalInterface.available && javascriptEnabled){
				// registering
				ExternalInterface.addCallback("z_register", register);
				
				// status
				ExternalInterface.addCallback("z_isPlaying", isPlaying);
				
				// playback
				ExternalInterface.addCallback("z_play", play);
				ExternalInterface.addCallback("z_start", start);
				ExternalInterface.addCallback("z_stop", stop);
				ExternalInterface.addCallback("z_pause", pause);
				ExternalInterface.addCallback("z_seek", seek);
				ExternalInterface.addCallback("z_prev", prev);
				ExternalInterface.addCallback("z_next", next);
				ExternalInterface.addCallback("z_shuffle", shuffle);
				ExternalInterface.addCallback("z_repeat", repeat);
				ExternalInterface.addCallback("z_repeatall", repeatall);
				
				// audio
				ExternalInterface.addCallback("z_setVolume", setVolume);
				ExternalInterface.addCallback("z_setPan", setPan);
				ExternalInterface.addCallback("z_getVolume", getVolume);
				ExternalInterface.addCallback("z_getPan", getPan);
				ExternalInterface.addCallback("z_mute", mute);
				ExternalInterface.addCallback("z_unmute", unmute);
				ExternalInterface.addCallback("z_setLRTransform", setLRTransform);
				
				// av panel stuff
				ExternalInterface.addCallback("z_setAVPanelRotation", setAVPanelRotation);
				ExternalInterface.addCallback("z_setAVPanelSize", setAVPanelSize);
				ExternalInterface.addCallback("z_setAVPanelPosition", setAVPanelPosition);
	
				// control panel stuff
				ExternalInterface.addCallback("z_setControlPanelRotation", setControlPanelRotation);
				ExternalInterface.addCallback("z_setControlPanelSize", setControlPanelSize);
				ExternalInterface.addCallback("z_setControlPanelPosition", setControlPanelPosition);
				
				// for visualisation
				ExternalInterface.addCallback("z_getWave", getWave);
				ExternalInterface.addCallback("z_getSpectrum", getSpectrum);
				
				// medialist manipulation
				ExternalInterface.addCallback("z_getMediaList", getMediaList);
				ExternalInterface.addCallback("z_setMediaList", setMediaList);
				ExternalInterface.addCallback("z_addMediaItem", addMediaItem);
				ExternalInterface.addCallback("z_removeMediaItem", removeMediaItem);
				ExternalInterface.addCallback("z_getMediaIndex", getMediaIndex);
				ExternalInterface.addCallback("z_setMediaIndex", setMediaIndex);
				
				// media informations
				ExternalInterface.addCallback("z_getMediaLength", getMediaLength);
				ExternalInterface.addCallback("z_getMediaTime", getMediaTime);
				ExternalInterface.addCallback("z_getMediaProgress", getMediaProgress);
				ExternalInterface.addCallback("z_getMediaLoadingProgress", getMediaLoadingProgress);
				ExternalInterface.addCallback("z_getFPS", getFPS);
				
				// visionlight
				ExternalInterface.addCallback("z_enableVisionLight", enableVisionLight);
				ExternalInterface.addCallback("z_getVisionLightColors", getVisionLightColors);
				
				// trigger init event
				//ExternalInterface.call("a3non_zanmantou_flashready_callback");
			}
		}catch(exc:Error){
			// display fatal error message
			Zanmantou3.fatal(exc.toString());
		}
	
	}
	
	// trigger flashready
	public function flashready():void{
		ExternalInterface.call("a3non_zanmantou_flashready_callback");		
	}

	
	/*************************************************************
	* LOWLEVEL
	*************************************************************/
	
	private function register(id:String):void{
		this.instanceID = id;
		
		// flush event pipe
		for (var i:int = 0;i<this.eventpipe.length;i++){
			ExternalInterface.call('a3non_zanmantou_callback', this.instanceID, this.eventpipe[i][0], this.eventpipe[i][1]);
		}
		
		// trigger registered event
		this.triggerEvent('registered', id);
	}
	
	/*************************************************************
	* STANDARD
	*************************************************************/
	
	private function play(url:String, type:String, position:Number):void{
		(new PlayListener(this.zanmantou, url, type, position)).actionPerformed(new Event("play"));
	}
	
	private function start():void{
		(new StartListener(this.zanmantou)).actionPerformed(new Event("start"));
	}
	
	private function stop():void{
		(new StopListener(this.zanmantou)).actionPerformed(new Event("stop"));
	}
		
	private function pause():void{		
		(new PauseListener(this.zanmantou)).actionPerformed(new Event("pause"));
	}
	
	private function seek(time:Number):void{		
		(new ProgressUpdateListener(this.zanmantou)).actionPerformed(new ValueEvent("progress", time/this.zanmantou.getMediaManager().getEngine().getLength()));
	}
	
	private function next():void{
		(new NextListener(this.zanmantou)).actionPerformed(new Event("next"));
	}
	
	private function prev():void{
		(new PrevListener(this.zanmantou)).actionPerformed(new Event("prev"));
	}

	private function shuffle(e:Boolean):void{
		if (e){
			(new ShuffleOnListener(this.zanmantou)).actionPerformed(new Event("shuffleon"));
		}else{
			(new ShuffleOffListener(this.zanmantou)).actionPerformed(new Event("shuffleoff"));
		}
	}
	private function repeat(e:Boolean):void{
		if (e){
			(new RepeatOnListener(this.zanmantou)).actionPerformed(new Event("repeaton"));
		}else{
			(new RepeatOffListener(this.zanmantou)).actionPerformed(new Event("repeatoff"));
		}
	}
	private function repeatall(e:Boolean):void{
		if (e){
			(new RepeatallOnListener(this.zanmantou)).actionPerformed(new Event("repeatallon"));
		}else{			
			(new RepeatallOffListener(this.zanmantou)).actionPerformed(new Event("repeatalloff"));
		}
	}
	private function smoothing(e:Boolean):void{
		if (e){
			(new SmoothingOnListener(this.zanmantou)).actionPerformed(new Event("smoothingon"));
		}else{
			(new SmoothingOffListener(this.zanmantou)).actionPerformed(new Event("smoothingoff"));
		}
	}
	/*************************************************************
	* AUDIO CONTROL
	*************************************************************/
	
	private function setVolume(value:Number):void{
		(new VolumeCompleteListener(this.zanmantou)).actionPerformed(new ValueEvent("volume", value));
	}
	
	private function setPan(value:Number):void{
		(new PanCompleteListener(this.zanmantou)).actionPerformed(new ValueEvent("pan", (value+1)/2));
	}
	
	private function getVolume():Number{
		return this.zanmantou.getSoundManager().getVolume();
	}
	
	private function getPan():Number{
		return this.zanmantou.getSoundManager().getPan();
	}
	
	private function mute():void{
		(new MuteListener(this.zanmantou)).actionPerformed(new Event("mute"));
	}
	
	private function unmute():void{
		(new UnmuteListener(this.zanmantou)).actionPerformed(new Event("unmute"));
	}
	
	private function setLRTransform(ll:Number, lr:Number, rr:Number, rl:Number):void{
		this.zanmantou.getSoundManager().setLRTransform(ll, lr, rr, rl);
	}
	
	private function getWave():String{
		return JSON.encode(this.zanmantou.getSoundManager().getWave());
	}
	
	private function getSpectrum():String{
		return JSON.encode(this.zanmantou.getSoundManager().getSpectrum());
	}
	/*************************************************************
	* AV Pane Actions
	*************************************************************/
	
	private function setAVPanelRotation(x:int, y:int, z:int):void{
		//this.zanmantou.getComponentManager().getEngineComponent().setRotation(x,y,z);
	}
	private function setAVPanelSize(x:String, y:String):void{
		//this.zanmantou.getComponentManager().getEngineComponent().setSize(x,y);
	}
	private function setAVPanelPosition(x:String, y:String, z:String):void{
		//this.zanmantou.getComponentManager().getEngineComponent().setPosition(x,y,z);
	}
	
	/*************************************************************
	* Control Pane Actions
	*************************************************************/
	
	private function setControlPanelRotation(x:int, y:int, z:int):void{
		//this.zanmantou.getComponentManager().getNormalControlComponent().setRotation(x,y,z);
	}
	private function setControlPanelSize(x:String, y:String):void{
		//this.zanmantou.getComponentManager().getNormalControlComponent().setSize(x,y);
	}
	private function setControlPanelPosition(x:String, y:String, z:String):void{
		//this.zanmantou.getComponentManager().getNormalControlComponent().setPosition(x,y,z);
	}

	/*************************************************************
	* MediaList Manipulation 
	*************************************************************/
	
	private function removeMediaItem(i:int):void{
		this.zanmantou.getMediaManager().getMediaList().removeMediaItem(i);
	}
	
	private function addMediaItem(index:int, json:String):void{
		this.zanmantou.getMediaManager().getMediaList().addMediaItem(index, JSON.decode(json));
	}
	
	private function setMediaIndex(i:int):void{
		this.zanmantou.getMediaManager().getMediaList().setMediaIndex(i);
	}
	private function getMediaIndex():int{
		return this.zanmantou.getMediaManager().getMediaList().getMediaIndex();
	}
	private function setMediaList(json:String):void{
		this.zanmantou.getMediaManager().getMediaList().setMediaList(JSON.decode(json));
	}
	private function getMediaList():String{
		return JSON.encode(this.zanmantou.getMediaManager().getMediaList().getMediaList());
	}
	
	/*************************************************************
	* STATUS
	*************************************************************/	
	
	private function isPlaying():Boolean{
		return this.zanmantou.getMediaManager().isMediaPlaying();
	}

	/*************************************************************
	* MEDIA INFORMAION
	*************************************************************/	

	private function getMediaLength():int{
		return this.zanmantou.getMediaManager().getEngine().getLength();
	}
	private function getMediaTime():int{
		return this.zanmantou.getMediaManager().getEngine().getTime();
	}
	private function getFPS():int{
		return this.zanmantou.getMediaManager().getEngine().getFPS();
	}
	private function getMediaProgress():Number{
		return this.zanmantou.getMediaManager().getEngine().getProgress();
	}
	private function getMediaLoadingProgress():Number{
		return this.zanmantou.getMediaManager().getEngine().getLoadingProgress();
	}

	/*************************************************************
	 * VISION LIGHT
	 *************************************************************/	
	
	private function enableVisionLight(e:Boolean):void{
		/*if (e){
			(new VisionLightOnListener(this.zanmantou)).actionPerformed(new Event("visionlighton"));
		}else{
			(new VisionLightOffListener(this.zanmantou)).actionPerformed(new Event("visionlightoff"));
		}*/
	}
	
	private function getVisionLightColors():String{
		//return JSON.encode(this.zanmantou.getVisionLightManager().getVisionLightColors());
		return "Visionlight disabled";
	}

	
	/*************************************************************
	* CALLBACK 
	*************************************************************/
	
	public function triggerEvent(event:String, args:String):void{
		// EI supported ?
		if (ExternalInterface.available){
			// playerID already registered ?
			if (this.instanceID == ""){
				// store event
				this.eventpipe.push(new Array(event, args));			
			}else{
				// directly fire event
				ExternalInterface.call('a3non_zanmantou_callback', this.instanceID, event, args);
			}
			
			// on debug, trace message
			if (Zanmantou3.debug){
				ExternalInterface.call('console.log', "JS API Call: ", this.instanceID, event, args);
			}
		}
	}

}}