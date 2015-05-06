<?php
/**
 * @file
 * icos_controller_feature.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function icos_controller_feature_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "ds" && $api == "ds") {
    return array("version" => "1");
  }
  if ($module == "slick" && $api == "slick_default_preset") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_fe_date_custom_date_formats().
 */
function icos_controller_feature_fe_date_custom_date_formats() {
  $custom_date_formats = array();
  $custom_date_formats['Y'] = 'Y';
  return $custom_date_formats;
}

/**
 * Implements hook_date_format_types().
 */
function icos_controller_feature_date_format_types() {
  $format_types = array();
  // Exported date format type: year_only
  $format_types['year_only'] = 'Year only';
  return $format_types;
}
