/* Zanmantou JSAPI 1.3 Copyright (c) 2007-2011 Andi Dittrich <andi.dittrich@a3non.org> - MIT Style X11 License *//**
 * Zanmantou3 WebAudioVideoPlayer Javascript API (MooTools Version AND Generic/Framework independent)
 *
 * @note The function console.log() is provided by Firebug (Firefox Plugin), InternetExplorer Developer Tools, Safari Developer Tools or Opera Console
 * @note The `MooTools`-Version requires MooTools-CORE `and` Hash from MooTools-MORE
 * @note The GenericAPI is tested with jQuery and as standalone application
 * @note The functions `addEvent` and `removeEvent` are a custom event implementation inspired by MooTools Event Handling (addEvents/removeEvents from MooTools are NOT avaible!)
 * @note The API requires the functions `JSON.encode` and `JSON.decode` from e.g. MooTools. The Generic Version is avaible with or without an implementation (some other frameworks have similar methods)
 *	
 * @author Andi Dittrich, <andi.dittrich@a3non.org>
 * @releases http://zanmantou.a3non.org
 * @license: MIT (X11 License)
 * @version 1.3
 * @docgen A3-APIG
 *
 * @EVENTS
 *
 * ::start
 * Fired when the GUI start-button is clicked or the js function is called
 * @syntax addEvent('start', function(){}) 
 *
 * ::play
 * Fired when playback starts
 * @syntax addEvent('play', function(){})  
 *
 * ::stop
 * Fired when the GUI stop-button is clicked or the js function is called
 * @syntax addEvent('stop', function(){}) 
 *
 * ::pause
 * Fired when the GUI pause-button is clicked or the js function is called
 * @syntax addEvent('pause', function(){}) 
 *
 * ::prev
 * Fired when the GUI previous-button is clicked or the js function is called
 * @syntax addEvent('prev', function(){})  
 *
 * ::next
 * Fired when the GUI next-button is clicked or the js function is called 
 * @syntax addEvent('next', function(){})
 *
 * ::mute
 * Fired when the GUI mute-button is clicked or the js function is called
 * @syntax addEvent('mute', function(){}) 
 *
 * ::unmute
 * Fired when the GUI unmute-button is clicked or the js function is called 
 * @syntax addEvent('unmute', function(){}) 
 *
 * ::repeatallon
 * Fired when the GUI repeatall-on-button is clicked or the js function is called 
 * @syntax addEvent('repeatallon', function(){}) 
 *
 * ::repeatalloff
 * Fired when the GUI repeatall-off-button is clicked or the js function is called 
 * @syntax addEvent('repeatalloff', function(){}) 
 *
 * ::repeaton
 * Fired when the GUI repeat-on-button is clicked or the js function is called  
 * @syntax addEvent('repeaton', function(){}) 
 *
 * ::repeatoff
 * Fired when the GUI repeat-off-button is clicked or the js function is called  
 * @syntax addEvent('repeatoff', function(){}) 
 *
 * ::shuffleon
 * Fired when the GUI shuffle-on-button is clicked or the js function is called  
 * @syntax addEvent('shuffleon', function(){}) 
 *
 * ::shuffleoff
 * Fired when the GUI shuffle-off-button is clicked or the js function is called  
 * @syntax addEvent('shuffleoff', function(){})
 *
 * ::fullscreenon
 * Fired when the GUI fullscreen-on-button is clicked 
 * It is very usefull to stop other animations on your page
 * @syntax addEvent('fullscreenon', function(){}) 
 *
 * ::fullscreenoff
 * Fired when the GUI fullscreen-off-button is clicked 
 * @syntax addEvent('fullscreenoff', function(){})  
 *
 * ::exten
 * Fired when the GUI previous-button is clicked or the js function is called 
 * @param type {String} custom type identifier defined in your XML config
 * @syntax addEvent('extern', function(type){}) 
 * @example xml UIConfig button definition
 * <extern type="myEventA1" x="10" y="10">
 * 	<out>special.png</out>
 * </extern>
 *
 * @example js Capture custom event
 * player.addEvent('extern', function(type){
 * 	if (type=='myEventA1'){
 * 		console.log('special event A1');
 * 	}
 * 	if (type=='myEventB1'){
 * 		console.log('well another custom event');
 * 	}
 * });
 *
 * ::volumestart
 * Fired when the GUI volume slider was dragged 
 * @syntax addEvent('volumestart', function(){}) 
 *
 * ::volumecomplete
 * Fired when the GUI volume slider has dropped
 * @syntax addEvent('volumecomplete', function(value){})  
 * @param value {Double} volume value normalized to [0.0 ... 1.0]
 * @see http://mootools.net/docs/more/Drag/Slider
 * @example js Using the VolumeComplete-Event to update a Javascript slider for synchronizing GUIs (see MooTools More for details)
 * // create player instance
 * var player = new Zanmantou('myplayer');
 *
 * // create MooTools Slider
 * var mySlider = new Slider('myElement', 'myKnob',{
 * 	range: [0,100]
 * });
 * 
 * // slider complete callback
 * var slideComplete = function(value){
 * 	// normalizing factor (see slider range)
 * 	n = 100;
 *
 * 	// update player volume by javascript slider
 * 	player.setVolume(value/n);
 * }
 *
 * // add complete event
 * mySlider.addEvent('complete', slideComplete);
 *
 * // update slider position on volumecomplete
 * player.addEvent('volumecomplete', function(value){
 * 	// normalizing factor (see slider range)
 * 	n = 100;
 *
 * 	// IMPORTANT !! to prevent infinite event loops you have to remove the complete 
 * 	// event from the slider, because it's fired by setting an new value. 
 * 	// Otherwise the Slider.set method will trigger an complete event 
 * 	// => player volume was updated by callback => zanmantou triggers new  
 * 	// volumecomplete event => ...
 * 	mySlider.removeEvent('complete', slideComplete);
 *
 * 	// update slider value
 * 	mySlider.set(value*n);
 *
 * 	// reattach event
 * 	mySlider.addEvent('complete', slideComplete);
 * });
 *
 *
 * ::progresstart
 * Fired when the GUI progress slider was dragged
 * @syntax addEvent('progressstart', function(){}) 
 *
 * ::progresscomplete
 * Fired when the GUI progress slider has dropped  
 * @syntax addEvent('progresscomplete', function(value){}) 
 * @param value {Double} progress value normalized to [0.0 ... 1.0] 
 *
 * ::panstart
 * Fired when the GUI pan slider was dragged 
 * @syntax addEvent('panstart', function(){}) 
 *
 * ::pancomplete
 * Fired when the GUI pan slider has dropped
 * @syntax addEvent('pancomplete', function(value){}) 
 * @param value {Double} pan value normalized to [-1.0 ... 0.0 ... 1.0]    
 *
 * ::mediacomplete
 * Fired when the playback of a media item (track/video) is complete
 * @syntax addEvent('mediacomplete', function(){})
 *
 * ::mediaerror
 * Fired when the playback of a media item failed 
 * @syntax addEvent('mediaerror', function(){})
 * @example js Show error message on error
 * player.addEvent('mediaerror', function(){
 * 	alert('We are sorry but a problem occured');
 * });
 *
 *
 *
 *
 */
var Zanmantou = new Class({
	Implements: [Options],
	
	instanceid: null,
	debuginstance: null,
	version: '1.3',
	events: [],

	/**
	 * @note It's strongly recommend to use the Zanmantou flashready Event to initialize the Javascript functions - load/domready don't work reliable 
	 * @param {String|Object} Zanmantou object ElementID/Element
	 * @param {Object} No options avaible yet
	 * @example html Player HTML Object with ID
	 * <object id="player1id"  ...> </object>
	 * @example js Create player instance with MooTools (Warning: Use the `flashready` event `NOT domready or load` !!!)
	 * window.addEvent('flashready', function(){
	 * 	var player = new Zanmantou('player1id');
	 * });
	 * @example js Create player instance with jQuery (Warning: Don't use the `load` or `ready` event !!!)
	 * a3non_zanmantou_flashready = (function(){
	 * 	var player = new Zanmantou('player1id');
	 * });
	 * @example js Create player instance without a Framework
	 * a3non_zanmantou_flashready = (function(){
	 * 	var player = new Zanmantou('player1id');
	 * });	 
	 * @syntax var player = new Zanmantou(el, [options]);
	 */
	initialize: function(id, options){
		this.setOptions(options);
		this.instanceid = document.id(id);

		// store instance
		a3non_zanmantou_instances.set(id, this);
		
		// register instance
		this.instanceid.z_register(id);
	},
	
	/**
	 * Adds an event to the Class instance's event stack (inspired by MooTools Event handling)
	 * @note For cross-framework-compatibility we use a custom event implementation
	 * @param event {String} The Event name/type (identifier)
	 * @param fn {Function} Callback function
	 * @syntax addEvent(event, fn)
	 * @example js XMLReady event
	 * player1.addEvent('xmlready', function(){
	 * 	console.log('Medialist', player1.getMediaList()):
	 * });
	 *
	*/
	addEvent: function(event, fn){
		this.events.push(new Array(event, fn));
	},

	/**
	 * Removes an event from the stack of events of the Class instance (inspired by MooTools Event handling)
	 * @note For cross-framework-compatibility we use a custom event implementation
	 * @param event {String} The Event name/type (identifier)
	 * @param fn {Function} Callback function
	 * @syntax removeEvent(event, fn)
	 * @example js XMLReady event
	 * // Callback function
	 * var onXMLReady = function(){
	 * 	console.log("XML data is avaible");
	 * });
	 *
	 * // adding event
	 * player1.addEvent('xmlready', onXMLReady);
	 *
	 * // remove event
	 * player1.removeEvent('xmlready', onXMLReady)
	*/	
	removeEvent: function(event, fn){
		for (var i = 0;i<this.events.length;i++){
			if (this.events[i][0] == event && this.events[i][1] == fn){
				// "remove" event
				this.events[i] = new Array(null, null);
			}
		}
	},

	fireEvent: function(event, arg){
		for (var i = 0;i<this.events.length;i++){
			if (this.events[i][0] == event){
				var cb = this.events[i][1];
				cb(arg);
			}
		}
	},

	/**
	 * Starts playback, equivalent to UI start button
	 * @syntax start()
	 * @example html Create a HTML baased start-button
	 * <input type="button" id="zanmantou_start">Start Playback</input>
	 * @example js Add Click-event (MooTools)
	 * $('zanmantou_start').addEvent('click', function(){
	 * 	player1.start();
	 * });
	 */
	start: function(){
		this.instanceid.z_start();
	},
	
	/**
	 * Jump to media item item given by index
	 * @syntax jumpAndStart(index)
	 * @param index {INT} the destination media index (0....n-1)
	 * @example js Start item on index 14 (track 15 !)
	 * player.jumpAndStart(14);
	*/
	jumpAndStart: function(index){
		this.stop();
		this.setMediaIndex(index);
		this.start();
	},
	
	/**
	 * Seek media pointer to specified position
	 * @syntax seek(pos)
	 * @param pos {Int} new position in seconds
	 */
	seek: function(pos){
		this.instanceid.z_seek(pos);
	},
	
	/**
	 * `LOWLEVEL`: Directly play a track by given URL
	 * @param url {String} absolute URL to the media file
	 * @param type {String} media type (audio|video)
	 * @param position {Int} start position in seconds (normally 0)
	 * @syntax play(url, type, position)	 
	 * @example js Play Video from a3non.org
	 * player1.play('http://www.a3non.org/media/demo.f4v', 'video', 0);
	 */
	play: function(url, type, pos){
		this.instanceid.z_play(url, type, pos);
	},
					
	/**
	 * Stops playback, equivalent to UI stop button
	 * @syntax stop()
	 */			
	stop: function(){
		this.instanceid.z_stop();
	},
	
	/**
	 * Pause playback, equivalent to UI pause button
	 * @syntax pause()
	 */
	pause: function(){
		this.instanceid.z_pause();
	},
	
	/**
	 * Jumps to next media item, equivalent to UI next button
	 * @syntax next()
	 */
	next: function(){
		this.instanceid.z_next();
	},

	/**
	 * Jumps to previous media item, equivalent to UI prev button
	 * @syntax prev()
	 */	
	prev: function(){
		this.instanceid.z_prev();
	},

	/**
	 * Enable/Disable shuffle mode, equivalent to UI shuffle button
	 * @param e {Boolean} enable shuffle
	 * @syntax shuffle(e)
	 */
	shuffle: function(enable){
		this.instanceid.z_shuffle(enable);
	},
	
	/**
	 * Enable/Disable single item repeat mode, equivalent to UI repeat button
	 * @param e {Boolean} enable repeat
	 * @syntax repeat(e)
	 */
	repeat: function(enable){
		this.instanceid.z_repeat(enable);
	},
	
	/**
	 * Enable/Disable repeatall mode, equivalent to UI repeatall button
	 * @param e {Boolean} enable repeatall
	 * @syntax repeatall(e)
	 */
	repeatall: function(enable){
		this.instanceid.z_repeatall(enable);
	},
	
	/**
	 * Enable/Disable video smoothing, equivalent to UI smoothing button
	 * `WARNING`: Enabling this options causes extrem CPU load when playing HD videos
	 * @param e {Boolean} enable smoothing
	 * @syntax smoothing(e)
	 */
	smoothing: function(enable){
		this.instanceid.z_smoothing(enable);
	},
	
	/**
	 * Mutes volume, equivalent to UI mute button
	 * @syntax mute()
	 */
	mute: function(){
		this.instanceid.z_mute();
	},
	
	/**
	 * Unmutes volume, equivalent to UI unmute button
	 * @syntax unmute()
	 */
	unmute: function(){
		this.instanceid.z_unmute();
	},
	
	/**
	 * Set volume
	 * @param volume {Double} normalized to [0.0 ... 1.0]
	 * @syntax setVolume(volume)
	 * @example js Set volume to 50%
	 * player.setVolume(0.5);
	 */
	setVolume: function(volume){
		this.instanceid.z_setVolume(volume);
	},
	
	/**
	 * Get volume
	 * @return volume {Double} normalized to [0.0 ... 1.0]
	 * @syntax getVolume()
	 */
	getVolume: function(){
		return this.instanceid.z_getVolume();
	},

	/**
	 * Set pan (LR balance)
	 * @param pan {Double} normalized to [-1.0 ... 0.0 ... 1.0] negative values represent left, positive right
	 * @syntax setPan(pan)
	 */	
	setPan: function(balance){
		this.instanceid.z_setPan(balance);
	},

	/**
	 * Get pan (LR balance)
	 * @return pan {Double} normalized to [-1.0 ... 0.0 ... 1.0] negative values represent left, positive right
	 * @syntax getPan()
	 */		
	getPan: function(){
		return this.instanceid.z_getPan();
	},

	/**
	 * Set LR transformation (LR channel mix)
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/media/SoundTransform.html
	 * @param ll {Double} left to left mix normalized to [0.0 ... 1.0]
	 * @param lr {Double} left to right mix normalized to [0.0 ... 1.0]
	 * @param rr {Double} right to right mix normalized to [0.0 ... 1.0]
	 * @param rl {Double} right to left mix normalized to [0.0 ... 1.0]	 		 
	 * @syntax setLRTransform(ll, lr, rr, rl)
	 * @example js Transform to Mono Sound
	 * player1.setLRTransform(0.5, 0.5, 0.5, 0.5);
	 */			
	setLRTransform: function(ll, lr, rr, rl){
		this.instanceid.z_setLRTransform(ll, lr, rr, rl);
	},
	
	/**
	 * `LOWLEVEL`: Get waveform snapshot (FFT=false)
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/media/SoundMixer.html#computeSpectrum%28%29
	 * @return {Array} array of double values (512) normalized to [-1.0 .. 0.0 .. 1.0]. the first 256 values
	 * represents the left channel, the last 256 values the right channel 
	 * @syntax getWave()
	 */		
	getWave: function(){
		return JSON.decode(this.instanceid.z_getWave());
	},
	
	/**
	 * `LOWLEVEL`: Get spectrum snapshot (FFT=true) - you can use it to create custom spectrum visualizer
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/media/SoundMixer.html#computeSpectrum%28%29
	 * @return {Array} array of double values (512) normalized to [-1.0 .. 0.0 .. 1.0]. the first 256 values
	 * represents the left channel, the last 256 values the right channel 
	 * @syntax getSpectrum()
	 */			
	getSpectrum: function(){
		return JSON.decode(this.instanceid.z_getSpectrum());
	},
	
	
	/**
	 * Get the Medialist
	 * Note: The Medialist data is only avaible when the `xmlready` event is fired
	 * @return {Array} Medialist object array 
	 * @syntax getMediaList()
	 * @example js The method returns the following object structure
	 * var list = player.getMediaList();
	 *
	 * // the variable "list" contains the following structure
	 * [
	 * 	{
	 * 		source: 'mytrack.mp3',
	 * 		streaming: false,
	 * 		type: 'audio',
	 * 		params: {
	 * 			title: 'Jamtoo - Sunshine',
	 * 			author: 'Jamtoo',
	 * 			album: 'unknown'
	 *		}
	 * 	},
	 * 
	 * 	{
	 * 		source: 'demovideo.f4v',
	 * 		streaming: false,
	 * 		type: 'video',
	 * 		params: {
	 * 			title: 'Zanmantou Demo Video'
	 *		}
	 * 	}
	 * ]
	 */		
	getMediaList: function(){
		return JSON.decode(this.instanceid.z_getMediaList());
	},
	
	
	/**
	 * Set the Medialist
	 * Note: The Medialist data is only avaible after the `xmlready` event. When you modify it before, it will be overwritten by the XML data!
	 * @param list {Array} Medialist object array 
	 * @syntax setMediaList(list)
	 * @example js Set new static Medialist
	 * // create Medialist example object
	 * var newlist = [
	 * 	{
	 * 		source: 'mytrack.mp3',
	 * 		streaming: false,
	 * 		type: 'audio',
	 * 		params: {
	 * 			title: 'Jamtoo - Sunshine',
	 * 			author: 'Jamtoo',
	 * 			album: 'unknown'
	 *		}
	 * 	},
	 * 
	 * 	{
	 * 		source: 'demovideo.f4v',
	 * 		streaming: false,
	 * 		type: 'video',
	 * 		params: {
	 * 			title: 'Zanmantou Demo Video'
	 *		}
	 * 	}
	 * ];
	 *
	 * player.setMediaList(list);
	 */		
	setMediaList: function(list){
		this.instanceid.z_setMediaList(JSON.encode(list));
	},
	
	/**
	 * Set the media index
	 * @param i {Int} Media Index starting with 0
	 * @syntax setMediaIndex(i)
	 */		
	setMediaIndex: function(i){
		this.instanceid.z_setMediaIndex(i);
	},

	/**
	 * Get the media index
	 * @return {Int} Media Index starting with 0
	 * @syntax getMediaIndex()
	 */		
	getMediaIndex: function(){
		return this.instanceid.z_getMediaIndex();
	},
	
	/**
	 * Add new MediaItem to the Medialist at specified index (existing element on these position is shiftet to index+1)
	 * Note: The Medialist data is only avaible after the `xmlready` event. When you modify it before, it will be overwritten by the XML data!
	 * @param index {Int} MediaItem position starting with 0
	 * @param data {Object} new MediaItem
	 * @syntax addMediaItem(index, data)
	 * @example js Adding new item as second element
	 * var newitem = {
	 * 		source: 'demovideo.f4v',
	 * 		streaming: false,
	 * 		type: 'video',
	 * 		params: {
	 * 			title: 'Zanmantou Demo Video'
	 *		}
	 * 	};
	 *
	 * player.addMediaItem(1, newitem);
	 */		
	addMediaItem: function(index, data){
		this.instanceid.z_addMediaItem(index, JSON.encode(data));
	},

	/**
	 * Removes MediaItem from spcified index
	 * Note: The Medialist data is only avaible after the `xmlready` event. When you modify it before, it will be overwritten by the XML data!
	 * @param index {Int} Media Index starting with 0
	 * @syntax removeMediaItem(index)
	 */		
	removeMediaItem: function(index){
		this.instanceid.z_removeMediaItem(index);
	},
	
	/**
	 * Checks if playback is active
	 * @return {Boolean} flag
	 * @syntax isPlaying()
	 */			
	isPlaying: function(){
		return this.instanceid.z_isPlaying();
	},

	/**
	 * Get length of currrent media item in seconds
	 * @return {Int} length in seconds
	 * @syntax getMediaLength()
	 */		
	getMediaLength: function(){
		return this.instanceid.z_getMediaLength();
	},

	/**
	 * Get playback position of the current media item
	 * @return {Int} position in seconds
	 * @syntax getMediaTime()
	 */			
	getMediaTime: function(){
		return this.instanceid.z_getMediaTime();
	},

	/**
	 * Get playback progress
	 * @return {Double} progress normalized to [0.0 ... 1.0]
	 * @syntax getMediaProgress()
	 */			
	getMediaProgress: function(){
		return this.instanceid.z_getMediaProgress();
	},

	/**
	 * Get media item loading progress
	 * @return {Double} progress normalized to [0.0 ... 1.0]
	 * @syntax getMediaLoadingProgress()
	 */			
	getMediaLoadingProgress: function(){
		return this.instanceid.z_getMediaLoadingProgress();
	},
	
	/**
	 * Get Video FPS (Frames per second)
	 * @return {Int} FPS
	 * @syntax getFPS()
	 * @example html FPS display
	 * <div id="fpsdisplay">-</div>
	 *
	 * @example js Periodical FPS display update (MooTools)
	 * (function(){
	 * 	$('fpsdisplay').set('text', player.getFPS());
	 * }).periodical(100);
	 */			
	getFPS: function(){
		return this.instanceid.z_getFPS();
	},

	/**
	 * Get VisionLight RAW Color Data of each border (top, right, bottom, left) if enabled, otherwise the last analyzed values
	 * @return {Object} VisionLight color object
	 * @syntax getVisionLightColors()
	 * @example js Get the mean border colors
	 * var colors = player.getVisionLightColors();
	 *
	 * // the object contains max. 4 arrays (configured in your config.xml)
	 * // possible keys are : l,r,t,b (left, right, top, bottom)
	 * // every key contains an array with 3 color values (RGB)
	 *
	 * // the colors object contains e.g.
	 * {
	 * 	r: [255, 0, 123],
	 * 	l: [12, 34, 51],
	 * 	t: [0, 21, 93],
	 * 	b: [0, 0, 0]
	 * }
	 */		
	getVisionLightColors: function(){
		return JSON.decode(this.instanceid.z_getVisionLightColors());	
	},
	
	/**
	 * Enable/Disable VisionLight, equivalent to UI visionlight button
	 * @param {Boolean} enable visionlight
	 * @syntax player.enableVisionLight(true)
	 */
	enableVisionLight: function(e){
		this.instanceid.z_enableVisionLight(e);	
	}
});

/**
 * lowlevel instance array
 */
var a3non_zanmantou_instances = new Hash();
 
/**
 * lowlevel callback passthrough
 * @param {String} instanceID
 * @param {String} event
 * @param {String} args
 */
var a3non_zanmantou_callback = function(instanceID, event, args){
	// trace events if console is avaible
	a3non_zanmantou_instances.get(instanceID).fireEvent(event, args);
};

/**
 * FlashReady Flag
 */
var a3non_zanmantou_flashready_istriggered = false;

/**
 * FlashReady Highlevel Callback
 */
var a3non_zanmantou_flashready = function(){};
/**
 * FlashReady Lowlevel Event
 */
var a3non_zanmantou_flashready_callback = function(){
	if (!a3non_zanmantou_flashready_istriggered){
		a3non_zanmantou_flashready_istriggered = true;
		window.fireEvent('flashready');
	}	
};