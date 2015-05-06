<?php
/**
 * @file
 * icos_contacting_feature.ds.inc
 */

/**
 * Implements hook_ds_field_settings_info().
 */
function icos_contacting_feature_ds_field_settings_info() {
  $export = array();

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|contact_person|alternative_teaser';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'contact_person';
  $ds_fieldsetting->view_mode = 'alternative_teaser';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '1',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h4',
        'class' => '',
      ),
    ),
  );
  $export['node|contact_person|alternative_teaser'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|contact_person|author';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'contact_person';
  $ds_fieldsetting->view_mode = 'author';
  $ds_fieldsetting->settings = array(
    'title' => array(
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
  $export['node|contact_person|author'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|contact_person|default';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'contact_person';
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
  $export['node|contact_person|default'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|contact_person|teaser';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'contact_person';
  $ds_fieldsetting->view_mode = 'teaser';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '1',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h4',
        'class' => '',
      ),
    ),
  );
  $export['node|contact_person|teaser'] = $ds_fieldsetting;

  $ds_fieldsetting = new stdClass();
  $ds_fieldsetting->api_version = 1;
  $ds_fieldsetting->id = 'node|contact_person|teaser_with_country';
  $ds_fieldsetting->entity_type = 'node';
  $ds_fieldsetting->bundle = 'contact_person';
  $ds_fieldsetting->view_mode = 'teaser_with_country';
  $ds_fieldsetting->settings = array(
    'title' => array(
      'weight' => '1',
      'label' => 'hidden',
      'format' => 'default',
      'formatter_settings' => array(
        'link' => '0',
        'wrapper' => 'h4',
        'class' => '',
      ),
    ),
  );
  $export['node|contact_person|teaser_with_country'] = $ds_fieldsetting;

  return $export;
}

/**
 * Implements hook_ds_layout_settings_info().
 */
function icos_contacting_feature_ds_layout_settings_info() {
  $export = array();

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|contact_person|alternative_teaser';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'contact_person';
  $ds_layout->view_mode = 'alternative_teaser';
  $ds_layout->layout = 'one_third';
  $ds_layout->settings = array(
    'regions' => array(
      'left' => array(
        0 => 'field_image',
      ),
      'right' => array(
        1 => 'title',
        2 => 'field_title',
        3 => 'field_organisation',
        4 => 'field_icos_component',
        5 => 'field_email',
        6 => 'field_phone',
      ),
    ),
    'fields' => array(
      'field_image' => 'left',
      'title' => 'right',
      'field_title' => 'right',
      'field_organisation' => 'right',
      'field_icos_component' => 'right',
      'field_email' => 'right',
      'field_phone' => 'right',
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
  $export['node|contact_person|alternative_teaser'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|contact_person|author';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'contact_person';
  $ds_layout->view_mode = 'author';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'field_image',
        1 => 'group_text_wrapper',
        2 => 'title',
        3 => 'field_title',
        4 => 'field_email',
        5 => 'field_phone',
        6 => 'field_organisation',
        7 => 'field_icos_component',
        8 => 'field_country',
      ),
    ),
    'fields' => array(
      'field_image' => 'ds_content',
      'group_text_wrapper' => 'ds_content',
      'title' => 'ds_content',
      'field_title' => 'ds_content',
      'field_email' => 'ds_content',
      'field_phone' => 'ds_content',
      'field_organisation' => 'ds_content',
      'field_icos_component' => 'ds_content',
      'field_country' => 'ds_content',
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
  $export['node|contact_person|author'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|contact_person|default';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'contact_person';
  $ds_layout->view_mode = 'default';
  $ds_layout->layout = 'small_on_top_ds';
  $ds_layout->settings = array(
    'regions' => array(
      'title' => array(
        0 => 'title',
      ),
      'top_2_1_1' => array(
        1 => 'field_title',
        3 => 'field_organisation',
        4 => 'field_email',
        5 => 'field_phone',
        6 => 'field_icos_component',
        7 => 'field_country',
      ),
      'top_2_1_2' => array(
        2 => 'field_image',
      ),
    ),
    'fields' => array(
      'title' => 'title',
      'field_title' => 'top_2_1_1',
      'field_image' => 'top_2_1_2',
      'field_organisation' => 'top_2_1_1',
      'field_email' => 'top_2_1_1',
      'field_phone' => 'top_2_1_1',
      'field_icos_component' => 'top_2_1_1',
      'field_country' => 'top_2_1_1',
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
  $export['node|contact_person|default'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|contact_person|teaser';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'contact_person';
  $ds_layout->view_mode = 'teaser';
  $ds_layout->layout = 'one_third';
  $ds_layout->settings = array(
    'regions' => array(
      'left' => array(
        0 => 'field_image',
      ),
      'right' => array(
        1 => 'title',
        2 => 'field_title',
        3 => 'field_organisation',
        4 => 'field_email',
        5 => 'field_phone',
      ),
    ),
    'fields' => array(
      'field_image' => 'left',
      'title' => 'right',
      'field_title' => 'right',
      'field_organisation' => 'right',
      'field_email' => 'right',
      'field_phone' => 'right',
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
  $export['node|contact_person|teaser'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'node|contact_person|teaser_with_country';
  $ds_layout->entity_type = 'node';
  $ds_layout->bundle = 'contact_person';
  $ds_layout->view_mode = 'teaser_with_country';
  $ds_layout->layout = 'one_third';
  $ds_layout->settings = array(
    'regions' => array(
      'left' => array(
        0 => 'field_image',
      ),
      'right' => array(
        1 => 'title',
        2 => 'field_title',
        3 => 'field_organisation',
        4 => 'field_icos_component',
        5 => 'field_email',
        6 => 'field_phone',
        7 => 'field_country',
      ),
    ),
    'fields' => array(
      'field_image' => 'left',
      'title' => 'right',
      'field_title' => 'right',
      'field_organisation' => 'right',
      'field_icos_component' => 'right',
      'field_email' => 'right',
      'field_phone' => 'right',
      'field_country' => 'right',
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
  $export['node|contact_person|teaser_with_country'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'taxonomy_term|country|form';
  $ds_layout->entity_type = 'taxonomy_term';
  $ds_layout->bundle = 'country';
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
  $export['taxonomy_term|country|form'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'taxonomy_term|icos_component|form';
  $ds_layout->entity_type = 'taxonomy_term';
  $ds_layout->bundle = 'icos_component';
  $ds_layout->view_mode = 'form';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'group_content',
        1 => 'name',
        2 => 'path',
      ),
      'hidden' => array(
        3 => 'description',
        4 => '_add_existing_field',
      ),
    ),
    'fields' => array(
      'group_content' => 'ds_content',
      'name' => 'ds_content',
      'path' => 'ds_content',
      'description' => 'hidden',
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
  $export['taxonomy_term|icos_component|form'] = $ds_layout;

  $ds_layout = new stdClass();
  $ds_layout->api_version = 1;
  $ds_layout->id = 'taxonomy_term|organisation|form';
  $ds_layout->entity_type = 'taxonomy_term';
  $ds_layout->bundle = 'organisation';
  $ds_layout->view_mode = 'form';
  $ds_layout->layout = 'ds_1col';
  $ds_layout->settings = array(
    'regions' => array(
      'ds_content' => array(
        0 => 'group_content',
        1 => 'name',
        2 => 'path',
      ),
      'hidden' => array(
        3 => 'description',
        4 => '_add_existing_field',
      ),
    ),
    'fields' => array(
      'group_content' => 'ds_content',
      'name' => 'ds_content',
      'path' => 'ds_content',
      'description' => 'hidden',
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
  $export['taxonomy_term|organisation|form'] = $ds_layout;

  return $export;
}
