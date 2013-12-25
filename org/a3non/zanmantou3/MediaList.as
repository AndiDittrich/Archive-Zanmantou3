package org.a3non.zanmantou3{


public class MediaList{

	// MediaItems
	private var mediaItems:Array = new Array();
	private var itemIndex:int = 0;
	
	// settings
	private var repeat:Boolean = false;
	private var repeatall:Boolean = false;
	private var shuffle:Boolean = false;

	// generate medialist by xml file
	public function MediaList(items:XML, shuffle:Boolean){
		this.mediaItems = new Array();
		for each(var item:XML in items.child("item")){
			var nitem:Object = new Object();
			nitem.source = "" + item.@source;
			nitem.type = "" + item.@type;
			nitem.streaming = (item.@streaming=="true");
			nitem.thumbnail = item.thumbnail;
			
			// add params
			nitem.params = new Object();
			for each(var p:XML in item.child("param")){
				nitem.params[p.@name] = "" + p;
			}
			
			this.mediaItems.push(nitem);
		}
		
		// initial shuffle ?
		if (shuffle){
			this.itemIndex = (Math.floor(Math.random() * this.mediaItems.length));
		}
	}
	
	/**
	 * media list manipulations
	 */
	public function addMediaItem(index:int, nitem:Object):void{
		if (index>=0 && index < this.mediaItems.length){
			// add item
			this.mediaItems.splice(index, 0, nitem);
		}
	}
	public function removeMediaItem(index:int):void{
		if (index>=0 && index < this.mediaItems.length){
			this.mediaItems.splice(index, 1);
		}
	}
	public function setMediaIndex(index:int):Boolean{
		if (index>=0 && index < this.mediaItems.length){
			this.itemIndex = index;
			return true;
		}else{
			return false;
		}
	}
	public function getMediaIndex():int{
		return this.itemIndex;
	}
	
	public function getMediaList():Array{
		return this.mediaItems;
	}
	
	public function setMediaList(list:Array):void{
		this.mediaItems = list;
	}
	
	public function removeCurrentItem():void{
		this.removeMediaItem(this.itemIndex);
	}
	
	/**
	 * engine functions
	 */
	public function getCurrentItem():Object{
		return this.mediaItems[this.itemIndex]
	}
	
	public function getItem(index:int):Object{
		if (index>=0 && index < this.mediaItems.length){
			return this.mediaItems[index];
		}else{
			return this.mediaItems[0];
		}
	}
	
	public function nextItem():Boolean{
		if (this.shuffle){
			this.itemIndex = (Math.floor(Math.random() * this.mediaItems.length));
		}else{
			// linear order
			this.itemIndex++;
			if (this.itemIndex >= this.mediaItems.length && this.repeatall){
				// repeatall => change track index
				this.itemIndex = 0;
			}
			
			// last track => fire stop event
			if (this.itemIndex >= this.mediaItems.length){
				this.itemIndex--;
				return false;
			}
		}
		return true;
	}
	
	public function prevItem():Boolean{
		this.itemIndex--;
		if (this.itemIndex < 0 && this.repeatall){
			this.itemIndex = this.mediaItems.length-1;
		}
		if (this.itemIndex < 0){
			this.itemIndex = 0;
		}
		
		return true;
	}
	
	/**
	 * Store status infos
	 */
	public function enableRepeat(e:Boolean):void{
		this.repeat = e;
	}
	public function enableRepeatall(e:Boolean):void{
		this.repeatall = e;
	}
	public function enableShuffle(e:Boolean):void{
		this.shuffle = e;
	}
	
	public function isRepeatEnabled():Boolean{
		return this.repeat;
	}
	
}}