package org.a3non.geom{
	import flash.geom.Rectangle;

public class Dimension{
	
	// imaginary values
	private var iwidth:int = -1;
	private var iheight:int = -1;
	private var ipositionx:int = 0;
	private var ipositiony:int = 0;
	private var ipositionz:int = 0;
	private var viewport:Rectangle;

	public function Dimension(iwidth:int = 0, iheight:int =  0, ipositionx:int = 0, ipositiony:int = 0, ipositionz:int = 0){
		this.iwidth = iwidth;
		this.iheight = iheight;
		this.ipositionx = ipositionx;
		this.ipositiony = ipositiony;
		this.ipositionz = ipositionz;
	}
	
	public function setWidth(iwidth:int):void{
		this.iwidth = iwidth;
	}
	public function setHeight(iheight:int):void{
		this.iheight = iheight;
	}
	public function setSize(iwidth:int, iheight:int):void{
		this.iwidth = iwidth;
		this.iheight = iheight;
	}
	public function setPositionX(ipositionx:int):void{
		this.ipositionx = ipositionx;
	}
	public function setPositionY(ipositiony:int):void{
		this.ipositiony = ipositiony;
	}
	public function setPositionZ(ipositionz:int):void{
		this.ipositionz = ipositionz;
	}
	public function setPosition(ipositionx:int, ipositiony:int, ipositionz:int):void{
		this.ipositionx = ipositionx;
		this.ipositiony = ipositiony;
		this.ipositionz = ipositionz;
	}
	
	public function getWidth():int{
		return this.iwidth;
	}
	public function getHeight():int{
		return this.iheight;
	}
	public function getPositionX():int{
		return this.ipositionx;
	}
	public function getPositionY():int{
		return this.ipositiony;
	}
	public function getPositionZ():int{
		return this.ipositionz;
	}
	public function getViewport():Rectangle{
		this.viewport = new Rectangle(this.ipositionx, this.ipositiony, this.iwidth, this.iheight);

		return this.viewport;
	}
	
}}