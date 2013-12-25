package org.a3non.ui.components{

import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.net.*;

import org.a3non.event.*;
import org.a3non.ui.Component;
import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.engines.*;

public class Image
	extends Component{		
	
	// url
	private var url:String;
	
	// clearing area
	private var clearingArea:Component;
	
	// loader
	private var imgloader:Loader
	
	// onload listener
	private var loadlistener:ActionListener;
	
	public function Image(url:String, loadlistener:ActionListener=null){
		super();
		
		// store url
		this.url = url;

		// store listener
		this.loadlistener = loadlistener;
		
		// load image
		this.imgloader = new Loader();
		this.imgloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIMGReady);
		this.imgloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIMGFailure);
		this.imgloader.load(new URLRequest(url));
		
		// set blend mode
		this.blendMode = BlendMode.LAYER;
   }
	
	// clears specific area -> e.g. use background images with StageVideo !
	public function clearArea(rec:Rectangle):void{
		// draw blending rect
		this.clearingArea.graphics.clear();
		
		// draw rec ?
		if (rec){
			this.clearingArea.graphics.beginFill(0xFFFFFF);
			this.clearingArea.graphics.drawRect(rec.x, rec.y, rec.width, rec.height);
		}
	}
	
	// event passthrough
	private function onIMGFailure(e:Event):void{
		// trace error
		Zanmantou3.error("image not found: <" + this.url + ">");
		
		// fire event
		if (this.loadlistener!=null){
			this.loadlistener.actionPerformed(new Event("load"));
		}		
	}
	
	private function onIMGReady(e:Event):void{
		// trace
		Zanmantou3.trace("image loaded: <" + this.url + ">");
		
		// add image
		this.addChild(this.imgloader.content);
		
		// set image container dimensions
		this.getDimension().setSize(this.width, this.height);
		
		// render on load
		this.render();
		
		// fire event
		if (this.loadlistener!=null){
			this.loadlistener.actionPerformed(new Event("load"));
		}
	}

}}