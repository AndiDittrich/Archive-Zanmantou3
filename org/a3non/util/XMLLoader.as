package org.a3non.util{
	
import flash.display.*;
import flash.events.*;
import flash.net.*;
import org.a3non.zanmantou3.Zanmantou3;

public class XMLLoader extends EventDispatcher{		
	
	private var xmlobj:XML;
	private var url:String;
	public static const COMPLETE:int = 1;
	
	public function XMLLoader(url:String){
		this.url = url;
		var myLoader:URLLoader = new URLLoader();
		myLoader.addEventListener(Event.COMPLETE, processXML);
		myLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		myLoader.load(new URLRequest(url));
	}
	
	// complete event
	private function processXML(e:Event):void {
		this.xmlobj = new XML(e.target.data);
		this.dispatchEvent(new Event(Event.COMPLETE));
	}

	// event passthrough
	private function errorHandler(e:IOErrorEvent):void {
		e.text = this.url;
		this.dispatchEvent(e);
	}
	
	// get xml data as object
	public function getXML():XML{
		return this.xmlobj;
	}
}}