<?php
/**
 * @file
 * icos_contacting_feature.features.field_instance.inc
 */

/**
 * Implements hook_field_default_field_instances().
 */
function icos_contacting_feature_field_default_field_instances() {
  $field_instances = array();

  // Exported field_instance: 'node-contact_person-field_country'
  $field_instances['node-contact_person-field_country'] = array(
    'bundle' => 'contact_person',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'Country of the contact person.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 13,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 8,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 13,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 7,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 7,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_country',
    'label' => 'Country',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'options',
      'settings' => array(),
      'type' => 'options_select',
      'weight' => 5,
    ),
  );

  // Exported field_instance: 'node-contact_person-field_email'
  $field_instances['node-contact_person-field_email'] = array(
    'bundle' => 'contact_person',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'Primary email address of the contact person.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'module' => 'email',
        'settings' => array(),
        'type' => 'email_default',
        'weight' => 5,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'invisimail',
        'settings' => array(
          'encoder' => 'js_entities',
          'link' => 1,
        ),
        'type' => 'invisimail_js_entities',
        'weight' => 4,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'invisimail',
        'settings' => array(
          'encoder' => 'js_entities',
          'link' => 1,
        ),
        'type' => 'invisimail_js_entities',
        'weight' => 10,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'invisimail',
        'settings' => array(
          'encoder' => 'js_entities',
          'link' => 1,
        ),
        'type' => 'invisimail_js_entities',
        'weight' => 4,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'email',
        'settings' => array(),
        'type' => 'email_default',
        'weight' => 5,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_email',
    'label' => 'Email',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'email',
      'settings' => array(
        'size' => 60,
      ),
      'type' => 'email_textfield',
      'weight' => 11,
    ),
  );

  // Exported field_instance: 'node-contact_person-field_icos_component'
  $field_instances['node-contact_person-field_icos_component'] = array(
    'bundle' => 'contact_person',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'ICOS component the contact person belongs to.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 4,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 7,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 12,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 6,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 4,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_icos_component',
    'label' => 'ICOS component',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'options',
      'settings' => array(),
      'type' => 'options_select',
      'weight' => 4,
    ),
  );

  // Exported field_instance: 'node-contact_person-field_image'
  $field_instances['node-contact_person-field_image'] = array(
    'bundle' => 'contact_person',
    'deleted' => 0,
    'description' => 'A photo of the contact person.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'module' => 'file_entity',
        'settings' => array(
          'file_view_mode' => 'square',
        ),
        'type' => 'file_rendered',
        'weight' => 0,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'file_entity',
        'settings' => array(
          'file_view_mode' => 'square',
        ),
        'type' => 'file_rendered',
        'weight' => 0,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'file_entity',
        'settings' => array(
          'file_view_mode' => 'large',
        ),
        'type' => 'file_rendered',
        'weight' => 2,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'file_entity',
        'settings' => array(
          'file_view_mode' => 'square',
        ),
        'type' => 'file_rendered',
        'weight' => 0,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'file_entity',
        'settings' => array(
          'file_view_mode' => 'square',
        ),
        'type' => 'file_rendered',
        'weight' => 0,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_image',
    'label' => 'Photo',
    'required' => 0,
    'settings' => array(
      'alt_field' => 0,
      'default_image' => 0,
      'file_directory' => 'contact_person/field_image',
      'file_extensions' => 'png gif jpg jpeg',
      'max_filesize' => '',
      'max_resolution' => '',
      'min_resolution' => '',
      'title_field' => 0,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'media',
      'settings' => array(
        'allowed_schemes' => array(
          'public' => 'public',
        ),
        'allowed_types' => array(
          'icos_document' => 0,
          'icos_image' => 'icos_image',
        ),
        'browser_plugins' => array(
          'media_default--media_browser_1' => 'media_default--media_browser_1',
          'media_default--media_browser_my_files' => 'media_default--media_browser_my_files',
          'upload' => 'upload',
        ),
      ),
      'type' => 'media_generic',
      'weight' => 7,
    ),
  );

  // Exported field_instance: 'node-contact_person-field_organisation'
  $field_instances['node-contact_person-field_organisation'] = array(
    'bundle' => 'contact_person',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'Organisation the contact person belongs to.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 3,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 6,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 9,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 3,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'ds',
        'settings' => array(
          'taxonomy_term_link' => 0,
          'taxonomy_term_separator' => ' ',
        ),
        'type' => 'ds_taxonomy_separator',
        'weight' => 3,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_organisation',
    'label' => 'Organisation',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'options',
      'settings' => array(),
      'type' => 'options_select',
      'weight' => 10,
    ),
  );

  // Exported field_instance: 'node-contact_person-field_phone'
  $field_instances['node-contact_person-field_phone'] = array(
    'bundle' => 'contact_person',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'Primary phone number of the contact person.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'module' => 'telephone',
        'settings' => array(
          'title' => '',
        ),
        'type' => 'telephone_link',
        'weight' => 6,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'telephone',
        'settings' => array(
          'title' => '',
        ),
        'type' => 'telephone_link',
        'weight' => 5,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'telephone',
        'settings' => array(
          'title' => '',
        ),
        'type' => 'telephone_link',
        'weight' => 11,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'telephone',
        'settings' => array(
          'title' => '',
        ),
        'type' => 'telephone_link',
        'weight' => 5,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'telephone',
        'settings' => array(
          'title' => '',
        ),
        'type' => 'telephone_link',
        'weight' => 6,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_phone',
    'label' => 'Phone',
    'required' => 0,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'telephone',
      'settings' => array(
        'placeholder' => '',
      ),
      'type' => 'telephone_default',
      'weight' => 12,
    ),
  );

  // Exported field_instance: 'node-contact_person-field_title'
  $field_instances['node-contact_person-field_title'] = array(
    'bundle' => 'contact_person',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'Title of the person in the organisation like "Communicator" for example.',
    'display' => array(
      'alternative_teaser' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 2,
      ),
      'author' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 3,
      ),
      'default' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 1,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 2,
      ),
      'teaser_with_country' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 2,
      ),
    ),
    'entity_type' => 'node',
    'fences_wrapper' => 'div',
    'field_name' => 'field_title',
    'label' => 'Title',
    'required' => 0,
    'settings' => array(
      'better_formats' => array(
        'allowed_formats' => array(
          'plain_text' => 'plain_text',
          'wysiwyg' => 'wysiwyg',
        ),
        'allowed_formats_toggle' => 0,
        'default_order_toggle' => 0,
        'default_order_wrapper' => array(
          'formats' => array(
            'plain_text' => array(
              'weight' => 10,
            ),
            'wysiwyg' => array(
              'weight' => 0,
            ),
          ),
        ),
      ),
      'linkit' => array(
        'button_text' => 'Search',
        'enable' => 0,
        'profile' => '',
      ),
      'text_processing' => 0,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'text',
      'settings' => array(
        'size' => 60,
      ),
      'type' => 'text_textfield',
      'weight' => 9,
    ),
  );

  // Translatables
  // Included for use with string extractors like potx.
  t('A photo of the contact person.');
  t('Country');
  t('Country of the contact person.');
  t('Email');
  t('ICOS component');
  t('ICOS component the contact person belongs to.');
  t('Organisation');
  t('Organisation the contact person belongs to.');
  t('Phone');
  t('Photo');
  t('Primary email address of the contact person.');
  t('Primary phone number of the contact person.');
  t('Title');
  t('Title of the person in the organisation like "Communicator" for example.');

  return $field_instances;
}
