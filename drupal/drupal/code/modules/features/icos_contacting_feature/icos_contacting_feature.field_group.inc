<?php
/**
 * @file
 * icos_contacting_feature.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function icos_contacting_feature_field_group_info() {
  $export = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_configuration|node|contact_person|form';
  $field_group->group_name = 'group_configuration';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'contact_person';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Configuration',
    'weight' => '4',
    'children' => array(
      0 => 'field_icos_component',
      1 => 'field_country',
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
  $export['group_configuration|node|contact_person|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|node|contact_person|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'contact_person';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'field_title',
      1 => 'field_organisation',
      2 => 'field_email',
      3 => 'field_phone',
      4 => 'field_image',
      5 => 'title',
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
  $export['group_content|node|contact_person|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|taxonomy_term|icos_component|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'taxonomy_term';
  $field_group->bundle = 'icos_component';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'name',
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
  $export['group_content|taxonomy_term|icos_component|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|taxonomy_term|organisation|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'taxonomy_term';
  $field_group->bundle = 'organisation';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'name',
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
  $export['group_content|taxonomy_term|organisation|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_text_wrapper|node|contact_person|author';
  $field_group->group_name = 'group_text_wrapper';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'contact_person';
  $field_group->mode = 'author';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Text wrapper',
    'weight' => '1',
    'children' => array(
      0 => 'field_email',
      1 => 'field_icos_component',
      2 => 'field_organisation',
      3 => 'field_phone',
      4 => 'field_title',
      5 => 'field_country',
      6 => 'title',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Text wrapper',
      'instance_settings' => array(
        'classes' => 'text-wrapper',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_text_wrapper|node|contact_person|author'] = $field_group;

  return $export;
}
