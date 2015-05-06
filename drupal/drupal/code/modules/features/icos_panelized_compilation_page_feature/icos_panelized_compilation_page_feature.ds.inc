<?php
/**
 * @file
 * icos_panelized_compilation_page_feature.ds.inc
 */

/**
 * Implements hook_ds_field_settings_info().
 */
function icos_panelized_compilation_page_feature_ds_field_settings_info() {
  $export = array();

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'fieldable_panels_pane|content_block_pane|ingress_on_the_right';
  $ds_fieldsetting->entity_type = 'fieldable_panels_pane';
  $ds_fieldsetting->bundle = 'content_block_pane';
  $ds_fieldsetting->view_mode = 'ingress_on_the_right';
  $ds_fieldsetting->settings = array(
    'title_ds' => array(
      'weight' => '2',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h3',
        'class' => '',
      ),
    ),
  );
  $export['fieldable_panels_pane|content_block_pane|ingress_on_the_right'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'fieldable_panels_pane|content_block_pane|link_as_button';
  $ds_fieldsetting->entity_type = 'fieldable_panels_pane';
  $ds_fieldsetting->bundle = 'content_block_pane';
  $ds_fieldsetting->view_mode = 'link_as_button';
  $ds_fieldsetting->settings = array(
    'title_ds' => array(
      'weight' => '2',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h3',
        'class' => '',
      ),
    ),
  );
  $export['fieldable_panels_pane|content_block_pane|link_as_button'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'fieldable_panels_pane|content_block_pane|original_aspect_image';
  $ds_fieldsetting->entity_type = 'fieldable_panels_pane';
  $ds_fieldsetting->bundle = 'content_block_pane';
  $ds_fieldsetting->view_mode = 'original_aspect_image';
  $ds_fieldsetting->settings = array(
    'title_ds' => array(
      'weight' => '3',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h3',
        'class' => '',
      ),
    ),
  );
  $export['fieldable_panels_pane|content_block_pane|original_aspect_image'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'fieldable_panels_pane|content_block|block';
  $ds_fieldsetting->entity_type = 'fieldable_panels_pane';
  $ds_fieldsetting->bundle = 'content_block';
  $ds_fieldsetting->view_mode = 'block';
  $ds_fieldsetting->settings = array(
    'title_ds' => array(
      'weight' => '0',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h3',
        'class' => '',
      ),
    ),
  );
  $export['fieldable_panels_pane|content_block|block'] = $ds_fieldsetting;

  return $export;
}

/**
 * Implements hook_ds_layout_settings_info().
 */
function icos_panelized_compilation_page_feature_ds_layout_settings_info() {
  $export = array();

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'fieldable_panels_pane|content_block_pane|ingress_on_the_right';
  $ds_layout->entity_type = 'fieldable_panels_pane';
  $ds_layout->bundle = 'content_block_pane';
  $ds_layout->view_mode = 'ingress_on_the_right';
  $ds_layout->layout = 'two_col_without_styles';
  $ds_layout->settings = array(
    'regions' => array(
      'left' => array(
        0 => 'field_image',
        1 => 'field_body',
      ),
      'right' => array(
        2 => 'title',
        3 => 'field_ingress',
        4 => 'group_button',
        5 => 'field_link',
      ),
    ),
    'fields' => array(
      'field_image' => 'left',
      'field_body' => 'left',
      'title' => 'right',
      'field_ingress' => 'right',
      'group_button' => 'right',
      'field_link' => 'right',
    ),
    'classes' => array(),
    'wrappers' => array(
      'left' => 'div',
      'right' => 'div',
    ),
    'layout_wrapper' => 'div',
    'layout_attributes' => '',
    'layout_attributes_merge' => 1,
    'layout_link_attribute' => '',
    'layout_link_custom' => '',
  );
  $export['fieldable_panels_pane|content_block_pane|ingress_on_the_right'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'fieldable_panels_pane|content_block_pane|link_as_button';
  $ds_layout->entity_type = 'fieldable_panels_pane';
  $ds_layout->bundle = 'content_block_pane';
  $ds_layout->view_mode = 'link_as_button';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'field_image',
        1 => 'title',
        2 => 'field_body',
        3 => 'field_ingress',
        4 => 'field_link',
        5 => 'group_button',
      ),
    ),
    'fields' => array(
      'field_image' => 'ds_content',
      'title' => 'ds_content',
      'field_body' => 'ds_content',
      'field_ingress' => 'ds_content',
      'field_link' => 'ds_content',
      'group_button' => 'ds_content',
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
  $export['fieldable_panels_pane|content_block_pane|link_as_button'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'fieldable_panels_pane|content_block_pane|link_as_title';
  $ds_layout->entity_type = 'fieldable_panels_pane';
  $ds_layout->bundle = 'content_block_pane';
  $ds_layout->view_mode = 'link_as_title';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'group_hidden',
        1 => 'title',
        2 => 'field_image',
        3 => 'field_link',
        4 => 'group_arrow_link',
        5 => 'field_body',
        6 => 'field_ingress',
      ),
    ),
    'fields' => array(
      'group_hidden' => 'ds_content',
      'title' => 'ds_content',
      'field_image' => 'ds_content',
      'field_link' => 'ds_content',
      'group_arrow_link' => 'ds_content',
      'field_body' => 'ds_content',
      'field_ingress' => 'ds_content',
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
  $export['fieldable_panels_pane|content_block_pane|link_as_title'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'fieldable_panels_pane|content_block_pane|original_aspect_image';
  $ds_layout->entity_type = 'fieldable_panels_pane';
  $ds_layout->bundle = 'content_block_pane';
  $ds_layout->view_mode = 'original_aspect_image';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'field_image',
        1 => 'title',
        2 => 'field_body',
        3 => 'field_ingress',
        4 => 'field_link',
        5 => 'group_button',
      ),
    ),
    'fields' => array(
      'field_image' => 'ds_content',
      'title' => 'ds_content',
      'field_body' => 'ds_content',
      'field_ingress' => 'ds_content',
      'field_link' => 'ds_content',
      'group_button' => 'ds_content',
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
  $export['fieldable_panels_pane|content_block_pane|original_aspect_image'] = $ds_layout;

  return $export;
}

/**
 * Implements hook_ds_view_modes_info().
 */
function icos_panelized_compilation_page_feature_ds_view_modes_info() {
  $export = array();

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'ingress_on_the_right';
  $ds_view_mode->label = 'Description/legend on the right';
  $ds_view_mode->entities = array(
    'fieldable_panels_pane' => 'fieldable_panels_pane',
  );
  $export['ingress_on_the_right'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'link_as_button';
  $ds_view_mode->label = 'Link as button';
  $ds_view_mode->entities = array(
    'fieldable_panels_pane' => 'fieldable_panels_pane',
  );
  $export['link_as_button'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'link_as_title';
  $ds_view_mode->label = 'Link as title';
  $ds_view_mode->entities = array(
    'fieldable_panels_pane' => 'fieldable_panels_pane',
  );
  $export['link_as_title'] = $ds_view_mode;

  $ds_view_mode = new stdClass();
  $ds_view_mode->api_version = 1;
  $ds_view_mode->view_mode = 'original_aspect_image';
  $ds_view_mode->label = 'Original aspect image';
  $ds_view_mode->entities = array(
    'fieldable_panels_pane' => 'fieldable_panels_pane',
  );
  $export['original_aspect_image'] = $ds_view_mode;

  return $export;
}
