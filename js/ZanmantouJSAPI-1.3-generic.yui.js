/* Zanmantou JSAPI 1.3 Copyright (c) 2007-2011 Andi Dittrich <andi.dittrich@a3non.org> - MIT Style X11 License */var a3non_zanmantou_instances=new Array();var a3non_zanmantou_callback=function(c,d,a){for(var b=0;b<a3non_zanmantou_instances.length;b++){if(a3non_zanmantou_instances[b][0]==c){a3non_zanmantou_instances[b][1].fireEvent(d,a)}}};var a3non_zanmantou_flashready_istriggered=false;var a3non_zanmantou_flashready=function(){};var a3non_zanmantou_flashready_callback=function(){if(!a3non_zanmantou_flashready_istriggered){a3non_zanmantou_flashready_istriggered=true;a3non_zanmantou_flashready()}};var Zanmantou=function(a){this.instanceid=document.getElementById(a);a3non_zanmantou_instances.push(new Array(a,this));this.events=new Array();this.instanceid.z_register(a)};Zanmantou.prototype.addEvent=function(b,a){this.events.push(new Array(b,a))};Zanmantou.prototype.removeEvent=function(c,b){for(var a=0;a<this.events.length;a++){if(this.events[a][0]==c&&this.events[a][1]==b){this.events[a]=new Array(null,null)}}};Zanmantou.prototype.fireEvent=function(d,b){for(var c=0;c<this.events.length;c++){if(this.events[c][0]==d){var a=this.events[c][1];a(b)}}};Zanmantou.prototype.start=function(){this.instanceid.z_start()};Zanmantou.prototype.jumpAndStart=function(a){this.stop();this.setMediaIndex(a);this.start()};Zanmantou.prototype.seek=function(a){this.instanceid.z_seek(a)};Zanmantou.prototype.play=function(a,b,c){this.instanceid.z_play(a,b,c)};Zanmantou.prototype.stop=function(){this.instanceid.z_stop()};Zanmantou.prototype.pause=function(){this.instanceid.z_pause()};Zanmantou.prototype.next=function(){this.instanceid.z_next()};Zanmantou.prototype.prev=function(){this.instanceid.z_prev()};Zanmantou.prototype.shuffle=function(a){this.instanceid.z_shuffle(a)};Zanmantou.prototype.repeat=function(a){this.instanceid.z_repeat(a)};Zanmantou.prototype.repeatall=function(a){this.instanceid.z_repeatall(a)};Zanmantou.prototype.smoothing=function(a){this.instanceid.z_smoothing(a)};Zanmantou.prototype.mute=function(){this.instanceid.z_mute()};Zanmantou.prototype.unmute=function(){this.instanceid.z_unmute()};Zanmantou.prototype.setVolume=function(a){this.instanceid.z_setVolume(a)};Zanmantou.prototype.getVolume=function(){return this.instanceid.z_getVolume()};Zanmantou.prototype.setPan=function(a){this.instanceid.z_setPan(a)};Zanmantou.prototype.getPan=function(){return this.instanceid.z_getPan()};Zanmantou.prototype.setLRTransform=function(c,a,b,d){this.instanceid.z_setLRTransform(c,a,b,d)};Zanmantou.prototype.getWave=function(){return JSON.decode(this.instanceid.z_getWave())};Zanmantou.prototype.getSpectrum=function(){return JSON.decode(this.instanceid.z_getSpectrum())};Zanmantou.prototype.getMediaList=function(){return JSON.decode(this.instanceid.z_getMediaList())};Zanmantou.prototype.setMediaList=function(a){this.instanceid.z_setMediaList(JSON.encode(a))};Zanmantou.prototype.setMediaIndex=function(a){this.instanceid.z_setMediaIndex(a)};Zanmantou.prototype.getMediaIndex=function(){return this.instanceid.z_getMediaIndex()};Zanmantou.prototype.addMediaItem=function(a,b){this.instanceid.z_addMediaItem(a,JSON.encode(b))};Zanmantou.prototype.removeMediaItem=function(a){this.instanceid.z_removeMediaItem(a)};Zanmantou.prototype.isPlaying=function(){return this.instanceid.z_isPlaying()};Zanmantou.prototype.getMediaLength=function(){return this.instanceid.z_getMediaLength()};Zanmantou.prototype.getMediaTime=function(){return this.instanceid.z_getMediaTime()};Zanmantou.prototype.getMediaProgress=function(){return this.instanceid.z_getMediaProgress()};Zanmantou.prototype.getMediaLoadingProgress=function(){return this.instanceid.z_getMediaLoadingProgress()};Zanmantou.prototype.getFPS=function(){return this.instanceid.z_getFPS()};Zanmantou.prototype.getVisionLightColors=function(){return JSON.decode(this.instanceid.z_getVisionLightColors())};Zanmantou.prototype.enableVisionLight=function(a){this.instanceid.z_enableVisionLight(a)};