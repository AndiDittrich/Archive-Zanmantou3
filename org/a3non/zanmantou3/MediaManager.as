package org.a3non.zanmantou3{
	
import flash.display.Sprite;
import flash.events.*;

import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.engines.*;
import org.a3non.zanmantou3.listener.*;
        
public class MediaManager{		
	
	// engine type
	public static const ENGINE_VIDEO:int = 0;
	public static const ENGINE_AUDIO:int = 1;
	
	// media types
	public static const MEDIATYPE_UNKNOWN:int = 0;
	public static const MEDIATYPE_VIDEO:int = 1;
	public static const MEDIATYPE_AUDIO:int = 2;
	
	// zanmantou Object
	private var zanmantou:Zanmantou3;
	
	// Audio Engine
	private var audioEngine:AudioEngine;
	
	// Video Engine
	private var videoEngine:VideoEngine;
	
	// Active Engine
	private var engine:Engine = null;

	// flags
	private var isPaused:Boolean = false;
	private var isPlaying:Boolean = false;
	private var wasPlayingBeforeSeek:Boolean = false;

	// path
	private var mediapath:String = "";
	private var thumbnailpath:String = "";

	// settings
	private var inited:Boolean = false;

	private var mediaList:MediaList;
	public function MediaManager(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;

		// create video engine
    	this.videoEngine = new VideoEngine(zanmantou);
    	this.videoEngine.setMediaCompleteListener(new MediaComplete(zanmantou));
    	this.videoEngine.setMediaErrorListener(new MediaError(zanmantou));

		
		// create audio engine
		this.audioEngine = new AudioEngine(zanmantou);
		this.audioEngine.setMediaCompleteListener(new MediaComplete(zanmantou));
		this.audioEngine.setMediaErrorListener(new MediaError(zanmantou));

    	// add instances
		this.zanmantou.getComponentManager().getEngineComponent().addComponent(this.audioEngine);
		this.zanmantou.getComponentManager().getEngineComponent().addComponent(this.videoEngine);
    	
    	// select video engine
    	this.engine = this.videoEngine;
	}

	
	public function setConfig(config:XML, list:XML):void{
		// set media path
		this.mediapath = Zanmantou3.MEDIAPATH || config.settings.mediapath;
		
		// set thumb path
		this.thumbnailpath = Zanmantou3.THUMBNAILPATH || config.settings.thumbnailpath;
		
		// create new medialist		
		this.mediaList = new MediaList(list, (config.settings.shuffle=="true"));

		// assign initial settings
		this.mediaList.enableRepeatall(config.settings.repeatall=="true");
		this.mediaList.enableRepeat(config.settings.repeat=="true");
		this.mediaList.enableShuffle(config.settings.shuffle=="true");
		this.videoEngine.enableSmoothing(config.settings.smoothing=="true");
		this.videoEngine.enableStageVideo(config.settings.stagevideo=="true");
		
		// set initial pan/volume
		this.zanmantou.getSoundManager().setVolume(parseFloat(config.settings.volume));
		this.zanmantou.getSoundManager().setPan(parseFloat(config.settings.pan));
	}
	
	public function preloadThumb():void{
		// select engine
		if (this.getMediaType(this.mediaList.getCurrentItem()) == MediaManager.MEDIATYPE_AUDIO){
			this.selectAudioEngine();
		}else{
			this.selectVideoEngine();
		}
		this.engine.setThumbnail(this.thumbnailpath + this.mediaList.getCurrentItem().thumbnail);	
	}

	/**
	 * Playback Methods
	 */
	
	public function play(item:Object, position:Number = 0):void{
		// stop current playback
		if (this.engine != null){
			this.engine.stop();
		}
		
		// set pause flag
		this.isPaused = false;
		this.isPlaying = true;

		// trigger JS event
		this.zanmantou.getJSAPI().triggerEvent("play", this.mediaList.getMediaIndex() + "");
		
		// select engine
		if (this.getMediaType(item) == MediaManager.MEDIATYPE_AUDIO){
			this.selectAudioEngine();
			this.engine.play(this.mediapath + item.source);
		}else if (this.getMediaType(item) == MediaManager.MEDIATYPE_VIDEO){
			this.selectVideoEngine();
			this.engine.play(this.mediapath + item.source);
		}else{
			this.next(true);
		}	
		
	}
	
	public function start():void{
		if (this.inited && this.isPaused){
			this.resume();
		}else{
			this.play(this.mediaList.getCurrentItem());
			this.inited = true;
		}
	}
	
	public function seek(time:Number):void{
		if (this.engine != null){
			// calculate approximated timelimit
			var limit:Number = this.engine.getLength()*this.engine.getLoadingProgress();
			
			// check limit
			//if (time<limit){
				// seek if conent is loaded
				this.engine.seek(time);
			//}else{
				// otherwise if streaming is enabled load data 
			//	this.engine.stop();
			//	var current:Object = this.mediaItems[this.itemIndex];
			//	this.play(current.source + "?start="+time, current.type);
			//}
		}
	}
	
	public function stop():void{
		if (this.engine != null){
			this.engine.stop();
			this.isPlaying = false
			this.isPaused = false;
		}
	}
	
	public function pause():void{
		if (this.engine != null){
			// set pause flag
			this.isPaused = true;	
			this.isPlaying = false;
			this.engine.pause();
		}
 	}
	
	public function resume():void{
		if (this.engine != null){
			// set pause flag
			this.isPaused = false;		
			this.isPlaying = true;
			this.engine.resume();
		}
	}
	
	public function jump(index:int, play:Boolean):void{
		// try to jump to index		
		if (this.mediaList.setMediaIndex(index)){
			// store state
			var p:Boolean = this.isPlaying;
			
			// stop playback
			this.stop();
			
			// preload 
			this.preloadThumb();
			
			// restart playback ?
			if (p || play){
				this.start();
			}
		}
	}
	
	public function next(play:Boolean):void{
		// store state
		var p:Boolean = this.isPlaying;
		
		// stop playback
		this.stop();
		
		// try to jump to next item, otherwise stop
		if (!this.mediaList.nextItem()){
			p = false;
			(new StopListener(this.zanmantou)).actionPerformed(new Event("stop"));
		}

		// preload 
		this.preloadThumb();
		
		// restart playback ?
		if (p || play){
			this.start();
		}
	}
	
	public function prev(play:Boolean):void{
		// store playling state
		var p:Boolean = this.isPlaying;
		
		// stop current playback
		this.stop();
		
		// goto prev item
		this.mediaList.prevItem();

		// load next thumb
		this.preloadThumb();
		
		// restart playing ?
		if (p || play){
			this.start();
		}	
	}
	
	private function getMediaType(item:Object):int{
		if ((item.source.lastIndexOf('.f4v') != -1) || (item.source.lastIndexOf('.mp4') != -1) ||(item.source.lastIndexOf('.flv') != -1) || (item.type == 'video')){
			return MediaManager.MEDIATYPE_VIDEO;
		}else if ((item.source.lastIndexOf('.mp3') != -1) || (item.source.lastIndexOf('.wav') != -1) || (item.type == 'audio')){
			return MediaManager.MEDIATYPE_AUDIO;
		}else{
			return MediaManager.MEDIATYPE_UNKNOWN;
		}
	}
	
	/**
	 * Engine Selection
	 */
	private function selectAudioEngine():void{
		this.engine = this.audioEngine;
		this.videoEngine.visible = false;
		this.audioEngine.visible = true;
	}
	
	private function selectVideoEngine():void{
		this.engine = this.videoEngine;		
		this.audioEngine.visible = false;
		this.videoEngine.visible = true;
	}
	
	public function getEngine():Engine{
		return this.engine;
	}
	
	public function getAudioEngine():AudioEngine{
		return this.audioEngine;
	}
	
	public function getVideoEngine():VideoEngine{
		return this.videoEngine;
	}
	
	public function getMediaList():MediaList{
		return this.mediaList;
	}
	
	/**
	 * some flags
	 */
	public function storePlayingBeforeSeek():void{
		this.wasPlayingBeforeSeek = this.isPlaying;
	}
	
	public function playingBeforeSeek():Boolean{
		return this.wasPlayingBeforeSeek;
	}
	
	public function isMediaPlaying():Boolean{
		return this.isPlaying;
	}
	
	public function getMediaPath():String{
		return this.mediapath;
	}
	
	
}}