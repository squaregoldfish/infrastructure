<?php
/**
 * @file
 * icos_basic_page_feature.ds.inc
 */

/**
 * Implements hook_ds_field_settings_info().
 */
function icos_basic_page_feature_ds_field_settings_info() {
  $export = array();

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|basic_page|default';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'basic_page';
  $ds_fieldsetting->view_mode = 'default';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '0',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h1',
        'class' => '',
      ),
    ),
  );
  $export['node|basic_page|default'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|basic_page|node_original_aspect_image';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'basic_page';
  $ds_fieldsetting->view_mode = 'node_original_aspect_image';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '0',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h1',
        'class' => '',
      ),
    ),
  );
  $export['node|basic_page|node_original_aspect_image'] = $ds_fieldsetting;

  return $export;
}

/**
 * Implements hook_ds_layout_settings_info().
 */
function icos_basic_page_feature_ds_layout_settings_info() {
  $export = array();

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|basic_page|default';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'basic_page';
  $ds_layout->view_mode = 'default';
  $ds_layout->layout = 'small_on_top_ds';
  $ds_layout->settings = array(
    'regions' => array(
      'title' => array(
        0 => 'title',
        1 => 'group_summary',
        2 => 'field_ingress',
      ),
      'top_2_1_1' => array(
        3 => 'body',
      ),
      'top_2_1_2' => array(
        4 => 'field_image',
      ),
    ),
    'fields' => array(
      'title' => 'title',
      'group_summary' => 'title',
      'field_ingress' => 'title',
      'body' => 'top_2_1_1',
      'field_image' => 'top_2_1_2',
    ),
    'classes' => array(),
    'wrappers' => array(
      'title' => 'div',
      'top_2_1_1' => 'div',
      'top_2_1_2' => 'div',
      'full_top' => 'div',
      'col_3_1' => 'div',
      'col_3_2' => 'div',
      'col_3_3' => 'div',
      'col_2_1' => 'div',
      'col_2_2' => 'div',
      'bottom_2_1_1' => 'div',
      'bottom_2_1_2' => 'div',
      'full_bottom' => 'div',
    ),
    'layout_wrapper' => 'div',
    'layout_attributes' => '',
    'layout_attributes_merge' => 1,
    'layout_link_attribute' => '',
    'layout_link_custom' => '',
  );
  $export['node|basic_page|default'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|basic_page|node_original_aspect_image';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'basic_page';
  $ds_layout->view_mode = 'node_original_aspect_image';
  $ds_layout->layout = 'small_on_top_ds';
  $ds_layout->settings = array(
    'regions' => array(
      'title' => array(
        0 => 'title',
        1 => 'group_summary',
        3 => 'field_ingress',
      ),
      'top_2_1_1' => array(
        2 => 'body',
      ),
      'top_2_1_2' => array(
        4 => 'field_image',
      ),
    ),
    'fields' => array(
      'title' => 'title',
      'group_summary' => 'title',
      'body' => 'top_2_1_1',
      'field_ingress' => 'title',
      'field_image' => 'top_2_1_2',
    ),
    'classes' => array(),
    'wrappers' => array(
      'title' => 'div',
      'top_2_1_1' => 'div',
      'top_2_1_2' => 'div',
      'full_top' => 'div',
      'col_3_1' => 'div',
      'col_3_2' => 'div',
      'col_3_3' => 'div',
      'col_2_1' => 'div',
      'col_2_2' => 'div',
      'bottom_2_1_1' => 'div',
      'bottom_2_1_2' => 'div',
      'full_bottom' => 'div',
    ),
    'layout_wrapper' => 'div',
    'layout_attributes' => '',
    'layout_attributes_merge' => 1,
    'layout_link_attribute' => '',
    'layout_link_custom' => '',
  );
  $export['node|basic_page|node_original_aspect_image'] = $ds_layout;

  return $export;
}
