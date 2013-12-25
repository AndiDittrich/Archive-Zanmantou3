package org.a3non.geom{

import org.a3non.math.MathString;

public class VideoDimension{

	// screen size
	private var screenWidth:int = 0;
	private var screenHeight:int = 0;

	// video raw size
	private var rawWidth:int = 0;
	private var rawHeight:int = 0;

	// parametric size
	private var parametricWidth:String = "";
	private var parametricHeight:String = "";

	// settings
	private var nativeSizing:Boolean = true;
	private var proportionalSizing:Boolean = false;
	
	public function VideoDimension(){}
	
	public function setSize(x:String, y:String):void{
		this.parametricWidth = x;
		this.parametricHeight = y;
	}
	
	public function setSizing(s:String):void{
		this.nativeSizing = (s=="native");
		this.proportionalSizing = (s=="proportional");
	}

	public function setRAWVideoSize(x:int, y:int):void{
		this.rawWidth = x;
		this.rawHeight = y;
	}
		
	public function getSize(screensize:Dimension):Dimension{
		var result:Dimension = new Dimension();
	
		// set screensize
		this.screenWidth = screensize.getWidth();
		this.screenHeight = screensize.getHeight();
		
		// calculate estimated size
		var estimatedWidth:int = this.parseWidth(this.parametricWidth);
		var estimatedHeight:int = this.parseHeight(this.parametricHeight);
		var scaling:Number = 1;

		// sizing mode native
		if (this.nativeSizing){
			// check limits
			if (this.rawWidth<=estimatedWidth && this.rawHeight<=estimatedHeight){
				// set original size
				result.setSize(this.rawWidth, this.rawHeight);
			
			// scale video	
			}else{
				// calculate scaling factor
				scaling = this.calculateProportionalScalingFactor(estimatedWidth, estimatedHeight);
				
				// set site
				result.setSize(Math.floor(scaling*this.rawWidth), Math.floor(scaling*this.rawHeight));
			}

		// proportional scaling
		}else if(this.proportionalSizing){
			// calculate scaling factor
			scaling = this.calculateProportionalScalingFactor(estimatedWidth, estimatedHeight);

			// set site
			result.setSize(Math.floor(scaling*this.rawWidth), Math.floor(scaling*this.rawHeight));
			
		// fixed mode	
		}else{
			result.setSize(estimatedWidth, estimatedHeight);
		}
		
		return result;
	}
	
	/**
	 * calculate proportional scaling factor
	 */
	private function calculateProportionalScalingFactor(limitx:int, limity:int):Number{
		var fa:Number = limitx/this.rawWidth;
		var fb:Number = limity/this.rawHeight;
	
		if (this.rawHeight*fa<limity){
			return fa;
		}else{
			return fb;
		}
	
	}
	
	/**
	 * WIDTH
	 */
	// parse width
	private function parseWidth(param:String):int{
		// replace all % values
		param = param.replace(new RegExp("([0-9]+)%", "g"), parametricWidthCallback);
		
		return (new MathString(param)).parse();
	}
	private function parametricWidthCallback():String{
		return Math.floor(parseInt(arguments[1])*this.screenWidth/100) + "";
	}
	/**
	 * HEIGHT
	 */
	// parse width
	private function parseHeight(param:String):int{
		// replace all % values
		param = param.replace(new RegExp("([0-9]+)%", "g"), parametricHeightCallback);
		
		return (new MathString(param)).parse();
	}
	private function parametricHeightCallback():String{
		return Math.floor(parseInt(arguments[1])*this.screenHeight/100) + "";
	}
	
}}