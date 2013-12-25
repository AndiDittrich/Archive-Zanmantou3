package org.a3non.zanmantou3.visionlight
{
	import com.adobe.net.URI;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import org.a3non.zanmantou3.Zanmantou3;
	import org.a3non.zanmantou3.visionlight.connector.LightNet;


	public class VisionLightManager{

		private var zanmantou:Zanmantou3;
		
		private var ambilightTimer:Timer;
		private var analyzer:ColorAnalyzer;
		private var channelOutputBuffer:Object;
		
		private var config:XML;
		
		private var enabled:Boolean = false;
		
		private var connector:VisionlightConnector;
		
		public function VisionLightManager(zanmantou:Zanmantou3){
			this.zanmantou = zanmantou;

			// create buffer object
			this.channelOutputBuffer = new Object();
					
			// create new color analyzer
			this.analyzer = new ColorAnalyzer(this.zanmantou.getMediaManager().getVideoEngine().getVideoObject());
			
			// create new timer
			this.ambilightTimer = new Timer(120, 0);
			this.ambilightTimer.addEventListener(TimerEvent.TIMER, captureAmbilightData);
		}
		
		
		public function setConfig(config:XML):void{
			if (config.settings && config.settings.visionlight){
				// enabled ?
				this.enabled = (config.settings.visionlight.enable=="true");
				
				// set dsn
				this.setDSN(config.settings.visionlight.dsn);
			}
			
		}
		
		public function setDSN(dsn:String):void{
			// create uri object
			var uri:URI = new URI(dsn);
			
			// connector already active ?
			if (this.connector){
				this.connector.close();			
			}
			
			// create connector by scheme
			switch (uri.scheme){
				
				// a3non lightnet protocol
				case 'lightnet':
					this.connector = new LightNet(uri);
					break;
				
				// default action
				default:
					Zanmantou3.error('Unknown VisionLight connector selected [' + uri.scheme + ']');
					break;
			}
			
		}
		
		public function enable(enable:Boolean):void{
			this.enabled = enable;
		}
		
		public function startCapture():void{
			this.ambilightTimer.start();		
		}
		
		public function stopCapture():void{
			this.ambilightTimer.stop();		
		}
		
		private function captureAmbilightData(evt:TimerEvent):void{
			if (this.enabled){
				this.analyzer.updateAreaSize();
				
				// capture video data
				this.analyzer.capture();

				// store data
				this.channelOutputBuffer.r = this.analyzer.getAreaColors(ColorAnalyzer.AREA_RIGHT);
				this.channelOutputBuffer.l = this.analyzer.getAreaColors(ColorAnalyzer.AREA_LEFT);
				this.channelOutputBuffer.t = this.analyzer.getAreaColors(ColorAnalyzer.AREA_TOP);
				this.channelOutputBuffer.b = this.analyzer.getAreaColors(ColorAnalyzer.AREA_BOTTOM);
				
				// send values
				if (this.connector){
					this.connector.update(this.channelOutputBuffer);				
				}
			}
		}
				
		public function getVisionLightColors():Object{
			return this.channelOutputBuffer;
		}
	}
}