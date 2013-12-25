<?php
/*
Plugin Name: Zanmantou Web Audio/Video Player
Version: 1.4.3.1.1
Plugin URI: http://zanmantou.a3non.org/sandbox/zanmantou/plugins/wordpress.html
Description: Simply adding Videos/Audio Tracks to your Blog by using the Zanmantou Player (Official Plugin)
Author: Andi Dittrich
Author URI: http://www.a3non.org
License: X11 License (MIT License)

Copyright (c) 2010-2011 Andi Dittrich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

1) Includes Zanmantou Web Audio/Video Player 3 (Creative Commons "by-nc-nd" License)
   Website: http://zanmantou.a3non.org
   License: http://creativecommons.org/licenses/by-nc-nd/3.0/de/
*/

// version
define('ZanmantouDownloadURL', 'http://download.a3non.org/zanmantou3/Zanmantou-3.1.1.zip');
define('ZanmantouPluginVersion', '1.4.3.1.1');
define('ZanmantouPlayerVersion', '3.1.1');

// process video tags
function ZanmantouPlugin_shortcode($atts, $content=null, $code=""){
	// attribute file is required
	if (!isset($atts['file'])){
		return '';	
	}

	// get type	
	$type = 'default';
	if (isset($atts['type']) && ($atts['type']=='audio' || $atts['type'] == 'video')){
		$type = $atts['type'];
	}
	
	// set defaults
	$options = shortcode_atts(array(
		'theme' => get_option('zanmantou-sf-'.$type.'-theme', 'puregrey'),
		'width' => get_option('zanmantou-sf-'.$type.'-width', '600'),
		'height' => get_option('zanmantou-sf-'.$type.'-height', '400'),
		'title' => '',
		'thumbnail' => ''
	), $atts );

	// plugin url
	$pluginURL = plugins_url('/zanmantou/');
	
	// get player url
	$playerURL = $pluginURL.'player/Zanmantou3.swf';
	
	// config url
	$playerConfigURL = $pluginURL.'player/themes/'.$options['theme'].'/'.$options['theme'].'.xml';
	
	// mediapath
	$playerMediapath = (substr($atts['file'], 0, 4) == 'http') ? '' : get_option('siteurl').'/';
	
	// imagepath
	$playerImagepath = $pluginURL.'player/themes/'.$options['theme'].'/';

	// create medialist	
	$playerListURL = ZanmantouPlugin_createMedialist($atts['file'], $atts['title'], $atts['thumbnail']);
	
	return '
	<object id="zanmantou-'.sha1($atts['file']).'" data="'.$playerURL.'" type="application/x-shockwave-flash" width="'.$options['width'].'" height="'.$options['height'].'" >
		<param name="movie" value="'.$playerURL.'" />
		<param name="quality" value="best" />
		<param name="scale" value="noscale" />
		<param name="salign" value="lt" />
		<param name="FlashVars" value="config='.$playerConfigURL.'&list='.$playerListURL.'&mediapath='.$playerMediapath.'&imagepath='.$playerImagepath.'" />
		<param name="allowScriptAccess" value="sameDomain" />
		<param name="allowFullScreen" value="true" />
		<param name="wmode" value="direct" /> 
		<p>No Flash-Player found - please download it from adobe.com/get/flash</p>
	</object>';
}

// generates medialist
function ZanmantouPlugin_createMedialist($file, $title, $thumbnail){
	// page ID
	$pageID = get_query_var('page_id');
	
	// medialist url
	$medialist = sha1($file).'.xml';
	
	// if file not exists create it
	if (!file_exists(dirname(__FILE__).'/cache/'.$pageID.'/'.$medialist)){
		$list = '<?xml version="1.0" encoding="UTF-8"?>
<zanmantou>
	<item source="'.$file.'">
		<param name="title">'.$title.'</param>
		<thumbnail>'.$thumbnail.'</thumbnail>
	</item>
</zanmantou>';	

		// directory avaible ?
		if (!is_dir(dirname(__FILE__).'/cache/'.$pageID)){
			// create directory
			mkdir(dirname(__FILE__).'/cache/'.$pageID, 0700, true);
		}
		
		// store xml medialist
		file_put_contents(dirname(__FILE__).'/cache/'.$pageID.'/'.$medialist, $list);
	}
	
	return plugins_url('/zanmantou/cache/').$pageID.'/'.$medialist;
}

// add menu
function ZanmantouPlugin_backend() {
	add_options_page('Zanmantou Web Audio/Video Player', 'Zanmantou Player','administrator', __FILE__, 'Zanmantou_settings_page');
	
	//call register settings function
	add_action('admin_init', 'register_zanmantou_settings'); 
}


function register_zanmantou_settings() {
	//register our settings
	register_setting('zanmantou-settings-group', 'zanmantou-sf-default-width');
	register_setting('zanmantou-settings-group', 'zanmantou-sf-default-height');
	register_setting('zanmantou-settings-group', 'zanmantou-sf-default-theme');

	register_setting('zanmantou-settings-group', 'zanmantou-sf-audio-width');
	register_setting('zanmantou-settings-group', 'zanmantou-sf-audio-height');
	register_setting('zanmantou-settings-group', 'zanmantou-sf-audio-theme');
	
	register_setting('zanmantou-settings-group', 'zanmantou-sf-video-width');
	register_setting('zanmantou-settings-group', 'zanmantou-sf-video-height');
	register_setting('zanmantou-settings-group', 'zanmantou-sf-video-theme');
	
	register_setting('zanmantou-settings-group', 'zanmantou_editor_autoreplace');
}

// options page
function Zanmantou_settings_page() {
	// load language files
	load_plugin_textdomain('zanmantou', null, basename(dirname(__FILE__)).'/lang');
	
	// zanmantou current version
	define('ZanmantouCurrentPlayerVersion', file_get_contents(dirname(__FILE__).'/player/.version'));

	// theme storage
	$themes = array();
	
	if (is_dir(dirname(__FILE__).'/player/themes')){
		// get filess/folders
		$files = scandir(dirname(__FILE__).'/player/themes');
		
		// extract folder
		foreach ($files as $file){
			if ($file != "." && $file != ".."){
				$themes[] = $file;
			}
		}
	}
	
	// include admin page
	include('SettingsPage.php');
}

// WordPress Plugin Hooks
add_shortcode('zanmantou', 'ZanmantouPlugin_shortcode');
add_action('admin_menu', 'ZanmantouPlugin_backend');


/**
	MEDIA INSERT/UPLOAD REPLACEMENTS
*/

// replace video insert with zanmantou tag
function ZanmantouPlugin_editor_videoaction($html, $href, $title){
	return '[zanmantou type="video" file="'.$href.'" title="'.$title.'"]';
}
// replace video insert with zanmantou tag
function ZanmantouPlugin_editor_audioaction($html, $href, $title){
	return '[zanmantou type="audio" file="'.$href.'" title="'.$title.'"]';
}
// replace audio/video inserts with zanmantou tags
function ZanmantouPlugin_editor_mediaaction($html, $id, $meta){
	// get file extension
	$ext = substr($meta['url'], strrpos($meta['url'], '.')+1);

	// video ?
	if ($ext == 'flv' || $ext == 'f4v' || $ext == 'mp4'){
		return '[zanmantou type="video" file="'.$meta['url'].'" title="'.$meta['post_title'].'"]';
		
	// audio ?
	}else if ($ext == 'mp3' || $ext == 'wav'){
		return '[zanmantou type="audio" file="'.$meta['url'].'" title="'.$meta['post_title'].'"]';

	// if no audio/video -> no filter operation
	}else{
		return $html;	
	}
}

// only replace if flag is set 
if (get_option('zanmantou_editor_autoreplace', true)){	
	// add filter @priotiry:10(default) @args:3
	add_filter('video_send_to_editor_url','ZanmantouPlugin_editor_videoaction', 10, 3);
	add_filter('audio_send_to_editor_url','ZanmantouPlugin_editor_audioaction', 10, 3);
	add_filter('media_send_to_editor','ZanmantouPlugin_editor_mediaaction', 10, 3);
}


/**
	1-click-download from mirror
*/
function Zanmantou_download_from_mirror(){
	// get file
	$download = file_get_contents(ZanmantouDownloadURL);
	
	// store file
	file_put_contents(basename(ZanmantouDownloadURL), $download);
	
	// unzip
	$zip = new ZipArchive();
	$res = $zip->open(basename(ZanmantouDownloadURL));
	if ($res === TRUE) {
		// extract player
		$zip->extractTo(dirname(__FILE__).'/player/');
		$zip->close();
		echo '<strong>Zanmantou download complete.</strong>';
	}else{
		echo '<strong>Zanmantou download/unzip failed.</strong>';
	}
}


/**
	BACKUP/RESTORE player files on upgrade
*/

// backup files -> move player package files to parent folder
function zanmantou_update_backup(){
	if (is_dir(dirname(__FILE__).'/player')){
		rename(dirname(__FILE__).'/player', dirname(dirname(__FILE__)).'/_zanmantou_backup');
	}
}

// restore files -> move player package back to plugin dir
function zanmantou_update_restore(){
	if (is_dir(dirname(dirname(__FILE__)).'/_zanmantou_backup')){
		rename(dirname(dirname(__FILE__)).'/_zanmantou_backup', dirname(__FILE__).'/player');
	}
}

// update/install events
add_filter('upgrader_pre_install', 'zanmantou_update_backup', 10, 0);
add_filter('upgrader_post_install', 'zanmantou_update_restore', 10, 0);

/**
	CACHE UPDATE/CLEAR
*/
function zanmantou_clear_cache($postID){
	// get cache folder url	
	$dir = dirname(__FILE__).'/cache/'.$postID.'/';
	
	// remove cache files
	if (is_dir($dir)){
		$files = scandir($dir);
		foreach ($files as $file){
			if ($file!='.' && $file!='..'){
				unlink($dir.$file);	
			}
		}
	}
}
add_action('save_post', 'zanmantou_clear_cache', 10, 1);
?>