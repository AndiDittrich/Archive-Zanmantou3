package org.a3non.zanmantou3.visionlight{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.*;
	
	import org.a3non.zanmantou3.Zanmantou3;
	import org.a3non.zanmantou3.engines.VideoEngine;
	
	/**
	 * 
	 * NOTE: BUG INTO BitmapData class..content is always scaled to origin size of video object
	 * 
	 */ 
	public class ColorAnalyzer{
	
		private var video:Video;
		private var buffer0:BitmapData;
		private var buffer1:BitmapData;
		private var resizeMatrix:Matrix;
		private var areaSize:int = 40;
		private var resizeTransformMatrix:Matrix;
		private var area:Vector.<Rectangle>;
		
		public static const AREA_LEFT:int = 0;
		public static const AREA_RIGHT:int = 1;
		public static const AREA_TOP:int = 2;
		public static const AREA_BOTTOM:int = 3;		
		
		
		public function ColorAnalyzer(video:Video){
			// store video object
			this.video = video;
			
			// create empty bitmap obj -> 25px mean value buffer
			//this.buffer0 = new BitmapData(5, 5);   
			this.buffer0 = new BitmapData(VideoEngine.VIDEO_OBJECT_SIZE_X, VideoEngine.VIDEO_OBJECT_SIZE_Y);
			
			// initialize areas
			this.area = new Vector.<Rectangle>(4);
			
			// initialize elements
			this.updateAreaSize();
		}
		
		// update capture area size
		public function updateAreaSize():void{

			/*this.area[ColorAnalyzer.AREA_LEFT] = new Rectangle(0, 0, this.areaSize, this.video.height);
			this.area[ColorAnalyzer.AREA_RIGHT] = new Rectangle(this.video.width-this.areaSize, 0, this.areaSize, this.video.height);			
			this.area[ColorAnalyzer.AREA_TOP] = new Rectangle(0, 0, this.video.width, this.areaSize);
			this.area[ColorAnalyzer.AREA_BOTTOM] = new Rectangle(0, this.video.height-this.areaSize, this.video.width, this.video.height);
			*/

			// bug-workaround -> use fixed video size
			this.area[ColorAnalyzer.AREA_LEFT] = new Rectangle(0, 0, this.areaSize, VideoEngine.VIDEO_OBJECT_SIZE_Y);
			this.area[ColorAnalyzer.AREA_RIGHT] = new Rectangle(VideoEngine.VIDEO_OBJECT_SIZE_X-this.areaSize, 0, this.areaSize, VideoEngine.VIDEO_OBJECT_SIZE_Y);			
			this.area[ColorAnalyzer.AREA_TOP] = new Rectangle(0, 0, this.video.width, this.areaSize);
			this.area[ColorAnalyzer.AREA_BOTTOM] = new Rectangle(0, VideoEngine.VIDEO_OBJECT_SIZE_Y-this.areaSize, VideoEngine.VIDEO_OBJECT_SIZE_X, VideoEngine.VIDEO_OBJECT_SIZE_Y);

		}
		
		public function capture():void{			
			// take snapshot -> rawdata
			this.buffer0.draw(this.video);		
		}
		
		/**
		 * get area color mean value by location
		 */
		public function getAreaColors(location:int):Array{
			try{
				// resize transfomation on destination bitmap size -> 5x5 AND move to (0,0)
				//this.resizeTransformMatrix = new Matrix(this.buffer0.width/this.area[location].width,0, 0, this.buffer0.height/this.area[location].height, 0, 0);
				
				//var tm:Matrix = new Matrix(1,0,0,1, -this.area[location].x, -this.area[location].y);
				// take snapshot -> rawdata
				// this.buffer0.draw(this.video, new Matrix(), null, null, this.area[location]);	

			
				// move to (0,0)
				//this.buffer0.scroll( -this.area[location].x, -this.area[location].y);
				
				//var rs:Matrix = new Matrix();
				//rs.scale(1/50, 1/50);
								
					
				//this.buffer0.draw(this.video, resizeTransformMatrix, null, null, this.area[location]);
				
				var redValue:int = 0;
				var greenValue:int =0;
				var blueValue:int=0;

				var count:int = this.area[location].width*this.area[location].height;

				// integrate snapshot
				for (var x:int=this.area[location].x;x<this.area[location].width+this.area[location].x;x++){
					for (var y:int=this.area[location].y;y<this.area[location].height+this.area[location].y;y++){
						// get pixel
						var pixelValue:uint = buffer0.getPixel32(x, y);
						if (pixelValue>0){
							redValue += pixelValue >> 16 & 0xFF;
							greenValue += pixelValue >> 8 & 0xFF;
							blueValue += pixelValue & 0xFF;						
						}else{
							count--;							
						}
					}
				}

				// prevent division by zero
				if (count>0){
					// mean values
					redValue = redValue/count;
					greenValue = greenValue/count;
					blueValue = blueValue/count;
				}
				
				return new Array(redValue, greenValue, blueValue);
			}catch(exc:Error){
				Zanmantou3.trace("Ambilight Processing Error: "+ exc + " - location: " + location);
			}	
			return new Array(0, 0, 0);
		}
	}
}