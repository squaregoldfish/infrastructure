<?php

/**
 * Override or insert variables into the maintenance page template.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
function broscience_preprocess_maintenance_page(&$vars) {
  // When a variable is manipulated or added in preprocess_html or
  // preprocess_page, that same work is probably needed for the maintenance page
  // as well, so we can just re-use those functions to do that work here.
  // broscience_preprocess_html($vars);
  // broscience_preprocess_page($vars);

  // This preprocessor will also be used if the db is inactive. To ensure your
  // theme is used, add the following line to your settings.php file:
  // $conf['maintenance_theme'] = 'broscience';
  // Also, check $vars['db_is_active'] before doing any db queries.
}

/**
 * Implements hook_modernizr_load_alter().
 *
 * @return
 *   An array to be output as yepnope testObjects.
 */
/* -- Delete this line if you want to use this function
function broscience_modernizr_load_alter(&$load) {

}
// */

/**
 * Implements hook_preprocess_html()
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_html(&$vars) {

}
// */

/**
 * Implements template_preprocess_page().
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
function broscience_preprocess_page(&$vars) {

	// Init the variables
	$paths = array();
	$node = array();
	$background_image_styles = array(
  		'icos_header',
  		'icos_header_medium',
  		'icos_header_small'
	);


	if (isset($vars['node'])) {
		$node = $vars['node'];
	}


    // Set the Header background dynamically from the node Header image field
	if (! empty($node->field_header_image)) {
		$wrapped_node = entity_metadata_wrapper('node', $node);
		$background_image = $wrapped_node->field_header_image->value();
  		// Get three sizes of the image
  		foreach($background_image_styles as $style_name) {
			// Use the full URL so that the image styles get created correctly
			$url = image_style_url($style_name, $background_image['uri']);
			$paths[$style_name] = $url;
		}

	} else {

		$image = variable_get('broscience_style_header_image');
		$imageMedium = variable_get('broscience_style_header_image_medium');
		$imageSmall = variable_get('broscience_style_header_image_small');

		if ($image && $imageMedium && $imageSmall) {
			$paths['icos_header'] = $image;
			$paths['icos_header_medium'] = $imageMedium;
			$paths['icos_header_small'] = $imageSmall;


		// Use the default from the theme
		} else {
			$theme_path = drupal_get_path('theme', 'broscience');
			foreach($background_image_styles as $style_name) {
				$paths[$style_name] = $theme_path . '/img/' . $style_name . '.jpg';
			}
		}
	}



	$tint = '';
	if (variable_get('broscience_style_header_tint')) {
    	$tint = '#header .tint {background-color: rgba(' . variable_get('broscience_style_header_tint') . ')}';
	}

	$logoPadding = "";
	if (variable_get('broscience_style_header_logo_padding')) {
		$logoPadding = '#logo img {padding-top: ' . variable_get('broscience_style_header_logo_padding') . 'px; padding-bottom: ' . variable_get('broscience_style_header_logo_padding') . 'px; width: auto;}';
	}

	$menuButtonColor = '';
	if (variable_get('broscience_style_menu_button_color')) {
		$menuButtonColor = '#block-menu-block-2 ul.menu li.leaf a.active-trail, #block-menu-block-2 ul.menu li.leaf a:hover {background-color: ' . variable_get('broscience_style_menu_button_color') . '}';
	}

	$hideH2 = '';
	if (variable_get('broscience_style_disable_hide_h2')) {
		$hideH2 = '.block-menu-block h2 {display: none}';
	}

  	$noPadding = '';
  	if (variable_get('broscience_style_disable_no_padding')) {
		$noPadding .= '.field-body h4 {padding: 1rem 0rem 0rem 0rem}';
    	$noPadding .= '.field-body p {padding: 0rem 0rem 0rem 0rem}';
  	}

	$contentsTitleColor = '';
	$titleColor = '#0A96F0';
	if (variable_get('broscience_style_contents_title_color')) {
		$titleColor = variable_get('broscience_style_contents_title_color');

		$contentsTitleColor = 'div.pane-content h1 {color: ' . variable_get('broscience_style_contents_title_color') . '}';
	}

  	$contentsElementColor = '';
  	$elementColor = '#0A96F0';
  	if (variable_get('broscience_style_contents_element_color')) {
		$elementColor = variable_get('broscience_style_contents_element_color');

    	$contentsElementColor .= '.field-title h1 {color: ' . $elementColor . '}';
    	$contentsElementColor .= '.field-title h3 a {color: ' . $elementColor . '}';
		$contentsElementColor .= '.field-title a {color: ' . $elementColor . '}';
    	$contentsElementColor .= '.node .button .field-link a  {background-color: ' . $elementColor . '}';
    	$contentsElementColor .= 'div.vertical-tabs .vertical-tabs-list .vertical-tab-button a:hover {background-color: ' . $elementColor . '}';
    	$contentsElementColor .= 'div.vertical-tabs .vertical-tabs-list .vertical-tab-button.selected a {background-color: ' . $elementColor . '}';
    	$contentsElementColor .= 'div.vertical-tabs .vertical-tabs-list .vertical-tab-button.selected a::after {border-color: transparent transparent transparent ' . $elementColor . '}';
  	}

  	$threeColPanels = '';
  	$threeColPanels .= '.three-col {margin-top: 40px;}';
  	$threeColPanels .= '.three-col .first { }';
  	$threeColPanels .= '.three-col .second { }';
  	$threeColPanels .= '.three-col .third { }';


	$vars['page']['broscience_styles'] = ""
	."<style>"
		."#header {"
		."background-size: cover;"
		."background-image: url(".$paths['icos_header_small'].");"
		."}"
		."@media all and (min-width: 513px) {"
		."#header {"
		."background-image: url(".$paths['icos_header_medium'].");"
		."}"
		."} "
		."@media all and (min-width: 1025px) {"
		."#header {"
		."background-image: url(".$paths['icos_header'].");"
		."}"
		."} "

		.".field-title span {margin-left: 5px;}"

		. $tint
		. $logoPadding
		. $menuButtonColor
		. $hideH2
    	. $noPadding
		. $contentsTitleColor
		. $contentsElementColor
		. $threeColPanels

	."</style>"
	;




	if (variable_get('broscience_style_menu_use_submenu')) {
		drupal_add_js('jQuery(document).ready(function () {'

    		.'if( jQuery("#block-menu-block-1 li.expanded").length && screen.availWidth > 800 ) {'
            	.'var submenu = jQuery("#block-menu-block-1 li.expanded ul.menu").detach();'
				.'jQuery("#block-menu-block-1 div.menu-block-1").after(submenu);'
			.'}'

		.'});', 'inline');

	}

	if (variable_get('broscience_style_iframe_sizing')) {
		drupal_add_js('jQuery(document).ready(function () {'

			.'if( jQuery("div.responsive_frames_wrapper").length ) {'
             	.'var w = jQuery("div.responsive_frames_wrapper iframe").attr("width");'
             	.'var h = jQuery("div.responsive_frames_wrapper iframe").attr("height");'
             	.'jQuery("div.responsive_frames_wrapper").css({width: w, height: h});'
			.'}'

		.'});', 'inline');

	}

	if (variable_get('broscience_style_menu_use_left_submenu')) {
		drupal_add_js(array('broscience_style' => array('use_submenu' => 'yes')), 'setting');

	}

	if (variable_get('broscience_style_menu_use_breadcrumb')) {
		drupal_add_js('jQuery(document).ready(function () {'

			.'jQuery("#breadcrumb").css({"color": "' . $elementColor . '"});'
			.'jQuery("#breadcrumb a").css({"color": "' . $elementColor . '"});'

		.'});', 'inline');

	} else {
		drupal_add_js('jQuery(document).ready(function () {'
			.'jQuery("#breadcrumb").remove();'
		.'});', 'inline');
	}


	$modulePath = drupal_get_path('module', 'broscience_style');
	drupal_add_js(array('broscience_style' => array('titleColor' => $titleColor, 'elementColor' => $elementColor, 'modulePath' => $modulePath)), 'setting');
	drupal_add_js(drupal_get_path('module', 'broscience_style') . '/broscience_style.js');

}

/**
 * Override or insert variables into the region templates.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_region(&$vars) {

}
// */

/**
 * Override or insert variables into the block templates.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_block(&$vars) {

}
// */

/**
 * Override or insert variables into the entity template.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_entity(&$vars) {

}
// */

/**
 * Override or insert variables into the node template.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_node(&$vars) {
  $node = $vars['node'];
}
// */

/**
 * Override or insert variables into the field template.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 * @param $hook
 *   The name of the template being rendered ("field" in this case.)
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_field(&$vars, $hook) {

}
// */

/**
 * Override or insert variables into the comment template.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_comment(&$vars) {
  $comment = $vars['comment'];
}
// */

/**
 * Override or insert variables into the views template.
 *
 * @param $vars
 *   An array of variables to pass to the theme template.
 */
/* -- Delete this line if you want to use this function
function broscience_preprocess_views_view(&$vars) {
  $view = $vars['view'];
}
// */


/**
 * Override or insert css on the site.
 *
 * @param $css
 *   An array of all CSS items being requested on the page.
 */
/* -- Delete this line if you want to use this function
function broscience_css_alter(&$css) {

}
// */

/**
 * Override or insert javascript on the site.
 *
 * @param $js
 *   An array of all JavaScript being presented on the page.
 */
/* -- Delete this line if you want to use this function
function broscience_js_alter(&$js) {

}
// */
