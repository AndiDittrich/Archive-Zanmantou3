package org.a3non.ui.components{
	
import flash.display.*;
import flash.events.*;
import org.a3non.zanmantou3.engines.*;
import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.event.ActionListener;       
import org.a3non.ui.Component;
import org.a3non.event.*;

public class Button
	extends Component
	implements ActionListener{		
	
	private var overImg:Image;
	private var outImg:Image;
	private var pressImg:Image;
	private var releaseImg:Image;
	private var activeImage:Image;
	private var clickListener:ActionListener = null;
	private var eventType:String = "click";
	private var pressed:Boolean = false;
	private var preloader:Preloader;

	public function Button(cfg:Object, imgpath:String, preloader:Preloader){
		super();
		this.preloader = preloader;
		
		// add images
		if (cfg.over.length()>0){
			preloader.addResource();
			this.overImg = new Image(imgpath + cfg.over, preloader);
			this.addComponent(this.overImg);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
		}
		if (cfg.out.length()>0){
			preloader.addResource();
			this.outImg = new Image(imgpath + cfg.out, this);
			this.addComponent(this.outImg);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		}
		if (cfg.press.length()>0){
			preloader.addResource();
			this.pressImg = new Image(imgpath + cfg.press, preloader);
			this.addComponent(this.pressImg);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onPressHandler);
		}
		if (cfg.release.length()>0){
			preloader.addResource();
			this.releaseImg = new Image(imgpath + cfg.release, preloader);
			this.addComponent(this.releaseImg);
			this.addEventListener(MouseEvent.MOUSE_UP, onReleaseHandler);
		}
		
		// click listener
		this.addEventListener(MouseEvent.MOUSE_DOWN, onClickPressHandler);
		this.addEventListener(MouseEvent.MOUSE_UP, onClickReleaseHandler);

		// hand cursor
		this.buttonMode = true;
		this.useHandCursor = true;
		
		// show only out image on startup
		this.buttonState(false, true, false, false);
    }
	
	/**
	 * set size by out image
	 */
	public function actionPerformed(e:Event):void{
		this.preloader.actionPerformed(e);
		this.getDimension().setSize(this.width, this.height);
		this.render();
	}
	
	/**
	 * Special OOP event handling
	 */
	public function setClickListener(lst:ActionListener):void{
		this.clickListener = lst;
	}
	
	/**
	 * set event type (e.g. for external actions)
	 */
	public function setEventType(type:String):void{
		if (type.length>0){
			this.eventType = type;
		}		
	}
	
	/**
	 * button state simplification
	 */
	public function buttonState(over:Boolean, out:Boolean, press:Boolean, release:Boolean):void{
		if (this.overImg != null){
			this.overImg.visible = over;
		}
		if (this.outImg != null){
			this.outImg.visible = out;
		}
		if (this.pressImg != null){
			this.pressImg.visible = press;
		}
		if (this.releaseImg != null){
			this.releaseImg.visible = release;
		}
	}
	
	/**
	 * Event Callbacks
	 */
	private function onRollOverHandler(myEvent:MouseEvent):void{
		this.buttonState(true, false, false, false);
	}

	private function onRollOutHandler(myEvent:MouseEvent):void{
		this.buttonState(false, true, false, false);
	}

	private function onPressHandler(myEvent:MouseEvent):void{
		this.buttonState(false, false, true, false);
	}

	private function onReleaseHandler(myEvent:MouseEvent):void{
		this.buttonState(false, false, false, true);
	}
	
	private function onClickPressHandler(myEvent:MouseEvent):void{
		this.pressed = true;
	}

	private function onClickReleaseHandler(myEvent:MouseEvent):void{
		if (this.pressed && this.clickListener != null){
			this.clickListener.actionPerformed(new Event(this.eventType));
		}
		this.pressed = false;
	}
	/*
	// restrict resizing
	public override function updateValues():void{
		// set values by dimension
		this.x = this.getDimension().getPositionX();
		this.y = this.getDimension().getPositionY();
		this.z = this.getDimension().getPositionZ();
	}*/
}}