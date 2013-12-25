package org.a3non.ui.components{
	
import flash.display.*;
import flash.events.*;
import flash.text.*;
import org.a3non.zanmantou3.engines.*;
import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.event.ActionListener;        
import flash.events.TimerEvent;
import flash.utils.Timer;
import org.a3non.ui.Component;

public class Infoarea
	extends Component{		
	
	private var zanmantou:Zanmantou3;
	private var area:TextField;
	private var scrollmode:String = "reverse";
	private var scrolladd:Boolean = true;
	private var scrollstep:int;
	private var scrolldelay:int = 0;
	private var scrolldelaycount:int = 0;
	private var rawtext:String = "";
	private var htmltext:Boolean = false;
	
	public function Infoarea(cfg:XML, zanmantou:Zanmantou3){
		super();
		this.zanmantou = zanmantou;
		this.area = new TextField();
		
		// area size
		this.area.width = cfg.@width;
		this.area.height = cfg.@height;
		
		// basic setup
		this.area.mouseEnabled = false;
		this.area.multiline = false;
		this.area.antiAliasType = AntiAliasType.ADVANCED;
		
		// set text format
		var fmt:TextFormat = new TextFormat();
		fmt.color = cfg.color;
		fmt.size = cfg.size;
		fmt.align = cfg.align;
		fmt.font = cfg.font;
		fmt.letterSpacing = cfg.letterspacing;
		fmt.italic = (cfg.italic=="true");
		fmt.bold = (cfg.bold=="true");
		
		this.area.defaultTextFormat = fmt;
		this.rawtext = cfg.value + "";
		this.htmltext = (cfg.html=="true");
		
		// scrolling
		this.scrollstep = cfg.overflow.step;
		this.scrolldelay = cfg.overflow.delay;
		
		if (cfg.overflow.enable=="true"){
			var scrollTimer:Timer = new Timer(cfg.overflow.interval);
			scrollTimer.addEventListener(TimerEvent.TIMER, scrollaction);
			scrollTimer.start();
		}

        // perdiodical text update
		var refreshTimer:Timer = new Timer(cfg.refresh);
		refreshTimer.addEventListener(TimerEvent.TIMER, textupdate);
		refreshTimer.start();
        
		// add area to sprite
		this.addChild(this.area);
	}
	
	// dynamic param parser
	private function textupdate(event:TimerEvent):void{
		var txt:String = this.rawtext;
	
		// get current item
		var currentItem:Object = this.zanmantou.getMediaManager().getMediaList().getCurrentItem();
	
		// item avaible ?
		if (currentItem!=null){
			// replace param tags
			for (var key:String in currentItem.params){
				txt = txt.replace(new RegExp("{%p="+key+"}", "gi"), currentItem.params[key]);  
			}
		}
		
		// store engine
		var eng:Engine = this.zanmantou.getMediaManager().getEngine();
		var tmp:int = 0;
		
		// update dynamic values
		// time in secconds
		txt = txt.replace(new RegExp("{%L}", "g"), eng.getLength());
		txt = txt.replace(new RegExp("{%T}", "g"), eng.getTime());
		
		// time in minutes
		txt = txt.replace(new RegExp("{%l}", "g"), Math.floor(eng.getLength()/60));
		txt = txt.replace(new RegExp("{%t}", "g"), Math.floor(eng.getTime()/60));
		
		// fraction seconds with leading zero
		tmp = Math.floor(eng.getLength()%60);
		txt = txt.replace(new RegExp("{%ls}", "g"), ((tmp>9) ? tmp : "0"+tmp) );
		tmp = Math.floor(eng.getTime()%60);		
		txt = txt.replace(new RegExp("{%ts}", "g"), ((tmp>9) ? tmp : "0"+tmp) );
		
		// fps
		txt = txt.replace(new RegExp("{%fps}", "gi"), eng.getFPS());
		
		// remove unknown placeholder
		txt = txt.replace(new RegExp("{%([a-zA-Z0-9=-_]+)}", "gi"), "");
		
		// finally set text
		if (this.htmltext){
			this.area.htmlText = txt;
		}else{
			this.area.text = txt;
		}		
	}
	
	// dynamic overflow scrolling
	private function scrollaction(event:TimerEvent):void{
		if (this.scrolladd){
			// check limits
			if (this.area.scrollH >= this.area.maxScrollH){
				if (this.scrolldelaycount < this.scrolldelay){
					this.scrolldelaycount++;
				}else{
					this.scrolldelaycount = 0;
					this.scrolladd = false;
				}
			}else{
				// add step
				this.area.scrollH += this.scrollstep;				
			}
		}else{
			// check limits
			if (this.area.scrollH < 1){
				if (this.scrolldelaycount < this.scrolldelay){
					this.scrolldelaycount++;
				}else{
					this.scrolldelaycount = 0;
					this.scrolladd = true;
				}
			}else{
				// add step
				this.area.scrollH -= this.scrollstep;				
			}
		}		
	}

	
}}