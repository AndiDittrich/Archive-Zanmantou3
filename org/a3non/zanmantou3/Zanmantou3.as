package org.a3non.zanmantou3{
import com.adobe.fileformats.vcard.Address;

import flash.display.*;
import flash.display.Sprite;
import flash.events.*;
import flash.external.ExternalInterface;
import flash.media.Video;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;

import org.a3non.ui.ContainerComponent;
import org.a3non.ui.components.*;
import org.a3non.util.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.listener.*;
import org.a3non.zanmantou3.visionlight.VisionLightManager;

        
public class Zanmantou3 
	extends ContainerComponent{		
			
	// VERSION
	public static var VERSION:String = "3.1.1";
	
	// config url
	public static var CONFIGURL:String = "config.xml";
	
	// tracklist url
	public static var LISTURL:String = "medialist.xml";
	
	// mediapath OVERWRITE
	public static var MEDIAPATH:String = null;
	
	// imagepath OVERWRITE
	public static var IMAGEPATH:String = null;
	
	// thumbnail OVERWRITE
	public static var THUMBNAILPATH:String = null;
	
	// static zamantout
	private static var INSTANCE:Zanmantou3 = null;
	
	// debug ?
	public static var debug:Boolean = false;
	
	// sound manager
	private var soundManager:SoundManager;
	
	// media manager
	private var mediaManager:MediaManager;
	
	// component manager
	private var componentManager:ComponentManager;
	
	// javascript api
	private var jsapi:JavascriptAPI;
	public static var traceInstance:JavascriptAPI;
	
	// gui
	private var gui:UserInterface;
	
	// loader
	private var configloader:XMLLoader;
	private var tracklistloader:XMLLoader;
	private var loaderCount:int = 0;
	
	// context menu
	private var menu:ContextMenu;
	
	private var visionlightManager:VisionLightManager;
		
	public function Zanmantou3(){
		super();
		
		Zanmantou3.INSTANCE = this;
		
		// context menu setup
		this.menu = new ContextMenu();
		this.menu.hideBuiltInItems();
		var zanmantouLink:ContextMenuItem = new ContextMenuItem("Zanmantou " + Zanmantou3.VERSION + " WebAVPlayer");
		zanmantouLink.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openZanmantouURL);
		this.menu.customItems.push(zanmantouLink);
		contextMenu = this.menu;        	
		
		// no scaling
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		// max quality
		stage.quality = StageQuality.BEST;
		
		// align
		stage.align = StageAlign.TOP_LEFT;

		// stage resize handling
		stage.addEventListener(Event.RESIZE, resizeHandler);
		stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullscreenHandler);
		
		var javascriptEnabled:Boolean = false;        
		
		// try to parse params
		try {
    	    var keyStr:String;
    	    var valueStr:String;
    	    var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
    	    for (keyStr in paramObj) {
    	        valueStr = String(paramObj[keyStr]);

    	        if (keyStr=="config" || keyStr=="c"){
    	        	Zanmantou3.CONFIGURL = valueStr;
    	        }
    	        if (keyStr=="list" || keyStr=="l"){
    	        	Zanmantou3.LISTURL = valueStr;
    	        }
				if (keyStr=="mediapath" || keyStr=="m"){
					Zanmantou3.MEDIAPATH = valueStr;
				}
				if (keyStr=="imagepath" || keyStr=="i"){
					Zanmantou3.IMAGEPATH = valueStr;
				}
				if (keyStr=="thumbnailpath" || keyStr=="t"){
					Zanmantou3.THUMBNAILPATH = valueStr;
				}
				if (keyStr=="js" && valueStr=="true"){
					javascriptEnabled = true;
				}
				if (keyStr=="debug" && valueStr=="true"){
					Zanmantou3.debug = true;
				}
    	    }
    	}catch(error:Error){}
        
    	// create component manager
        this.componentManager = new ComponentManager(this);
		
		// add component manager to root content container
        this.addComponent(this.componentManager);
    	
    	// create sound manager
    	this.soundManager = new SoundManager(this);
        	
        // create js api
    	this.jsapi = new JavascriptAPI(this, javascriptEnabled);
    	Zanmantou3.traceInstance = this.jsapi;
		
		// show version
		Zanmantou3.trace("Zanmantou3 - Version:" + Zanmantou3.VERSION);
        
    	// create media manager
    	this.mediaManager = new MediaManager(this);
    	
    	// create UI
    	this.gui = new UserInterface(this);

		// create new ambilight connector
		// this.visionlightManager = new VisionLightManager(this);

    	// load gui & config & tracklist & trackmanager
		this.configloader = new XMLLoader(Zanmantou3.CONFIGURL);
		this.configloader.addEventListener(Event.COMPLETE, configLoaded);
		this.configloader.addEventListener(IOErrorEvent.IO_ERROR, XMLLoadingError);
		
		this.tracklistloader = new XMLLoader(Zanmantou3.LISTURL);
		this.tracklistloader.addEventListener(Event.COMPLETE, configLoaded);
		this.tracklistloader.addEventListener(IOErrorEvent.IO_ERROR, XMLLoadingError);
    }
	
	public function XMLLoadingError(e:IOErrorEvent):void{
		// build message
		var msg:String = "ERROR: unable to load XML file <" + e.text + ">";
		
		// display messages (console + screen)
		Zanmantou3.fatal(msg);
		Zanmantou3.error(msg);
	}
	
	public function enableFullscreen(e:Boolean):void{
		if (e){
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}else{
			stage.displayState = StageDisplayState.NORMAL;
		}
	}

	// render on resize
	private function resizeHandler(event:Event):void {
		this.render();
	}
	
	// contect menu
	public function getContextMenu():ContextMenu{
		return this.menu;
	}
	
	// handle fullscreen off
	private function fullscreenHandler(event:FullScreenEvent):void{
		// swap buttons if user left fullscreen by pressing esc
		if (!event.fullScreen){
			(new FullscreenOffListener(this).actionPerformed(new Event("fullscreenoff")));
		}
		
		// render
		this.render();
	}

	private function configLoaded(e:Event):void{
		// increment loader count
		this.loaderCount++;
		
		// if config + tracklist loaded, initilize gui..
		if (this.loaderCount==2){
			this.mediaManager.setConfig(this.configloader.getXML(), this.tracklistloader.getXML());
			
			// set ambiligth config
			//this.visionlightManager.setConfig(this.configloader.getXML());
			
			// create user interface
			this.gui.createUI(this.configloader.getXML());
			
			// preload thumbs
			this.mediaManager.preloadThumb();
		}
	}

	public function getVisionLightManager():VisionLightManager{
		return this.visionlightManager;
	}
	
	public function getMediaManager():MediaManager{
		return this.mediaManager;
	}

	public function getSoundManager():SoundManager{
		return this.soundManager;
	}
	
	public function getComponentManager():ComponentManager{
		return this.componentManager;
	}
	
	public function getJSAPI():JavascriptAPI{
		return this.jsapi;
	}
	
	public function getUserInterface():UserInterface{
		return this.gui;
	}
	
	private function openZanmantouURL(e:ContextMenuEvent):void{
		navigateToURL(new URLRequest("http://zanmantou.a3non.org/ref/" + Zanmantou3.VERSION));
	}
	
	// trace
	public static function trace(msg:String):void{
		// on debug -> display direct
		if (Zanmantou3.debug){
			ExternalInterface.call('console.log', msg);			
		}else{
			Zanmantou3.traceInstance.triggerEvent("trace", msg);
		}
	}
	
	// error
	public static function error(msg:String):void{
		// on debug -> display direct
		if (Zanmantou3.debug){
			ExternalInterface.call('console.error', msg);			
		}else{
			Zanmantou3.traceInstance.triggerEvent("error", msg);
		}
	}
	
	// fatal error
	public static function fatal(txt:String):void{
		// create text display
		var msg:TextField = new TextField();
		msg.width = 500;
		msg.height = 20;
		msg.background = true;
		msg.backgroundColor = 0xffd2d2;
		msg.border = true;
		msg.borderColor = 0xFF0000;
		
		// set text format
		var fmt:TextFormat = new TextFormat();
		fmt.color = 0x000000;
		fmt.size = 12;
		fmt.font = "Arial";
		fmt.bold = true;
		msg.defaultTextFormat = fmt;

		// set text
		msg.text = txt;
		
		// show error
		Zanmantou3.INSTANCE.addChild(msg);
	}
	
	// overload render
	public override function render():void{
		// set size
		this.getDimension().setSize(stage.stageWidth, stage.stageHeight);

		// render
		super.render();
	}
	
	// restrict update
	public override function updateParametricValues():void{}
	
	// get stage
	public function getStage():Stage{	
		return stage;
	}
	
}}