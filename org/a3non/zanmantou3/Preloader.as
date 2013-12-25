package org.a3non.zanmantou3{
	
import flash.display.Sprite;
import flash.events.*;
import org.a3non.event.*;        
/**
 * preloader
 * every external resource should be registered here. finally, if all resources loaded a event is fired
 *
 */
public class Preloader
	implements ActionListener{	
	
	private var counter:int;
	private var loaded:int;
	private var onLoadCompleteListener:ActionListener;

	public function Preloader(lis:ActionListener):void{
		this.onLoadCompleteListener = lis;
		this.counter = 0;
		this.loaded = 0;
	}
	
	public function actionPerformed(e:Event):void{
		this.loaded++;
		if (this.loaded == this.counter){
			this.onLoadCompleteListener.actionPerformed(new Event("loaded"));
		}
	}
	
	public function addResource():void{
		this.counter++;
	}

	
}}