=== Zanmantou Web Audio/Video Player ===
Contributors: Andi Dittrich
Tags: flash, audio, video, media, player, mp3, mp4, flv, f4v, h264, customize, themes, scalable, skins, design, embed, fullscreen, stagevideo
Requires at least: 3.0
Tested up to: 3.2.1
Stable tag: 1.4.3.1.1

Zanmantou is a Flash based, high scalable, simply customizable, Video and Audio player.

== Description ==

= DEVELOPMENT DISCONTINUED =
I am very sorry to announce, that the development of Zanmantou3, including the WordPress Plugin is discontinued.
But in case of the upcomming HTML5 standard and the obvious fact of discontinuing Flash on Linux and mobile devices on the part of Adobe there is no right to exist or better to say necessity for Zanmantou. 
So don't be worry..i spend some years of development into it.. i am sad too.

The Zanmantou plugin for WordPress allows the addition of video and audio to a WordPress website using standards-compliant markup (W3C) with the powerfull, noncommercial Zanmantou Web Audio/Video Player. Installation is quick and easy, everything will be work out-of-the-box and no additional setup/configuration knowledge is required. Just insert a shortcode like `[zanmantou file="demo.f4v"]` to yout post - that's it.
If you want more: create your own player themes by an simple xml-configuration file without flash/html/css. just design, zanmantou will be do the rest.

= Plugin Features =
* Automatical generates zanmantou shortcodes by using the WordPress buildin media browser
* width, height, theme settings for each mediatype (audio, video, default) configurable
* Automated caching of dynamic generated medialists 

= Zanmantou keyfeatures =
* Design your own player - no Flash, HTML or CSS knowledge
* Platform independent - Adobe Flash 10 is based
* Full screen mode - Design is also fully customizable
* Hardware Accelerated Video Rendering (StageVideo)
* Event triggerd Javascript API - an extensive javascript API can be controll all the player functions. And the best: the API is fully event-controlled
* UI elements like buttons, sliders, images individually configured and positionibar
* Any number of UI elements of a type - for example, an additional, transparent start button on the video
* Mouseover/press/release Buttoneffects
* Configurable, parametric information (text) area with HTML underside - you make the display of playlist information, playing time, individually
* Slider for Progress, Volume, Balance and Loading separately configurable - vertical sliders are possible
* Playback of h.264, F4V, flv, mp3, wav files
* Even as a pure audio player available
    
== Installation ==

= Installation =
1. Note: You need 2 packages to get the Zanmantou Plugin working: `Zanmantou Wordpress Plugin` AND `Zanmantou Player Package`
2. Upload the complete `zanmantou` folder (Wordpress Plugin) to the `/wp-content/plugins/` directory
3. Activate the plugin through the 'Plugins' menu in WordPress
4. Download the latest Zanmantou Package from [official Zanmantou download page](http://download.a3non.org/zanmantou3/) and upload the complete folder content to the plugins diretory `/wp-content/plugins/zanmantou` OR use the 1-click-download button on "Settings->Zanmantou Player" settings page (requires PHP zip functions; allow_url_fopen=true) 
5. Goto "Settings->Zanmantou Player" in your WordPress Backend and select the themes you want
6. You can also use your own theme by uploading it into the `/wp-content/plugins/zanmantou/themes/` directory
7. That's it! You're done. You can now enter the following into a post or page in WordPress to insert a video: [zanmantou file="demovideo.f4v"] or just use the Wordpress buildin media-brower
8. Dont forget to set an link to the [Zanmantou project page](http://zanmantou.a3non.org) in your imprint/credits/contact section

== Frequently Asked Questions ==


= I get an error using the 1-click-update button =
This function requires php 5 with enable zip functions and allow_url_fopen set to true in your php.ini
In this case, please update/install the player manually by downloading the complete Zanmantou package (@see Installation.3)
(e.g. `Fatal error: Class 'ZipArchive' not found in ...`)

= I get an "file permission" php error =

The directory `/wp-content/plugins/zanmantou/cache/` must be writeable - the medialists will be stored there

= I wanna create a custom player design =

1. Read the [Zanmantou UI config reference](http://zanmantou.a3non.org/sandbox/zanmantou/uiconfig.html)
2. Create your design with Photoshop/Gimp/Paint or some other tool
3. Slice it into functional parts (buttons, slider, slider knobs, ..)
4. Create your design markup in an xml file
5. Upload your theme into the `/wp-content/plugins/zanmantou/themes/` directory
6. Select your theme in the plugin configuration page
7. That's it! You're done.

= I miss some features / I found a bug =

Well..write a email to Andi Dittrich (andi.dittrich AT a3non.org)

== Screenshots ==

1. Zanmantou embed into page (puregrey theme)
2. Configuration backend page 
3. Usage of zanmantou shortcode in the editor
4. Advanced shortcode generated automatically by using buildind media browser
5. Adding media to your post

== Changelog ==

= 1.1.3.0.3 =
* First public release. Includes Zanmantou 3.0.3

= 1.2.3.0.3 =
* Added 1-click-install button to the plugin page
* Moved Zanmantou Player package to external mirror (download.a3non.org) - Now you have to download the player by yourself

= 1.2.3.0.4 =
* Fixed plugin by updating `Zanmantou Player Package`
Please download the [latest Zanmantou Package](http://download.a3non.org/zanmantou3/Zanmantou-3.0.4.zip) and upload the complete folder content to the plugins diretory `/wp-content/plugins/zanmantou` OR use the 1-click-download button 

= 1.3.3.1 =
* The player now works again. Ii've provided a wrong player package on the download mirror.
I apologize for this inconvenience

* Added Zanmantou 3.1 support for cover images (thumbnails)
* Added automatical backup/restore of player-package-files on upgrading the plugin
* Improoved Cache System: automatical cache update on changing post/page

= 1.4.3.1.1
* Fixed default settings storage problem
* Fixed StageVideo Problem (wmode was set to "window" but "direct" ist reequired for hardware accelerated playback)
* Added Zanmantou 3.1.1 support

== Upgrade Notice ==

= 1.2.3.0.4 =
* the player now works again. i've provided a wrong set of the ImagePath/MediaPath parameter in the theme configuration of the `Zanmantou Player Package`, whereby the player was trying to access the demo media path on a3non.org and therefore could not play any of your files. 
Please download the [latest Zanmantou Package](http://download.a3non.org/zanmantou3/Zanmantou-3.0.4.zip) and upload the complete folder content to the plugins diretory `/wp-content/plugins/zanmantou` OR use the 1-click-download button
I apologize for this inconvenience

= 1.2.3.0.3 =
* IMPORTANT: If you update the plugin from a previous version, the wordpress update function will automatically remove the Zanmantou3.swf and the themes directory, because they are not longer present in SVN/generated plugin-package (sorry for that...it's a license issue..) - please use the 1-click-update function on the plugin configuration page to download the player package (Zanamntou3.swf, themes, ..) automatically  from the official Zanmantou download page or upload the unziped package manually (@see Installation.3)
* You have to update the Zanmantou Player by yourself (@see Installation.3)

== License ==

Note: The plugin is released under the X11 License but the Zanmantou Player itself is licensed under a noncommercial license [CreativeCommons BY-NC-ND](http://creativecommons.org/licenses/by-nc-nd/3.0/de/). I.e. You may not use the player only for non-commercial purposes. It is also necessary to put a link on your website back to the project page (for example into the imprint). For details, please refer to the license on the [project site](http://zanmantou.a3non.org).
