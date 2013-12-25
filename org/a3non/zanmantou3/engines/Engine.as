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
import org.a3non.geom.Dimension;
import org.a3non.geom.VideoSizeManager;
import org.a3non.ui.Component;
import org.a3non.ui.ContainerComponent;
import org.a3non.ui.components.Image;
import org.a3non.zanmantou3.SoundManager;
import org.a3non.zanmantou3.Zanmantou3;
import org.a3non.zanmantou3.engines.*;
        
public class Engine
	extends ContainerComponent
	implements ActionListener{
	
	// zanmantou object
	protected var zanmantou:Zanmantou3;
	private var sizeManager:VideoSizeManager;
	
	// thumbnail container
	private var thumbnail:Sprite;
	
	private var thumbnailLoaded:Boolean;
	
	// listener
	protected var mediaCompleteListener:ActionListener;
	protected var mediaErrorListener:ActionListener;
	
	public function Engine(zanmantou:Zanmantou3){
		super("engine");
		
		// store zanamntou instance
		this.zanmantou = zanmantou;
		
		// new size manager
		this.sizeManager = new VideoSizeManager();
		
		// thumnbail
		this.thumbnail = new Sprite();
		this.addChild(this.thumbnail);
		this.thumbnailLoaded = false;
	}
	
	public function play(url:String, position:Number=0):void{};
	public function pause():void{};
	public function stop():void{};
	public function seek(position:Number):void{};
	public function resume():void{};
	
	public function setMediaCompleteListener(lis:ActionListener):void{
		this.mediaCompleteListener = lis;
	}
	
	public function setMediaErrorListener(lis:ActionListener):void{
		this.mediaErrorListener = lis;
	}	
	
	public function setThumbnail(url:String):void{
		this.removeChild(this.thumbnail);
		
		// load new thumb
		this.thumbnailLoaded = false;
		this.thumbnail = (new Image(url, this));
		this.thumbnail.visible = true;
		this.addChild(this.thumbnail);
	}	

	public function showThumb(show:Boolean):void{
		if (this.thumbnail){
			this.thumbnail.visible = show;
		}
	}
	
	public function isThumbVisible():Boolean{
		return (this.thumbnail && this.thumbnail.visible);		
	}
	
	// on thumb load
	public function actionPerformed(evt:Event):void{
		// set real thumb size
		this.sizeManager.setRAWVideoSize(this.thumbnail.width, this.thumbnail.height);
		
		// set loaded flag
		this.thumbnailLoaded = true;
		
		// calculate size
		this.calculateSize();
		
		// rerender ui
		this.zanmantou.render();
	}
	
	public function getVideoSizeManager():VideoSizeManager{
		return this.sizeManager;
	}
	
	public function getLength():int{
		return 0;
	}
	public function getTime():int{
		return 0;
	}
	public function getProgress():Number{
		return 0;
	}
	public function getLoadingProgress():Number{
		return 0;
	}
	
	public function getFPS():int{
		return 0;
	}
	
	protected function calculateSize():void{
		// calculate size
		var x:int = 0;
		var y:int = 0;
		
		// get video size by manager
		var videoSize:Dimension = this.sizeManager.getSize(this.zanmantou.getDimension(), this.zanmantou.getComponentManager().isFullscreenActive());

		// extract values
		x = videoSize.getWidth();
		y = videoSize.getHeight();

		// thumbnail avaible ?
		if (this.thumbnailLoaded){
			// update size
			this.thumbnail.width = x+12;
			this.thumbnail.height = y+12;
		}

		// update container size..dirty but....
		this.getDimension().setSize(x, y);
		this.zanmantou.getComponentManager().getFullscreenEngineComponent().getDimension().setSize(x, y);
		this.zanmantou.getComponentManager().getFullscreenEngineComponent().updateParametricValues();
		this.zanmantou.getComponentManager().getFullscreenEngineComponent().updateValues();
		this.zanmantou.getComponentManager().getNormalEngineComponent().getDimension().setSize(x, y);
		this.zanmantou.getComponentManager().getNormalEngineComponent().updateParametricValues();
		this.zanmantou.getComponentManager().getNormalEngineComponent().updateValues();
	}
	
	public function getSizeManager():VideoSizeManager{
		return this.sizeManager;	
	}
	
	public override function render():void{
		this.calculateSize();
		super.render();
	}
}}