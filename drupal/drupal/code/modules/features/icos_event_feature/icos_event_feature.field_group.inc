<?php
/**
 * @file
 * icos_event_feature.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function icos_event_feature_field_group_info() {
  $export = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|node|event|alternative_teaser';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'event';
  $field_group->mode = 'alternative_teaser';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Button',
    'weight' => '3',
    'children' => array(
      0 => 'field_link',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Button',
      'instance_settings' => array(
        'classes' => 'button',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_button|node|event|alternative_teaser'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|node|event|default';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'event';
  $field_group->mode = 'default';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Button',
    'weight' => '3',
    'children' => array(
      0 => 'field_link',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Button',
      'instance_settings' => array(
        'classes' => 'button',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_button|node|event|default'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|node|event|teaser';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'event';
  $field_group->mode = 'teaser';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Button',
    'weight' => '3',
    'children' => array(
      0 => 'field_link',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Button',
      'instance_settings' => array(
        'classes' => 'button',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_button|node|event|teaser'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_configuration|node|event|form';
  $field_group->group_name = 'group_configuration';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'event';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Configuration',
    'weight' => '2',
    'children' => array(
      0 => 'field_header_image',
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
  $export['group_configuration|node|event|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|node|event|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'event';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'body',
      1 => 'field_link',
      2 => 'field_date_with_end',
      3 => 'field_image',
      4 => 'title',
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
  $export['group_content|node|event|form'] = $field_group;

  return $export;
}
