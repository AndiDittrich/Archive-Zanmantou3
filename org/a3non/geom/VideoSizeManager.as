package org.a3non.geom{

public class VideoSizeManager{

	private var normalDim:VideoDimension;
	private var fullscreenDim:VideoDimension;
		
	public function VideoSizeManager(){
		this.normalDim = new VideoDimension();
		this.fullscreenDim = new VideoDimension();
	}
	
	public function setNormalDimension(dim:VideoDimension):void{
		this.normalDim = dim;
	}
	public function setFullscreenDimension(dim:VideoDimension):void{
		this.fullscreenDim = dim;
	}
	
	/**
	 * passthrough
	 */
	public function setRAWVideoSize(x:int, y:int):void{
		this.normalDim.setRAWVideoSize(x, y);
		this.fullscreenDim.setRAWVideoSize(x, y);
	}
	
	public function getSize(screensize:Dimension, fullscreen:Boolean):Dimension{
		if (fullscreen){
			return this.fullscreenDim.getSize(screensize);
		}else{
			return this.normalDim.getSize(screensize);
		}
	}
	
}}