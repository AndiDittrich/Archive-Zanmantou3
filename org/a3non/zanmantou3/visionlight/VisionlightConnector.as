package org.a3non.zanmantou3.visionlight{
	import com.adobe.net.URI;
	
	public interface VisionlightConnector{
		function update(o:Object):void;
		function close():void;
	}
}