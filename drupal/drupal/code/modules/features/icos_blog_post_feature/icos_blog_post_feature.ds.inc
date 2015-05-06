<?php
/**
 * @file
 * icos_blog_post_feature.ds.inc
 */

/**
 * Implements hook_ds_field_settings_info().
 */
function icos_blog_post_feature_ds_field_settings_info() {
  $export = array();

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|blog_post|date_and_link';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'blog_post';
  $ds_fieldsetting->view_mode = 'date_and_link';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '1',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '1',
        'wrapper' => 'span',
        'class' => '',
      ),
    ),
  );
  $export['node|blog_post|date_and_link'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|blog_post|default';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'blog_post';
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
  $export['node|blog_post|default'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|blog_post|teaser';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'blog_post';
  $ds_fieldsetting->view_mode = 'teaser';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '0',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '1',
        'wrapper' => 'h3',
        'class' => '',
      ),
    ),
  );
  $export['node|blog_post|teaser'] = $ds_fieldsetting;

  return $export;
}

/**
 * Implements hook_ds_layout_settings_info().
 */
function icos_blog_post_feature_ds_layout_settings_info() {
  $export = array();

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|blog_post|date_and_link';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'blog_post';
  $ds_layout->view_mode = 'date_and_link';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'field_date_with_end',
        1 => 'title',
      ),
    ),
    'fields' => array(
      'field_date_with_end' => 'ds_content',
      'title' => 'ds_content',
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
  $export['node|blog_post|date_and_link'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|blog_post|default';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'blog_post';
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
        3 => 'field_date_with_end',
        4 => 'body',
      ),
      'top_2_1_2' => array(
        5 => 'field_image',
      ),
      'bottom_2_1_2' => array(
        6 => 'field_contact_reference',
      ),
      'bottom_2_1_1' => array(
        7 => 'minimal_share',
      ),
    ),
    'fields' => array(
      'title' => 'title',
      'group_summary' => 'title',
      'field_ingress' => 'title',
      'field_date_with_end' => 'top_2_1_1',
      'body' => 'top_2_1_1',
      'field_image' => 'top_2_1_2',
      'field_contact_reference' => 'bottom_2_1_2',
      'minimal_share' => 'bottom_2_1_1',
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
  $export['node|blog_post|default'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|blog_post|node_original_aspect_image';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'blog_post';
  $ds_layout->view_mode = 'node_original_aspect_image';
  $ds_layout->layout = 'small_on_top_ds';
  $ds_layout->settings = array(
    'regions' => array(
      'title' => array(
        0 => 'group_summary',
        3 => 'field_ingress',
      ),
      'bottom_2_1_2' => array(
        1 => 'field_contact_reference',
      ),
      'top_2_1_1' => array(
        2 => 'field_date_with_end',
        4 => 'body',
      ),
      'top_2_1_2' => array(
        5 => 'field_image',
      ),
      'bottom_2_1_1' => array(
        6 => 'minimal_share',
      ),
    ),
    'fields' => array(
      'group_summary' => 'title',
      'field_contact_reference' => 'bottom_2_1_2',
      'field_date_with_end' => 'top_2_1_1',
      'field_ingress' => 'title',
      'body' => 'top_2_1_1',
      'field_image' => 'top_2_1_2',
      'minimal_share' => 'bottom_2_1_1',
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
  $export['node|blog_post|node_original_aspect_image'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|blog_post|teaser';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'blog_post';
  $ds_layout->view_mode = 'teaser';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'title',
        1 => 'field_date_with_end',
        2 => 'field_image',
        3 => 'field_ingress',
      ),
    ),
    'fields' => array(
      'title' => 'ds_content',
      'field_date_with_end' => 'ds_content',
      'field_image' => 'ds_content',
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
  $export['node|blog_post|teaser'] = $ds_layout;

  return $export;
}
