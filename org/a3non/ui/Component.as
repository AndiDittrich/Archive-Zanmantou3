package org.a3non.ui{

import flash.display.Sprite;

import org.a3non.geom.*;
import org.a3non.zanmantou3.*;

/**
 * Abstract UI component
 * e.g. for parametric size/position handling
 */
public class Component extends Sprite{
	// parent component
	private var parentComponent:Component;

	// zindex
	public var zindex:int = 0;
	
	// child components
	private var childComponents:Array;

	// parametric values
	private var parametricWidth:String = "";
	private var parametricHeight:String = "";
	private var parametricPositionX:String = "";
	private var parametricPositionY:String = "";
	private var parametricPositionZ:String = "";

	// imaginary dimension
	private var idimension:Dimension;

	// rendering flag
	private var isRendered:Boolean;

	// size flag
	private var sizeIsSet:Boolean;

	// parser
	private var paramParser:ParametricParser;

	// cp name .. debug
	private var componentName:String;

	public function Component(name:String = ""){
		super();
		this.componentName = name;
		this.tabEnabled = false;
		this.isRendered = false;
		this.sizeIsSet = false;
		this.childComponents = new Array();
		this.idimension = new Dimension();
		this.paramParser = new ParametricParser(this);
	}
	
	// get cp name
	public function getName():String{
		return this.componentName;
	}

	// set rotation
	public function setRotation(x:int, y:int, z:int):void{
		if (this.rotationX != x){
			this.rotationX = x;
		}
		if (this.rotationZ != z){
			this.rotationZ = z;
		}
		if (this.rotationY != y){
			this.rotationY = y;
		}
	}
	
	public function setPosition(x:String, y:String, z:String):void{
		// set parametric values
		this.parametricPositionX = x;
		this.parametricPositionY = y;
		this.parametricPositionZ = z;
		
		// update values only if component is rendered
		if (this.isRendered){
			this.updateParametricValues();
			this.updateValues();
		}
	}
	
	public function setRAWPosition(x:int, y:int, z:int):void{
		this.idimension.setPosition(x, y, z);
		this.x = x;
		this.y = y;
		this.z = z;
		this.parametricPositionX = x + "";
		this.parametricPositionY = y + "";
		this.parametricPositionZ = z + "";
	}	
	
	public function setSize(x:String, y:String):void{
		if (x!="" && y!=""){
			// set parametric values
			this.parametricWidth = x;
			this.parametricHeight = y;
			this.sizeIsSet = true;
			
			// update values only if component is rendered
			if (this.isRendered){
				this.updateParametricValues();
				this.updateValues();
			}
		}
	}

	public function setRAWSize(x:int, y:int):void{
		this.idimension.setSize(x, y);
		this.parametricWidth = x + "";
		this.parametricHeight = y + "";
		
		if (x>0 && y>0){
			this.visible = true;
			this.width = x;
			this.height = y;
		}else{
			this.visible = false;
		}
	}
	
	public function getDimension():Dimension{
		return this.idimension;
	}
	
	public function updateValues():void{
		
		// check if parametric size is set
		if (this.sizeIsSet){
			
			//  check if valid size ist avaible
			if (this.idimension.getWidth()>0 && this.idimension.getHeight()>0){
				this.visible = true;
	
				// store rotation
				var rx:int = this.rotationX;
				var ry:int = this.rotationY;
				var rz:int = this.rotationZ;
				
				// rotate 0
				this.setRotation(0, 0, 0);
				
				// set container dimensions
				this.width = this.idimension.getWidth();
				this.height = this.idimension.getHeight();
				
				// restore rotation
				this.setRotation(rx, ry, rz);
			}else{
				this.visible = false;
			}
		}
		
		// set values by dimension
		this.x = this.idimension.getPositionX();
		this.y = this.idimension.getPositionY();
		//this.z = this.idimension.getPositionZ();
	}
	
	public function updateParametricValues():void{
		if (this.getParent() != null){
			// parse size if avaible	
			if (this.sizeIsSet){	
				// parse size
				this.idimension.setSize(this.paramParser.parseWidth(this.parametricWidth), 
										this.paramParser.parseHeight(this.parametricHeight));		
			}		

			// set new position
			this.idimension.setPosition(this.paramParser.parsePositionX(this.parametricPositionX), 
										this.paramParser.parsePositionY(this.parametricPositionY), 
										parseInt(this.parametricPositionZ));
		}
	}

		

	/**
	 * Child component handling
	 */
	public function addComponent(cp:Component):void{
		this.addChild(cp);
		this.childComponents.push(cp);
		cp.setParent(this);
	}
	public function removeComponent(cp:Component):void{
		if (cp.getParent()==this){
			removeChild(cp);
		}
		this.childComponents = this.childComponents.splice(this.childComponents.indexOf(cp), 1);	
		cp.setParent(null);
	}
	
	public function setParent(cp:Component):void{
		this.parentComponent = cp;
	}
	
	public function getParent():Component{
		return this.parentComponent;
	}
	
	/**
	 * opacity handling
	 */
	public function setOpacity(v:Number):void{
		if (!isNaN(v) && v > 0){
			this.alpha = v;
		}
	}
	
	/**
	 * zindex handling
	 */
	public function setZIndex(i:int):void{
		this.zindex = i;
	}	

	public function updateChildOrder():void{
		// sort components by zindexes
		var tmp:Array = this.childComponents.sortOn("zindex", Array.NUMERIC);
		
		// iterate through the sorted components and set childindex
		for (var i:int = 0; i < tmp.length; i++) {
			try{
				this.setChildIndex(tmp[i], i);
			}catch(error:Error){}
		}
	}
	
	/**
	 * rendering
	 */
	public function render():void{
		// set flag
		this.isRendered = true;
		
		// update child order
		this.updateChildOrder();
		
		// parse parametric values
		this.updateParametricValues();
		
		// update size, position
		this.updateValues();
		
		var i:int = 0;
		
		// render childs
		for (i = 0; i < this.childComponents.length; i++) {
			this.childComponents[i].render();			
		}
		
	}
	
}}