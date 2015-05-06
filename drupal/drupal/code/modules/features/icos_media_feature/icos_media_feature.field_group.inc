<?php
/**
 * @file
 * icos_media_feature.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function icos_media_feature_field_group_info() {
  $export = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|file|icos_document|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'file';
  $field_group->bundle = 'icos_document';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'field_category',
      1 => 'field_image',
      2 => 'field_ingress',
      3 => 'filename',
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
  $export['group_content|file|icos_document|form'] = $field_group;

  return $export;
}
