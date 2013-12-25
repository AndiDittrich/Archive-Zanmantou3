package org.a3non.ui{

public class RAWComponent extends Component{

	public function RAWComponent(name:String = ""){
		super(name);
	}

	// resrict resizing
	public override function setRAWSize(x:int, y:int):void{}
	public override function setSize(x:String, y:String):void{}

}}