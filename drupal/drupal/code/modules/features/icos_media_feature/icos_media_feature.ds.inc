<?php
/**
 * @file
 * icos_media_feature.ds.inc
 */

/**
 * Implements hook_ds_layout_settings_info().
 */
function icos_media_feature_ds_layout_settings_info() {
  $export = array();

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'file|icos_document|form';
  $ds_layout->entity_type = 'file';
  $ds_layout->bundle = 'icos_document';
  $ds_layout->view_mode = 'form';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'group_content',
        2 => 'filename',
        3 => 'field_ingress',
        4 => 'field_category',
        5 => 'field_image',
      ),
      'hidden' => array(
        1 => 'preview',
        6 => '_add_existing_field',
      ),
    ),
    'fields' => array(
      'group_content' => 'ds_content',
      'preview' => 'hidden',
      'filename' => 'ds_content',
      'field_ingress' => 'ds_content',
      'field_category' => 'ds_content',
      'field_image' => 'ds_content',
      '_add_existing_field' => 'hidden',
    ),
    'classes' => array(),
    'wrappers' => array(
      'ds_content' => 'div',
    ),
    'layout_wrapper' => 'div',
    'layout_attributes' => '',
    'layout_attributes_merge' => 1,
    'layout_link_attribute' => '',
    'layout_link_custom' => '',
  );
  $export['file|icos_document|form'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'file|icos_document|teaser';
  $ds_layout->entity_type = 'file';
  $ds_layout->bundle = 'icos_document';
  $ds_layout->view_mode = 'teaser';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'field_image',
        1 => 'icos_file_name',
        2 => 'field_ingress',
        3 => 'file',
      ),
    ),
    'fields' => array(
      'field_image' => 'ds_content',
      'icos_file_name' => 'ds_content',
      'field_ingress' => 'ds_content',
      'file' => 'ds_content',
    ),
    'classes' => array(),
    'wrappers' => array(
      'ds_content' => 'div',
    ),
    'layout_wrapper' => 'div',
    'layout_attributes' => '',
    'layout_attributes_merge' => 1,
    'layout_link_attribute' => '',
    'layout_link_custom' => '',
  );
  $export['file|icos_document|teaser'] = $ds_layout;

  return $export;
}

/**
 * Implements hook_ds_view_modes_info().
 */
function icos_media_feature_ds_view_modes_info() {
  $export = array();

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'large';
  $ds_view_mode->label = 'Large';
  $ds_view_mode->entities = array(
    'file' => 'file',
  );
  $export['large'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'medium';
  $ds_view_mode->label = 'Medium';
  $ds_view_mode->entities = array(
    'file' => 'file',
  );
  $export['medium'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'original';
  $ds_view_mode->label = 'Original';
  $ds_view_mode->entities = array(
    'file' => 'file',
  );
  $export['original'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'square';
  $ds_view_mode->label = 'Square';
  $ds_view_mode->entities = array(
    'file' => 'file',
  );
  $export['square'] = $ds_view_mode;

  return $export;
}
