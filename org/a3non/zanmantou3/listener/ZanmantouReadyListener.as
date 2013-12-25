package org.a3non.zanmantou3.listener{
	import flash.events.*;
	import flash.sampler.getGetterInvocationCount;
	
	import org.a3non.event.ActionListener;
	import org.a3non.zanmantou3.Zanmantou3;

	public class ZanmantouReadyListener
		implements ActionListener{
		
		private var zanmantou:Zanmantou3;
		private var config:XML;
		
		public function ZanmantouReadyListener(zanmantou:Zanmantou3, config:XML){
			this.zanmantou = zanmantou;
			this.config = config;
		}
		
		public function actionPerformed(e:Event):void{
			// hide loading component
			this.zanmantou.getComponentManager().getLoadingComponent().visible = false;
			
			// show normal component (player)
			this.zanmantou.getComponentManager().getNormalComponent().visible = true;
			
			// initial slider settings
			this.zanmantou.getUserInterface().updateSlider("volume", parseFloat(this.config.settings.volume));
			this.zanmantou.getUserInterface().updateSlider("pan", (parseFloat(this.config.settings.pan)+1)/2);
			
			// trigger init event
			this.zanmantou.getJSAPI().flashready();
			
			// autostart
			if (this.config.settings.autostart=="true"){
				(new StartListener(this.zanmantou)).actionPerformed(new Event("start"));
			}
		}
	}
}