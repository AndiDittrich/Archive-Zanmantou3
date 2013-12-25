package org.a3non.geom{
	
import org.a3non.math.MathString;
import org.a3non.ui.*;
/**
 * Some utilities to handle equations/math strings
 * 
 */
public class ParametricParser{		
	
	private var component:Component;
	
	public function ParametricParser(c:Component){
		this.component = c;
	}
	
	/**
	 * POSITION X
	 */
	// parse x position
	public function parsePositionX(param:String):int{
		// replace all % values
		param = param.replace(new RegExp("([0-9]+)%", "g"), parametricPositionXCallback);
		param = param.replace(new RegExp("center", "g"), parametricPositionXCenterCallback);
		param = param.replace(new RegExp("left", "g"), "0");
		param = param.replace(new RegExp("right", "g"), parametricPositionXRightCallback);
		
		return (new MathString(param)).parse();
	}
	
	// calculate x position by parent width
	private function parametricPositionXCallback():String{
		return Math.floor(parseInt(arguments[1])*this.component.getParent().getDimension().getWidth()/100) + "";
	}
	private function parametricPositionXCenterCallback():String{
		var tmp:String = arguments[0];
		return Math.floor((Math.round(0.5*this.component.getParent().getDimension().getWidth())-this.component.getDimension().getWidth()/2)) + "";
	}
	private function parametricPositionXRightCallback():String{
		var tmp:String = arguments[0];
		return Math.floor((this.component.getParent().getDimension().getWidth()-this.component.getDimension().getWidth())) + "";
	}
	
	/**
	 * POSITION Y
	 */
	// parse y position
	public function parsePositionY(param:String):int{
		// replace all % values
		param = param.replace(new RegExp("([0-9]+)%", "g"), parametricPositionYCallback);
		param = param.replace(new RegExp("center", "g"), parametricPositionYCenterCallback);
		param = param.replace(new RegExp("top", "g"), "0");
		param = param.replace(new RegExp("bottom", "g"), parametricPositionYBottomCallback);
		
		return (new MathString(param)).parse();
	}
	
	// calculate x position by parent width
	private function parametricPositionYCallback():String{
		return Math.floor(parseInt(arguments[1])*this.component.getParent().getDimension().getHeight()/100) + "";
	}
	private function parametricPositionYCenterCallback():String{
		var tmp:String = arguments[0];
		return Math.floor((Math.round(0.5*this.component.getParent().getDimension().getHeight())-this.component.getDimension().getHeight()/2)) + "";
	}
	private function parametricPositionYBottomCallback():String{
		var tmp:String = arguments[0];
		return Math.floor((this.component.getParent().getDimension().getHeight()-this.component.getDimension().getHeight())) + "";
	}
	
	/**
	 * WIDTH
	 */
	// parse width
	public function parseWidth(param:String):int{
		// replace all % values
		param = param.replace(new RegExp("([0-9]+)%", "g"), parametricWidthCallback);
		
		return (new MathString(param)).parse();
	}
	private function parametricWidthCallback():String{
		return Math.floor(parseInt(arguments[1])*this.component.getParent().getDimension().getWidth()/100) + "";
	}
	/**
	 * HEIGHT
	 */
	// parse width
	public function parseHeight(param:String):int{
		// replace all % values
		param = param.replace(new RegExp("([0-9]+)%", "g"), parametricHeightCallback);
		
		return (new MathString(param)).parse();
	}
	private function parametricHeightCallback():String{
		return Math.floor(parseInt(arguments[1])*this.component.getParent().getDimension().getHeight()/100) + "";
	}

}}