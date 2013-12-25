package org.a3non.zanmantou3.visionlight.connector{
	import com.adobe.net.URI;
	import com.adobe.utils.IntUtil;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.net.*;
	
	import org.a3non.zanmantou3.Zanmantou3;
	import org.a3non.zanmantou3.visionlight.VisionlightConnector;

	public class LightNet
		implements VisionlightConnector{

		// socket connection
		private var sock:Socket;	
		
		public function LightNet(dsn:URI){
			
			// create socket
			this.sock = new Socket();
			this.sock.timeout = 10000;
			
			// add listener
			this.sock.addEventListener(Event.CLOSE, closeHandler);
			this.sock.addEventListener(Event.CONNECT, connectHandler);
			this.sock.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		
			// connect -> policy file request is automatical sended
			this.sock.connect(dsn.authority, parseInt(dsn.port));
		}

		public function close():void{
			this.sock.close();
		}
		
		public function update(data:Object):void{
			// WHITE : 255, 115, 70
			//this.write(r[0] + "," + (r[1]*115/255) + "," + (r[2]*70/255) + ", 0, 0, 0, " + l[0] + "," + (l[1]*115/255) + "," + (l[2]*70/255));
			

			this.sock.writeUTFBytes('{"action":"update","append":true,"device":"/dev/ttyUSB0","auth":"","steps":[{"time":100,"fade":true,"data":[{"offset":0,"sequence":['+data+']}]}]}'+ "\r\n");	
			this.sock.flush();
		}
		
		private function connectHandler(event:Event):void {
			Zanmantou3.trace("Ambilight CONNECT " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Zanmantou3.trace("Ambilight IOERROR " + event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Zanmantou3.trace("Ambilight SECURITYERROR " + event);
		}
		private function closeHandler(event:Event):void {
			Zanmantou3.trace("Ambilight CLOSE " + event);
		}
	}
}