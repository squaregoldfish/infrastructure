<?php
/**
 * @file
 * icos_panelized_compilation_page_feature.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function icos_panelized_compilation_page_feature_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "ds" && $api == "ds") {
    return array("version" => "1");
  }
  if ($module == "field_group" && $api == "field_group") {
    return array("version" => "1");
  }
  if ($module == "fieldable_panels_panes" && $api == "fieldable_panels_pane_type") {
    return array("version" => "1");
  }
  if ($module == "panelizer" && $api == "panelizer") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_views_api().
 */
function icos_panelized_compilation_page_feature_views_api($module = NULL, $api = NULL) {
  return array("api" => "3.0");
}

/**
 * Implements hook_node_info().
 */
function icos_panelized_compilation_page_feature_node_info() {
  $items = array(
    'panelized_compilation_page' => array(
      'name' => t('Compilation page'),
      'base' => 'node_content',
      'description' => t('Compilation page is a combination of content blocks, views and liftups.'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
  );
  drupal_alter('node_info', $items);
  return $items;
}
