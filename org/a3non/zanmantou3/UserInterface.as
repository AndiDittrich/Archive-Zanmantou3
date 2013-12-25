package org.a3non.zanmantou3{
import flash.display.*;
import flash.events.*;
import flash.ui.*;
import flash.utils.Timer;

import org.a3non.event.*;
import org.a3non.geom.*;
import org.a3non.ui.Component;
import org.a3non.ui.components.*;
import org.a3non.util.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.listener.*;

public class UserInterface{		
	
	private var zanmantou:Zanmantou3;

	// loading img
	[Embed(source="/images/loader.swf")]
	private var LoadingImage:Class;

	// buttons
	private var buttons:Object;
	
	// slider
	private var slider:Object;
	
	// all allowed buttons
	private var allowedButtons:Array;
	
	// all allowed slider
	private var allowedSlider:Array;
	
	// buttons listener
	private var btnlistener:Object;
	
	// slider listener
	private var slidlistener:Object;
	
	// slider refreh timer
	private var refreshTimer:Timer;
	
	// default image path
	private var imgpath:String = "";
	
	// context meni items
	private var contextItems:Object;
	
	// preloader
	private var preloader:Preloader;
	
	// xml config
	private var config:XML;

	public function UserInterface(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
		
		// create loading image
		var limage:DisplayObject = new LoadingImage();
		
		// set center position of loading image: lowlevel needed
		this.zanmantou.getComponentManager().getLoadingComponent().setRAWPosition(this.zanmantou.getStage().stageWidth/2-limage.width/2, this.zanmantou.getStage().stageHeight/2-limage.height/2, 0);
		
		// add loading image
		this.zanmantou.getComponentManager().getLoadingComponent().addChild(limage);
		
		// set allowed buttons
		this.allowedButtons = new Array("start", "stop", "pause", "mute", "unmute", "next", "prev",
										"repeaton", "repeatoff", "repeatallon", "repeatalloff",
										"shuffleon", "shuffleoff", "extern", 
										"smoothingon", "smoothingoff", "fullscreenon", "fullscreenoff",
										"visionlighton", "visionlightoff");
		
		// set allowed slider
		this.allowedSlider = new Array("loading", "volume", "pan", "progress");
		
		// create button storage arrays
		this.buttons = new Object();
		this.contextItems = new Object();
		for each (var btnkey:String in this.allowedButtons){			
			this.buttons[btnkey] = new Array();
			this.contextItems[btnkey] = new Array();
		}
		
		// create slider storage array
		this.slider = new Object();
		for each (var skey:String in this.allowedSlider){			
			this.slider[skey] = new Array();
		}
		
		// create button action listener
		this.btnlistener = new Object();
		this.btnlistener.start = new StartListener(zanmantou);
		this.btnlistener.pause = new PauseListener(zanmantou);
		this.btnlistener.stop = new StopListener(zanmantou);
		this.btnlistener.next = new NextListener(zanmantou);
		this.btnlistener.prev = new PrevListener(zanmantou);
		this.btnlistener.mute = new MuteListener(zanmantou);
		this.btnlistener.unmute = new UnmuteListener(zanmantou);
		this.btnlistener.repeaton = new RepeatOnListener(zanmantou);
		this.btnlistener.repeatoff = new RepeatOffListener(zanmantou);
		this.btnlistener.repeatallon = new RepeatallOnListener(zanmantou);
		this.btnlistener.repeatalloff = new RepeatallOffListener(zanmantou);
		this.btnlistener.shuffleon = new ShuffleOnListener(zanmantou);
		this.btnlistener.shuffleoff = new ShuffleOffListener(zanmantou);
		this.btnlistener.extern = new ExternListener(zanmantou);
		this.btnlistener.fullscreenon = new FullscreenOnListener(zanmantou);
		this.btnlistener.fullscreenoff = new FullscreenOffListener(zanmantou);
		this.btnlistener.smoothingon = new SmoothingOnListener(zanmantou);
		this.btnlistener.smoothingoff = new SmoothingOffListener(zanmantou);
		this.btnlistener.visionlighton = new VisionLightOnListener(zanmantou);
		this.btnlistener.visionlightoff = new VisionLightOffListener(zanmantou);
		
		// create slider action listener
		this.slidlistener = new Object();
		this.slidlistener.volumecomplete = new VolumeCompleteListener(zanmantou);
		this.slidlistener.volumeupdate = new VolumeUpdateListener(zanmantou);
		this.slidlistener.volumestart = new VolumeStartListener(zanmantou);
		this.slidlistener.pancomplete = new PanCompleteListener(zanmantou);
		this.slidlistener.panupdate = new PanUpdateListener(zanmantou);
		this.slidlistener.panstart = new PanStartListener(zanmantou);
		this.slidlistener.progresscomplete = new ProgressCompleteListener(zanmantou);
		this.slidlistener.progressupdate = new ProgressUpdateListener(zanmantou);
		this.slidlistener.progressstart = new ProgressStartListener(zanmantou);
		
		// progress update
		this.refreshTimer = new Timer(100);
		this.refreshTimer.addEventListener(TimerEvent.TIMER, progressUpdate);
		this.refreshTimer.start();
	}
	
	public function createUI(config:XML):void{	
		// create preloader
		this.preloader = new Preloader(new ZanmantouReadyListener(zanmantou, config));
			
		// set config
		this.config = config;
		
		// set imgpath
		this.imgpath = Zanmantou3.IMAGEPATH || config.settings.imgpath;
		
		// create context menu
		this.addContextMenuItems(config.contextmenu);
		
		// creating normal ui
		var normal:Component = this.zanmantou.getComponentManager().getNormalComponent();
		this.addButtons(config.normal.buttons, normal);
		this.addImages(config.normal.images, normal);
		this.addInfoareas(config.normal.info, normal);
		this.addSlider(config.normal.slider, normal);
		this.engineSetup(config.normal.engine, this.zanmantou.getComponentManager().getNormalEngineComponent());
		
		// creating fullscreen ui
		var fullscreen:Component = this.zanmantou.getComponentManager().getFullscreenComponent();
		this.addButtons(config.fullscreen.buttons, fullscreen);
		this.addImages(config.fullscreen.images, fullscreen);
		this.addInfoareas(config.fullscreen.info, fullscreen);
		this.addSlider(config.fullscreen.slider, fullscreen);
		this.engineSetup(config.fullscreen.engine, this.zanmantou.getComponentManager().getFullscreenEngineComponent());
				
		// initial gui button settings
		this.displayButtons("pause", false);
		this.displayButtons("unmute", false);
		this.displayButtons("fullscreenoff", false);
		this.displayButtons("repeatoff", (config.settings.repeat=="true"));
		this.displayButtons("repeaton", !(config.settings.repeat=="true"));
		this.displayButtons("repeatalloff", (config.settings.repeatall=="true"));
		this.displayButtons("repeatallon", !(config.settings.repeatall=="true"));
		this.displayButtons("shuffleoff", (config.settings.shuffle=="true"));
		this.displayButtons("shuffleon", !(config.settings.shuffle=="true"));
		this.displayButtons("smoothingoff", (config.settings.smoothing=="true"));
		this.displayButtons("smoothingon", !(config.settings.smoothing=="true"));
		
		// Video + Thumb Size management
		
		// set video size
		var vsm:VideoSizeManager = this.zanmantou.getMediaManager().getVideoEngine().getVideoSizeManager();
		var asm:VideoSizeManager = this.zanmantou.getMediaManager().getAudioEngine().getVideoSizeManager();
		
		// create size obj
		var nVideoDim:VideoDimension = new VideoDimension();
		
		// set normal size
		nVideoDim.setSize(config.normal.engine.@width, config.normal.engine.@height);
		nVideoDim.setSizing(config.normal.engine.sizing);
		vsm.setNormalDimension(nVideoDim);
		asm.setNormalDimension(nVideoDim);		
		
		// create size obj
		var fVideoDim:VideoDimension = new VideoDimension();
		
		// set normal size
		fVideoDim.setSize(config.fullscreen.engine.@width, config.fullscreen.engine.@height);
		fVideoDim.setSizing(config.fullscreen.engine.sizing);
		vsm.setFullscreenDimension(fVideoDim);
		asm.setFullscreenDimension(fVideoDim);

		// finally render components
		this.zanmantou.render();
	}
	
	
	private function engineSetup(b:XMLList, container:Component):void{
		// set position + rotation
		container.setPosition(b.@x, b.@y, b.@z);
		container.setRotation(b.@rx, b.@ry, b.@rz);
		
		// set zindex
		container.setZIndex(parseInt(b.@zindex));
	}
	
	private function addButtons(config:XMLList, container:Component):void{
		// create all allowed buttons
		for each (var btnkey:String in this.allowedButtons){
			for each(var b:XML in config.child(btnkey)){
				// create new button
				var nbtn:Button = new Button(b, this.imgpath, this.preloader);
			
				// store button
				this.buttons[btnkey].push(nbtn);
				
				// add listener
				nbtn.setClickListener(this.btnlistener[btnkey]);
				
				// set position + rotation
				nbtn.setPosition(b.@x, b.@y, b.@z);
				nbtn.setRotation(b.@rx, b.@ry, b.@rz);
				
				// set zindex+opacity
				nbtn.setOpacity(b.@opacity);
				nbtn.setZIndex(parseInt(b.@zindex));
				
				// set event type
				nbtn.setEventType(b.@type);
				
				// add button to container
				container.addComponent(nbtn);
			}
		}
	}
	
	private function addContextMenuItems(config:XMLList):void{
		// create all allowed items (same as buttons)
		for each (var btnkey:String in this.allowedButtons){
			for each(var b:XML in config.child(btnkey)){
				// create new item
				var item:ContextMenuItem = new ContextMenuItem(b);
			
				// store item
				this.contextItems[btnkey].push(item);
				
				// add listener.. DIRTY...but...
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.btnlistener[btnkey].actionPerformed);
				
				// add item to menu
				this.zanmantou.getContextMenu().customItems.push(item);
			}
		}
	}
	
	private function addImages(config:XMLList, container:Component):void{
		for each(var b:XML in config.child("image")){
			// increment resource counter
			this.preloader.addResource();
			
			// create new image
			var nbtn:Image = new Image(this.imgpath + b, this.preloader);
		
			// set position + rotation
			nbtn.setPosition(b.@x, b.@y, b.@z);
			nbtn.setRotation(b.@rx, b.@ry, b.@rz);
			nbtn.setSize(b.@width, b.@height);
			
			// set zindex+opacity
			nbtn.setOpacity(b.@opacity);
			nbtn.setZIndex(parseInt(b.@zindex));

			// add image to container
			container.addComponent(nbtn);
		}
	}

	private function addSlider(config:XMLList, container:Component):void{
		for each (var btnkey:String in this.allowedSlider){
			for each(var b:XML in config.child(btnkey)){
				// create new image
				var nbtn:Slider = new Slider(b, this.imgpath, (btnkey!="loading"), this.preloader);
				this.slider[btnkey].push(nbtn);

				// set position + rotation
				nbtn.setSize(b.@width, b.@height);
				nbtn.setPosition(b.@x, b.@y, b.@z);
				nbtn.setRotation(b.@rx, b.@ry, b.@rz);
				
				// add listener
				nbtn.setCompleteListener(this.slidlistener[btnkey+"complete"]);
				nbtn.setStartListener(this.slidlistener[btnkey+"start"]);
				nbtn.setUpdateListener(this.slidlistener[btnkey+"update"]);
				

				// set zindex+opacity
				nbtn.setOpacity(b.@opacity);
				nbtn.setZIndex(parseInt(b.@zindex));

				// add image to container
				container.addComponent(nbtn);
			}				
		}
	}
	
	private function addInfoareas(config:XMLList, container:Component):void{
		for each(var b:XML in config.child("area")){
			// create new image
			var nbtn:Infoarea = new Infoarea(b, this.zanmantou);

			// set position + rotation
			nbtn.setSize(b.@width, b.@height);
			nbtn.setPosition(b.@x, b.@y, b.@z);
			nbtn.setRotation(b.@rx, b.@ry, b.@rz);
			
			// set zindex+opacity
			nbtn.setOpacity(b.@opacity);
			nbtn.setZIndex(parseInt(b.@zindex));
			
			// add image to container
			container.addComponent(nbtn);
		}
	}
	
	public function displayButtons(type:String, display:Boolean):void{
		if (this.buttons[type]){
			for each (var b:Button in this.buttons[type]){
				b.visible = display;
			}
		}
		
		
		if (this.contextItems[type]){
			for each (var c:ContextMenuItem in this.contextItems[type]){
				c.visible = display;
			}
		}
		// on change context item, check seperator
		var found:Boolean = false;
		for (var i:int=1;i<this.zanmantou.getContextMenu().customItems.length;i++){
			if (!found && this.zanmantou.getContextMenu().customItems[i].visible){
				this.zanmantou.getContextMenu().customItems[i].separatorBefore = true;
				found = true;
			}else{
				this.zanmantou.getContextMenu().customItems[i].separatorBefore = false;
			}
		}
	}
	
	public function updateSlider(type:String, value:Number):void{
		if (this.slider[type]){
			for each (var b:Slider in this.slider[type]){
				b.setValue(value);
			}
		}
	}
	
	public function enableProgressUpdate(en:Boolean):void{
		if (en){
			this.refreshTimer.start();
		}else{
			this.refreshTimer.stop();
		}
	}
	
	private function progressUpdate(event:TimerEvent):void{
		this.updateSlider("progress", this.zanmantou.getMediaManager().getEngine().getProgress());
		this.updateSlider("loading", this.zanmantou.getMediaManager().getEngine().getLoadingProgress());
	}

	
}}