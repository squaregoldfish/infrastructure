<?php
/**
 * @file
 * icos_controller_feature.ds.inc
 */

/**
 * Implements hook_ds_layout_settings_info().
 */
function icos_controller_feature_ds_layout_settings_info() {
  $export = array();

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'taxonomy_term|category|form';
  $ds_layout->entity_type = 'taxonomy_term';
  $ds_layout->bundle = 'category';
  $ds_layout->view_mode = 'form';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'name',
        2 => 'path',
      ),
      'hidden' => array(
        1 => 'description',
        3 => '_add_existing_field',
      ),
    ),
    'fields' => array(
      'name' => 'ds_content',
      'description' => 'hidden',
      'path' => 'ds_content',
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
  $export['taxonomy_term|category|form'] = $ds_layout;

  return $export;
}

/**
 * Implements hook_ds_view_modes_info().
 */
function icos_controller_feature_ds_view_modes_info() {
  $export = array();

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'alternative_teaser';
  $ds_view_mode->label = 'Alternative teaser';
  $ds_view_mode->entities = array(
    'node' => 'node',
  );
  $export['alternative_teaser'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'author';
  $ds_view_mode->label = 'Author';
  $ds_view_mode->entities = array(
    'node' => 'node',
  );
  $export['author'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'date_and_link';
  $ds_view_mode->label = 'Date and link';
  $ds_view_mode->entities = array(
    'node' => 'node',
  );
  $export['date_and_link'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'node_original_aspect_image';
  $ds_view_mode->label = 'Original aspect image';
  $ds_view_mode->entities = array(
    'node' => 'node',
  );
  $export['node_original_aspect_image'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'teaser_with_country';
  $ds_view_mode->label = 'Teaser with country';
  $ds_view_mode->entities = array(
    'node' => 'node',
  );
  $export['teaser_with_country'] = $ds_view_mode;

  return $export;
}
