<?php
/*
Description: Admin settings page for the zanmantou plugin
Author: Andi Dittrich
Author URI: http://www.a3non.org
License: X11 License (MIT License)

Copyright (c) 2010 Andi Dittrich

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
*/
?>
<?php if (!defined('ZanmantouPluginVersion')) die('DIRECT ACCESS PROHIBITED'); ?>

<div class="wrap">

<!-- title !-->
<div id="icon-options-general" class="icon32"><br /></div>
<h2>Zanmantou Web Audio/Video Player</h2>

<!-- license !-->
<div class="updated settings-error">
<p><strong>Note:</strong> The Zanmantou Player itself is licensed under a <strong>noncommercial license</strong> <a href="http://creativecommons.org/licenses/by-nc-nd/3.0/de/">CreativeCommons BY-NC-ND</a>. I.e. You may not use the player only for non-commercial purposes. It is also necessary to put a link on your website back to the project page (for example into the imprint). For details, please refer to the license on the <a href="http://zanmantou.a3non.org">project site</a>.</p>
</div>


<!-- 1-click-update !-->
<h2>Install/Upgrade</h2>
<p>
<form method="post" action="">
	<input type="hidden" name="zanmantou_download" value="1" />
    <div>Current Version: <strong><?php echo ZanmantouCurrentPlayerVersion ?></strong>, 
    	Latest Version: <strong><?php echo ZanmantouPlayerVersion ?></strong>
    </div>
	<div><input type="submit" value="1-click-download/update" /> (from mirror: <?php echo ZanmantouDownloadURL ?>)</div>
</form>
</p>
<?php
if (isset($_POST['zanmantou_download'])){
	Zanmantou_download_from_mirror();	
}
?>

<!-- not found message !-->
<?php if (!file_exists(dirname(__FILE__).'/player/Zanmantou3.swf')){ ?>
<div class="updated settings-error"><p><strong>Warning: </strong>Zanmantou Player not found in your plugin diretory. Please download the latest player package from <a href="http://download.a3non.org/zanmantou3/">Zanmantou download page</a> and upload the files into the Zanmantou plugin directory (<i><?php echo dirname(__FILE__); ?></i> or use the <strong>1-click-download</strong> button).</p></div>
<?php } ?>


<h2>Usage</h2>
<p><?php _e('Usage: Insert a zanmantou tag into your post/page to display the audio/video player or just adding videos using the media browser in the editor. Example:', 'zanmantou'); ?>
<strong>
<br />[zanmantou file="zanmantou.f4v" title="demo video"]
<br />[zanmantou file="zanmantou.f4v" type="video" width="500" height="500"]
<br />[zanmantou file="zanmantou.f4v" type="video" width="500" height="500" thumbnail="http://yourdomain.tld/videocoverimage.jpg"]</strong>
</p>

<form method="post" action="options.php">
    <?php settings_fields( 'zanmantou-settings-group' ); ?>
    
    <h2><?php _e('Single file mode', 'zanmantou'); ?></h2>
    <p><?php _e('This mode will be used if you want to display a single media file only (use attribute <strong>file=""</strong>).', 'zanmantou'); ?></p>
    
	<h4><?php _e('Default Settings (no media type specified)', 'zanmantou'); ?></h4>
    <table class="form-table">
        <tr valign="top">
        <th scope="row"><?php _e('Player Dimension', 'zanmantou'); ?></th>
        <td>
        <label for="zanmantou-sf-default-width"><?php _e('Width', 'zanmantou'); ?></label>
        <input name="zanmantou-sf-default-width" type="text" value="<?php echo get_option('zanmantou-sf-default-width', '600')?>" class="small-text" />
        <label for="zanmantou-sf-default-height"><?php _e('Height', 'zanmantou'); ?></label>
        <input name="zanmantou-sf-default-height" type="text" value="<?php echo get_option('zanmantou-sf-default-height', '400')?>" class="small-text" />
		</td>
        </tr>

        
        <tr valign="top">
        <th scope="row"><?php _e('Select Theme', 'zanmantou'); ?></th>
        <td><select name="zanmantou-sf-default-theme">
        	<?php			
			foreach ($themes as $theme){
				$selected = ($theme == get_option('zanmantou-sf-default-theme', 'darkgrey')) ? 'selected="selected"' : '';
				echo '<option value="'.$theme.'" '.$selected.'>'.$theme.'</option>';
			}			
			?>     	
        </select>
        </td>
        </tr>
    </table>

	<h4><?php _e('Video Files (.flv, .f4v, .mp4)', 'zanmantou'); ?></h4>
    <table class="form-table">
        <tr valign="top">
        <th scope="row"><?php _e('Player Dimension', 'zanmantou'); ?></th>
        <td>
        <label for="zanmantou-sf-video-width"><?php _e('Width', 'zanmantou'); ?></label>
        <input name="zanmantou-sf-video-width" type="text" value="<?php echo get_option('zanmantou-sf-video-width', '600')?>" class="small-text" />
        <label for="zanmantou-sf-video-height"><?php _e('Height', 'zanmantou'); ?></label>
        <input name="zanmantou-sf-video-height" type="text" value="<?php echo get_option('zanmantou-sf-video-height', '400')?>" class="small-text" />
		</td>
        </tr>

        
        <tr valign="top">
        <th scope="row"><?php _e('Select Theme', 'zanmantou'); ?></th>
        <td><select name="zanmantou-sf-video-theme">
        	<?php			
			foreach ($themes as $theme){
				$selected = ($theme == get_option('zanmantou-sf-video-theme', 'darkgrey')) ? 'selected="selected"' : '';
				echo '<option value="'.$theme.'" '.$selected.'>'.$theme.'</option>';
			}			
			?>     	
        </select>
        </td>
        </tr>
    </table>
    
    <h4><?php _e('Audio Files (.wav, .mp3)', 'zanmantou'); ?></h4>
    <table class="form-table">
        <tr valign="top">
        <th scope="row"><?php _e('Player Dimension', 'zanmantou'); ?></th>
        <td>
        <label for="zanmantou-sf-audio-width"><?php _e('Width', 'zanmantou'); ?></label>
        <input name="zanmantou-sf-audio-width" type="text" value="<?php echo get_option('zanmantou-sf-audio-width', '600')?>" class="small-text" />
        <label for="zanmantou-sf-audio-height"><?php _e('Height', 'zanmantou'); ?></label>
        <input name="zanmantou-sf-audio-height" type="text" value="<?php echo get_option('zanmantou-sf-audio-height', '400')?>" class="small-text" />
		</td>
        </tr>

        
        <tr valign="top">
        <th scope="row"><?php _e('Select Theme', 'zanmantou'); ?></th>
        <td><select name="zanmantou-sf-audio-theme">
        	<?php			
			foreach ($themes as $theme){
				$selected = ($theme == get_option('zanmantou-sf-audio-theme', 'darkgrey')) ? 'selected="selected"' : '';
				echo '<option value="'.$theme.'" '.$selected.'>'.$theme.'</option>';
			}			
			?>        	
        </select>
        </td>
        </tr>
    </table>
    
    <h3><?php _e('General', 'zanmantou'); ?></h3>
    <table class="form-table">
        <tr valign="top">
        <th scope="row"><?php _e('Replace media inserts with Zanmantou shortcodes'); ?></th>
        <td>
		<?php
			if(get_option('zanmantou_editor_autoreplace', true)){ 
				$checked = ' checked="checked" '; 
			}
			echo "<input ".$checked." name='zanmantou_editor_autoreplace' type='checkbox' />";
		?>        
        </td>
        </tr>
    </table>
    

    <p class="submit">
    <input type="submit" class="button-primary" value="<?php _e('Save Changes') ?>" />
    </p>

</form>

<h2>Credits</h2>
<p><a href="http://zanmantou.a3non.org/">Zanmantou</a> Wordpress Plugin is developed by <a href="http://www.a3non.org">Andi Dittrich</a>. It's release under the MIT X11 License.</p>

</div>
