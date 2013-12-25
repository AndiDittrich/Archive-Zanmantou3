package org.a3non.ui.components{
	
import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.text.TextField;

import org.a3non.event.ActionListener;
import org.a3non.ui.Component;
import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.events.*;

public class Slider
	extends Component{		
	
	private var handle:Button;
	private var progress:Component;

	private var progressImage:Image;
	private var progressCrop:Component;

	private var value:Number = 0;
	
	private var zanmantou:Zanmantou3;

	private var updateListener:ActionListener = null;
	private var startListener:ActionListener = null;
	private var completeListener:ActionListener = null;

	private var progressScale:Boolean = true;

	private var spaceMouseHolder:TextField;
	private var preloader:Preloader;

	public function Slider(cfg:XML, imgpath:String, handcursor:Boolean, preloader:Preloader){
		super();
		this.preloader = preloader;
		
		// dirty but....
		this.spaceMouseHolder = new TextField();
		this.spaceMouseHolder.mouseEnabled = false;
		this.addChild(this.spaceMouseHolder);
		
		// use handle ?
		if (cfg.handle){
			// create handle
			this.handle = new Button(cfg.handle, imgpath, preloader);
			this.handle.setRAWPosition(0, 0, 0);
	
			// drag events
			this.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			this.addEventListener(MouseEvent.MOUSE_UP, noDrag);
	
			// handle hover
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
		}
		
		// scale progress image ?
		this.progressScale = (cfg.mode=="scale");

		// add img resource
		preloader.addResource();
		
		// if scaling enabled, direct create image
		if (this.progressScale){
			// create progress image
			this.progress = new Image(imgpath + cfg.@source, preloader);
			this.progress.setRAWSize(0, 0);
		}else{
			this.progress = new Component();
			
			// otherwise create 2 images 
			this.progress.blendMode = BlendMode.LAYER;
			
			this.progressImage = new Image(imgpath + cfg.@source, preloader);
			this.progress.addComponent(this.progressImage);
			
			this.progressCrop = new Component();

			this.progressCrop.blendMode = BlendMode.ERASE;

			this.progress.addComponent(this.progressCrop);
		}
		
		// use handcursor
		if (handcursor){
			// hand cursor
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
		}
		
		// add components
		this.addComponent(this.progress);
		this.addComponent(this.handle);
	}
	
	/**
	 * events
	 */
	public function setValue(pos:Number):void{
		// store value
		this.value = pos;
	
		// limit pos
		pos = (pos>1) ? 1 : pos;
		pos = (pos<0) ? 0 : pos;
		
		if (this.progressScale){
			// set progresss
			this.progress.setRAWSize(pos*this.getDimension().getWidth(), this.progress.height);
		}else{
			// draw blending rect
			this.progressCrop.graphics.clear();
			this.progressCrop.graphics.beginFill(0xFFFFFF);
			this.progressCrop.graphics.drawRect((pos*this.getDimension().getWidth()), -1, (1-pos)*this.getDimension().getWidth()+1, this.getDimension().getHeight()+1);
		}
		
		// check if handle is avaible
		if (this.handle){
			var max:int = this.getDimension().getWidth()-this.handle.width;
			
			var newpos:int = pos*this.getDimension().getWidth() - this.handle.width/2;
			newpos = (newpos<max) ? newpos : max;
			newpos = (newpos>0) ? newpos : 0;
					
			this.handle.x = newpos;
		}
	}
	public function getValue():Number{
		return this.value;
	}
	
	public function setStartListener(lis:ActionListener):void{
		this.startListener = lis;
	}
	public function setCompleteListener(lis:ActionListener):void{
		this.completeListener = lis;
	}
	public function setUpdateListener(lis:ActionListener):void{
		this.updateListener = lis;
	}
	/**
	 * drag events
	 */
	private function drag(event:MouseEvent):void {
		this.startListener.actionPerformed(new Event("start"));
		this.handle.buttonState(false, false, true, false);
		this.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		this.addEventListener(MouseEvent.ROLL_OUT, noDrag);
		this.onDrag(event);
	}

	private function noDrag(event:MouseEvent):void {		
		this.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		this.removeEventListener(MouseEvent.ROLL_OUT, noDrag);
		this.handle.buttonState(false, false, false, true);
		this.completeListener.actionPerformed(new ValueEvent("complete", this.value));
	}

	private function onDrag(event:MouseEvent):void {
		this.setValue(event.localX/this.getDimension().getWidth());
		this.updateListener.actionPerformed(new ValueEvent("update", this.value));
	}
	
	/**
	 * hover effect
	 */
	private function onRollOverHandler(myEvent:MouseEvent):void{
		this.handle.buttonState(true, false, false, false);
	}

	private function onRollOutHandler(myEvent:MouseEvent):void{
		this.handle.buttonState(false, true, false, false);
	}
	
	/**
	 * overloading
	 */
	public override function render():void{
		// render
		super.render();
		
		if (!this.progressScale){
			// draw blending rect
			this.progressCrop.graphics.clear();
			this.progressCrop.graphics.beginFill(0xFFFFFF);
			this.progressCrop.graphics.drawRect((this.value*this.getDimension().getWidth()), -1, (1-this.value)*this.getDimension().getWidth()+1, this.getDimension().getHeight()+1);
		}

		// set space size
		this.spaceMouseHolder.width = this.getDimension().getWidth();
		this.spaceMouseHolder.height = this.getDimension().getHeight();		
	}
	
	// restrict resizing
	public override function updateValues():void{
		// set values by dimension
		this.x = this.getDimension().getPositionX();
		this.y = this.getDimension().getPositionY();
		this.z = this.getDimension().getPositionZ();
	}
}}