<?php
/**
 * @file
 * icos_news_feature.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function icos_news_feature_field_group_info() {
  $export = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_configuration|node|news|form';
  $field_group->group_name = 'group_configuration';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'news';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Configuration',
    'weight' => '1',
    'children' => array(
      0 => 'field_header_image',
      1 => 'field_date_with_end',
    ),
    'format_type' => 'tab',
    'format_settings' => array(
      'formatter' => 'closed',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-configuration field-group-tab',
        'required_fields' => 1,
      ),
    ),
  );
  $export['group_configuration|node|news|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|node|news|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'news';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'body',
      1 => 'field_image',
      2 => 'field_ingress',
      3 => 'title',
    ),
    'format_type' => 'tab',
    'format_settings' => array(
      'formatter' => 'closed',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-content field-group-tab',
        'required_fields' => 1,
      ),
    ),
  );
  $export['group_content|node|news|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_summary|node|news|default';
  $field_group->group_name = 'group_summary';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'news';
  $field_group->mode = 'default';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Summary',
    'weight' => '1',
    'children' => array(
      0 => 'field_ingress',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Summary',
      'instance_settings' => array(
        'classes' => '',
        'element' => 'summary',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_summary|node|news|default'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_summary|node|news|node_original_aspect_image';
  $field_group->group_name = 'group_summary';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'news';
  $field_group->mode = 'node_original_aspect_image';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Summary',
    'weight' => '1',
    'children' => array(
      0 => 'field_ingress',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Summary',
      'instance_settings' => array(
        'classes' => '',
        'element' => 'summary',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_summary|node|news|node_original_aspect_image'] = $field_group;

  return $export;
}