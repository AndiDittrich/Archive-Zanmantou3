package org.a3non.ui{
	import org.a3non.zanmantou3.Zanmantou3;

public class ContainerComponent extends Component{

	public function ContainerComponent(name:String = ""){
		super(name);
	}

	// resrict resizing
	public override function setSize(x:String, y:String):void{}
	public override function setRAWSize(x:int, y:int):void{}
	
	public override function updateValues():void{}
	
	// get parent dimension
	public override function updateParametricValues():void{
		// dimension passthrough !
		this.getDimension().setSize(this.getParent().getDimension().getWidth(), this.getParent().getDimension().getHeight());
		this.getDimension().setPosition(this.getParent().getDimension().getPositionX(), this.getParent().getDimension().getPositionY(), this.getParent().getDimension().getPositionZ());

		//Zanmantou3.trace(this.name + " - " + this.ge
		//super.updateParametricValues();
	}

	
}}