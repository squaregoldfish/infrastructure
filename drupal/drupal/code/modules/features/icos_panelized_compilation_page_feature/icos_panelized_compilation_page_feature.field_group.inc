<?php
/**
 * @file
 * icos_panelized_compilation_page_feature.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function icos_panelized_compilation_page_feature_field_group_info() {
  $export = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_arrow_link|fieldable_panels_pane|content_block_pane|link_as_title';
  $field_group->group_name = 'group_arrow_link';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'link_as_title';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Arrow link',
    'weight' => '3',
    'children' => array(
      0 => 'field_link',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Arrow link',
      'instance_settings' => array(
        'classes' => 'arrow_link',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_arrow_link|fieldable_panels_pane|content_block_pane|link_as_title'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|fieldable_panels_pane|content_block_pane|block';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'block';
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
        'classes' => '',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => 'class="button"',
      ),
    ),
  );
  $export['group_button|fieldable_panels_pane|content_block_pane|block'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|fieldable_panels_pane|content_block_pane|ingress_on_the_right';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'ingress_on_the_right';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Button',
    'weight' => '4',
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
  $export['group_button|fieldable_panels_pane|content_block_pane|ingress_on_the_right'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|fieldable_panels_pane|content_block_pane|link_as_button';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'link_as_button';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Button',
    'weight' => '4',
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
  $export['group_button|fieldable_panels_pane|content_block_pane|link_as_button'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_button|fieldable_panels_pane|content_block_pane|original_aspect_image';
  $field_group->group_name = 'group_button';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'original_aspect_image';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Button',
    'weight' => '6',
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
  $export['group_button|fieldable_panels_pane|content_block_pane|original_aspect_image'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_configuration|fieldable_panels_pane|content_block_pane|form';
  $field_group->group_name = 'group_configuration';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Configuration',
    'weight' => '8',
    'children' => array(),
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
  $export['group_configuration|fieldable_panels_pane|content_block_pane|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_configuration|fieldable_panels_pane|content_block|form';
  $field_group->group_name = 'group_configuration';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Configuration',
    'weight' => '5',
    'children' => array(),
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
  $export['group_configuration|fieldable_panels_pane|content_block|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_configuration|node|panelized_compilation_page|form';
  $field_group->group_name = 'group_configuration';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'panelized_compilation_page';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Configuration',
    'weight' => '1',
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
  $export['group_configuration|node|panelized_compilation_page|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|fieldable_panels_pane|content_block_pane|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'field_body',
      1 => 'field_link',
      2 => 'field_image',
      3 => 'field_ingress',
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
  $export['group_content|fieldable_panels_pane|content_block_pane|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|fieldable_panels_pane|content_block|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'field_body',
      1 => 'field_link',
      2 => 'title',
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
  $export['group_content|fieldable_panels_pane|content_block|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_content|node|panelized_compilation_page|form';
  $field_group->group_name = 'group_content';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'panelized_compilation_page';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Content',
    'weight' => '0',
    'children' => array(
      0 => 'field_ingress',
      1 => 'body',
      2 => 'title',
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
  $export['group_content|node|panelized_compilation_page|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_hidden|fieldable_panels_pane|content_block_pane|ingress_on_the_right';
  $field_group->group_name = 'group_hidden';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'ingress_on_the_right';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Hidden',
    'weight' => '0',
    'children' => array(
      0 => 'title',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Hidden',
      'instance_settings' => array(
        'classes' => 'element-invisible',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_hidden|fieldable_panels_pane|content_block_pane|ingress_on_the_right'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_hidden|fieldable_panels_pane|content_block_pane|link_as_button';
  $field_group->group_name = 'group_hidden';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'link_as_button';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Hidden',
    'weight' => '0',
    'children' => array(
      0 => 'title',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Hidden',
      'instance_settings' => array(
        'classes' => 'element-invisible',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_hidden|fieldable_panels_pane|content_block_pane|link_as_button'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_hidden|fieldable_panels_pane|content_block_pane|link_as_title';
  $field_group->group_name = 'group_hidden';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'link_as_title';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Hidden',
    'weight' => '0',
    'children' => array(
      0 => 'title',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Hidden',
      'instance_settings' => array(
        'classes' => 'element-invisible',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_hidden|fieldable_panels_pane|content_block_pane|link_as_title'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_hidden|fieldable_panels_pane|content_block_pane|original_aspect_image';
  $field_group->group_name = 'group_hidden';
  $field_group->entity_type = 'fieldable_panels_pane';
  $field_group->bundle = 'content_block_pane';
  $field_group->mode = 'original_aspect_image';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Hidden',
    'weight' => '0',
    'children' => array(
      0 => 'title',
    ),
    'format_type' => 'html-element',
    'format_settings' => array(
      'label' => 'Hidden',
      'instance_settings' => array(
        'classes' => 'element-invisible',
        'element' => 'div',
        'show_label' => '0',
        'label_element' => 'div',
        'attributes' => '',
      ),
    ),
  );
  $export['group_hidden|fieldable_panels_pane|content_block_pane|original_aspect_image'] = $field_group;

  return $export;
}
