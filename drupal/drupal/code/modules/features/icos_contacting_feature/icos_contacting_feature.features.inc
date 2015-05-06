<?php
/**
 * @file
 * icos_contacting_feature.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function icos_contacting_feature_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "ds" && $api == "ds") {
    return array("version" => "1");
  }
  if ($module == "field_group" && $api == "field_group") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_node_info().
 */
function icos_contacting_feature_node_info() {
  $items = array(
    'contact_person' => array(
      'name' => t('Contact person'),
      'base' => 'node_content',
      'description' => t('Contact persons can be used in lists to show the focal points of ICOS organisations.'),
      'has_title' => '1',
      'title_label' => t('Name'),
      'help' => '',
    ),
  );
  drupal_alter('node_info', $items);
  return $items;
}
