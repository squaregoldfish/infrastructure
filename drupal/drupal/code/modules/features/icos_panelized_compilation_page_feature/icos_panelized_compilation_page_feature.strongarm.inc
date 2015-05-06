<?php
/**
 * @file
 * icos_panelized_compilation_page_feature.strongarm.inc
 */

/**
 * Implements hook_strongarm().
 */
function icos_panelized_compilation_page_feature_strongarm() {
  $export = array();

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'diff_enable_revisions_page_node_panelized_compilation_page';
  $strongarm->value = 0;
  $export['diff_enable_revisions_page_node_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'diff_show_preview_changes_node_panelized_compilation_page';
  $strongarm->value = 0;
  $export['diff_show_preview_changes_node_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'diff_view_mode_preview_node_panelized_compilation_page';
  $strongarm->value = 'diff_standard';
  $export['diff_view_mode_preview_node_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'field_bundle_settings_fieldable_panels_pane__content_block';
  $strongarm->value = array(
    'view_modes' => array(
      'full' => array(
        'custom_settings' => FALSE,
      ),
      'diff_standard' => array(
        'custom_settings' => FALSE,
      ),
      'token' => array(
        'custom_settings' => FALSE,
      ),
      'block' => array(
        'custom_settings' => TRUE,
      ),
    ),
    'extra_fields' => array(
      'form' => array(
        'title' => array(
          'weight' => '1',
        ),
      ),
      'display' => array(
        'title' => array(
          'default' => array(
            'weight' => '-5',
            'visible' => FALSE,
          ),
          'block' => array(
            'weight' => '3',
            'visible' => FALSE,
          ),
        ),
      ),
    ),
  );
  $export['field_bundle_settings_fieldable_panels_pane__content_block'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'field_bundle_settings_fieldable_panels_pane__content_block_pane';
  $strongarm->value = array(
    'view_modes' => array(
      'block' => array(
        'custom_settings' => FALSE,
      ),
      'full' => array(
        'custom_settings' => FALSE,
      ),
      'preview' => array(
        'custom_settings' => TRUE,
      ),
      'diff_standard' => array(
        'custom_settings' => FALSE,
      ),
      'token' => array(
        'custom_settings' => FALSE,
      ),
      'link_as_button' => array(
        'custom_settings' => TRUE,
      ),
      'link_as_title' => array(
        'custom_settings' => TRUE,
      ),
      'body_on_the_right' => array(
        'custom_settings' => FALSE,
      ),
      'ingress_on_the_right' => array(
        'custom_settings' => TRUE,
      ),
      'original_aspect_image' => array(
        'custom_settings' => TRUE,
      ),
    ),
    'extra_fields' => array(
      'form' => array(
        'title' => array(
          'weight' => '3',
        ),
      ),
      'display' => array(
        'title' => array(
          'default' => array(
            'weight' => '0',
            'visible' => FALSE,
          ),
          'block' => array(
            'weight' => '5',
            'visible' => FALSE,
          ),
          'preview' => array(
            'weight' => '1',
            'visible' => TRUE,
          ),
          'link_as_button' => array(
            'weight' => '1',
            'visible' => TRUE,
          ),
          'link_as_title' => array(
            'weight' => '1',
            'visible' => TRUE,
          ),
          'body_on_the_right' => array(
            'weight' => '0',
            'visible' => FALSE,
          ),
          'ingress_on_the_right' => array(
            'weight' => '2',
            'visible' => TRUE,
          ),
          'original_aspect_image' => array(
            'weight' => '2',
            'visible' => TRUE,
          ),
        ),
      ),
    ),
  );
  $export['field_bundle_settings_fieldable_panels_pane__content_block_pane'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'field_bundle_settings_node__panelized_compilation_page';
  $strongarm->value = array(
    'view_modes' => array(
      'teaser' => array(
        'custom_settings' => FALSE,
      ),
      'full' => array(
        'custom_settings' => FALSE,
      ),
      'rss' => array(
        'custom_settings' => FALSE,
      ),
      'diff_standard' => array(
        'custom_settings' => FALSE,
      ),
      'token' => array(
        'custom_settings' => FALSE,
      ),
      'revision' => array(
        'custom_settings' => FALSE,
      ),
    ),
    'extra_fields' => array(
      'form' => array(
        'title' => array(
          'weight' => '1',
        ),
        'path' => array(
          'weight' => '2',
        ),
      ),
      'display' => array(),
    ),
  );
  $export['field_bundle_settings_node__panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'menu_options_panelized_compilation_page';
  $strongarm->value = array(
    0 => 'main-menu',
  );
  $export['menu_options_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'menu_parent_panelized_compilation_page';
  $strongarm->value = 'main-menu:0';
  $export['menu_parent_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'node_options_panelized_compilation_page';
  $strongarm->value = array(
    0 => 'status',
  );
  $export['node_options_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'node_preview_panelized_compilation_page';
  $strongarm->value = '0';
  $export['node_preview_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'node_submitted_panelized_compilation_page';
  $strongarm->value = 0;
  $export['node_submitted_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'page_manager_node_view_disabled';
  $strongarm->value = FALSE;
  $export['page_manager_node_view_disabled'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'panelizer_defaults_node_panelized_compilation_page';
  $strongarm->value = array(
    'status' => 1,
    'view modes' => array(
      'page_manager' => array(
        'status' => 1,
        'default' => 1,
        'choice' => 0,
      ),
      'default' => array(
        'status' => 0,
        'default' => 0,
        'choice' => 0,
      ),
      'teaser' => array(
        'status' => 0,
        'default' => 0,
        'choice' => 0,
      ),
    ),
  );
  $export['panelizer_defaults_node_panelized_compilation_page'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'panelizer_node:panelized_compilation_page_allowed_layouts';
  $strongarm->value = 'O:22:"panels_allowed_layouts":4:{s:9:"allow_new";b:1;s:11:"module_name";s:41:"panelizer_node:panelized_compilation_page";s:23:"allowed_layout_settings";a:12:{s:8:"flexible";b:0;s:14:"twocol_stacked";b:0;s:13:"twocol_bricks";b:0;s:6:"twocol";b:0;s:25:"threecol_33_34_33_stacked";b:0;s:17:"threecol_33_34_33";b:0;s:25:"threecol_25_50_25_stacked";b:0;s:17:"threecol_25_50_25";b:0;s:6:"onecol";b:0;s:13:"sample_layout";b:0;s:12:"small_on_top";b:1;s:4:"test";b:1;}s:10:"form_state";N;}';
  $export['panelizer_node:panelized_compilation_page_allowed_layouts'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'panelizer_node:panelized_compilation_page_allowed_layouts_default';
  $strongarm->value = 0;
  $export['panelizer_node:panelized_compilation_page_allowed_layouts_default'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'panelizer_node:panelized_compilation_page_allowed_types';
  $strongarm->value = array(
    'page_title-page_title' => 'page_title-page_title',
    'vocabulary_terms-vocabulary_terms' => 0,
    'user_links-user_links' => 0,
    'user_picture-user_picture' => 0,
    'user_profile-user_profile' => 0,
    'user_signature-user_signature' => 0,
    'term_description-term_description' => 0,
    'term_list-term_list' => 0,
    'term_name-term_name' => 0,
    'page_actions-page_actions' => 0,
    'page_breadcrumb-page_breadcrumb' => 0,
    'page_feed_icons-page_feed_icons' => 0,
    'page_help-page_help' => 0,
    'page_logo-page_logo' => 0,
    'page_messages-page_messages' => 0,
    'page_primary_links-page_primary_links' => 0,
    'page_secondary_links-page_secondary_links' => 0,
    'page_site_name-page_site_name' => 0,
    'page_slogan-page_slogan' => 0,
    'page_tabs-page_tabs' => 0,
    'node_form_author-node_form_author' => 0,
    'node_form_buttons-node_form_buttons' => 0,
    'node_form_language-node_form_language' => 0,
    'node_form_log-node_form_log' => 0,
    'node_form_menu-node_form_menu' => 0,
    'node_form_path-node_form_path' => 0,
    'node_form_publishing-node_form_publishing' => 0,
    'node_form_title-node_form_title' => 0,
    'node_attachments-node_attachments' => 0,
    'node_author-node_author' => 0,
    'node_body-node_body' => 0,
    'node_content-node_content' => 0,
    'node_created-node_created' => 0,
    'node_links-node_links' => 0,
    'node_terms-node_terms' => 0,
    'node_title-node_title' => 0,
    'node_type_desc-node_type_desc' => 0,
    'node_updated-node_updated' => 0,
    'node-node' => 0,
    'form-form' => 0,
    'comment_links-comment_links' => 0,
    'file_content-file_content' => 0,
    'file_display-file_display' => 0,
    'views_attachments-views_attachments' => 0,
    'views_empty-views_empty' => 0,
    'views_exposed-views_exposed' => 0,
    'views_feed-views_feed' => 0,
    'views_footer-views_footer' => 0,
    'views_header-views_header' => 0,
    'views_pager-views_pager' => 0,
    'views_row-views_row' => 0,
    'views_view-views_view' => 0,
    'dsc-dsc' => 0,
    'panelizer_form_default-panelizer_form_default' => 0,
    'token-node:source' => 0,
    'token-node:log' => 0,
    'token-node:content-type' => 0,
    'token-node:diff' => 0,
    'token-node:diff-markdown' => 0,
    'token-node:menu-link' => 0,
    'token-node:nid' => 0,
    'token-node:vid' => 0,
    'token-node:title' => 0,
    'token-node:body' => 0,
    'token-node:summary' => 0,
    'token-node:language' => 0,
    'token-node:url' => 0,
    'token-node:edit-url' => 0,
    'token-node:created' => 0,
    'token-node:changed' => 0,
    'token-node:author' => 0,
    'token-node:original' => 0,
    'token-node:is-new' => 0,
    'token-node:status' => 0,
    'token-node:promote' => 0,
    'token-node:sticky' => 0,
    'token-node:revision' => 0,
    'token-node:field-ingress' => 0,
    'token-node:field-header-image' => 0,
    'token-node:field-link' => 0,
    'token-node:field-date-with-end' => 0,
    'token-node:field-image' => 0,
    'token-node:field-contact-reference' => 0,
    'token-node:field-email' => 0,
    'token-node:field-icos-component' => 0,
    'token-node:field-organisation' => 0,
    'token-node:field-phone' => 0,
    'token-node:field-title' => 0,
    'token-node:field-country' => 0,
    'token-node:field_ingress' => 0,
    'token-node:field_link' => 0,
    'token-node:field_image' => 0,
    'token-node:field_email' => 0,
    'token-node:field_icos_component' => 0,
    'token-node:field_organisation' => 0,
    'token-node:field_phone' => 0,
    'token-node:field_title' => 0,
    'token-node:field_country' => 0,
    'token-node:field_header_image' => 0,
    'token-node:field_date_with_end' => 0,
    'token-node:field_contact_reference' => 0,
    'token-content-type:name' => 0,
    'token-content-type:machine-name' => 0,
    'token-content-type:description' => 0,
    'token-content-type:node-count' => 0,
    'token-content-type:edit-url' => 0,
    'token-term:edit-url' => 0,
    'token-term:parents' => 0,
    'token-term:root' => 0,
    'token-term:tid' => 0,
    'token-term:name' => 0,
    'token-term:description' => 0,
    'token-term:node-count' => 0,
    'token-term:url' => 0,
    'token-term:vocabulary' => 0,
    'token-term:parent' => 0,
    'token-term:original' => 0,
    'token-term:weight' => 0,
    'token-term:parents-all' => 0,
    'token-vocabulary:machine-name' => 0,
    'token-vocabulary:edit-url' => 0,
    'token-vocabulary:vid' => 0,
    'token-vocabulary:name' => 0,
    'token-vocabulary:description' => 0,
    'token-vocabulary:node-count' => 0,
    'token-vocabulary:term-count' => 0,
    'token-vocabulary:original' => 0,
    'token-file:basename' => 0,
    'token-file:extension' => 0,
    'token-file:size-raw' => 0,
    'token-file:type' => 0,
    'token-file:download-url' => 0,
    'token-file:fid' => 0,
    'token-file:name' => 0,
    'token-file:path' => 0,
    'token-file:mime' => 0,
    'token-file:size' => 0,
    'token-file:url' => 0,
    'token-file:timestamp' => 0,
    'token-file:owner' => 0,
    'token-file:original' => 0,
    'token-file:field-ingress' => 0,
    'token-file:field-image' => 0,
    'token-file:field-category' => 0,
    'token-file:field-file-image-alt-text' => 0,
    'token-file:field-file-image-title-text' => 0,
    'token-file:field_ingress' => 0,
    'token-file:field_image' => 0,
    'token-file:field_category' => 0,
    'token-user:cancel-url' => 0,
    'token-user:one-time-login-url' => 0,
    'token-user:roles' => 0,
    'token-user:uid' => 0,
    'token-user:name' => 0,
    'token-user:mail' => 0,
    'token-user:url' => 0,
    'token-user:edit-url' => 0,
    'token-user:last-login' => 0,
    'token-user:created' => 0,
    'token-user:original' => 0,
    'token-user:last-access' => 0,
    'token-user:status' => 0,
    'token-user:theme' => 0,
    'token-current-user:ip-address' => 0,
    'token-menu-link:mlid' => 0,
    'token-menu-link:title' => 0,
    'token-menu-link:url' => 0,
    'token-menu-link:parent' => 0,
    'token-menu-link:parents' => 0,
    'token-menu-link:root' => 0,
    'token-menu-link:menu' => 0,
    'token-menu-link:edit-url' => 0,
    'token-current-page:title' => 0,
    'token-current-page:url' => 0,
    'token-current-page:page-number' => 0,
    'token-current-page:query' => 0,
    'token-url:path' => 0,
    'token-url:relative' => 0,
    'token-url:absolute' => 0,
    'token-url:brief' => 0,
    'token-url:unaliased' => 0,
    'token-url:args' => 0,
    'token-array:first' => 0,
    'token-array:last' => 0,
    'token-array:count' => 0,
    'token-array:reversed' => 0,
    'token-array:keys' => 0,
    'token-array:join' => 0,
    'token-array:value' => 0,
    'token-array:join-path' => 0,
    'token-random:number' => 0,
    'token-random:hash' => 0,
    'token-date-field-value:date' => 0,
    'token-date-field-value:to-date' => 0,
    'token-file-type:name' => 0,
    'token-file-type:machine-name' => 0,
    'token-file-type:count' => 0,
    'token-file-type:edit-url' => 0,
    'token-menu:name' => 0,
    'token-menu:machine-name' => 0,
    'token-menu:description' => 0,
    'token-menu:menu-link-count' => 0,
    'token-menu:edit-url' => 0,
    'token-site:name' => 0,
    'token-site:slogan' => 0,
    'token-site:mail' => 0,
    'token-site:url' => 0,
    'token-site:url-brief' => 0,
    'token-site:login-url' => 0,
    'token-site:current-user' => 0,
    'token-site:current-date' => 0,
    'token-site:current-page' => 0,
    'token-date:short' => 0,
    'token-date:medium' => 0,
    'token-date:long' => 0,
    'token-date:custom' => 0,
    'token-date:since' => 0,
    'token-date:raw' => 0,
    'token-date:html5_tools_iso8601' => 0,
    'token-date:year_only' => 0,
    'token-view:name' => 0,
    'token-view:description' => 0,
    'token-view:machine-name' => 0,
    'token-view:title' => 0,
    'token-view:url' => 0,
    'token-rules_text:value' => 0,
    'token-rules_integer:value' => 0,
    'token-rules_uri:value' => 0,
    'token-rules_token:value' => 0,
    'token-rules_decimal:value' => 0,
    'token-rules_date:value' => 0,
    'token-rules_duration:value' => 0,
    'token-fieldable_panels_pane:fpid' => 0,
    'token-fieldable_panels_pane:vid' => 0,
    'token-fieldable_panels_pane:is-new' => 0,
    'token-fieldable_panels_pane:title' => 0,
    'token-fieldable_panels_pane:admin-title' => 0,
    'token-fieldable_panels_pane:admin-description' => 0,
    'token-fieldable_panels_pane:category' => 0,
    'token-fieldable_panels_pane:link' => 0,
    'token-fieldable_panels_pane:path' => 0,
    'token-fieldable_panels_pane:path-raw' => 0,
    'token-fieldable_panels_pane:reusable' => 0,
    'token-fieldable_panels_pane:view-access' => 0,
    'token-fieldable_panels_pane:edit-access' => 0,
    'token-fieldable_panels_pane:uuid' => 0,
    'token-fieldable_panels_pane:vuuid' => 0,
    'token-fieldable_panels_pane:created' => 0,
    'token-fieldable_panels_pane:changed' => 0,
    'token-fieldable_panels_pane:log' => 0,
    'token-fieldable_panels_pane:revision' => 0,
    'token-fieldable_panels_pane:field-body' => 0,
    'token-fieldable_panels_pane:field-ingress' => 0,
    'token-fieldable_panels_pane:field-link' => 0,
    'token-fieldable_panels_pane:field-image' => 0,
    'token-fieldable_panels_pane:field_body' => 0,
    'token-fieldable_panels_pane:field_ingress' => 0,
    'token-fieldable_panels_pane:field_link' => 0,
    'token-fieldable_panels_pane:field_image' => 0,
    'token-rules_config:id' => 0,
    'token-rules_config:label' => 0,
    'token-rules_config:plugin' => 0,
    'token-rules_config:active' => 0,
    'token-rules_config:weight' => 0,
    'token-rules_config:status' => 0,
    'token-rules_config:dirty' => 0,
    'token-rules_config:module' => 0,
    'token-rules_config:owner' => 0,
    'token-rules_config:access-exposed' => 0,
    'token-list<fieldable_panels_pane>:0' => 0,
    'token-list<fieldable_panels_pane>:1' => 0,
    'token-list<fieldable_panels_pane>:2' => 0,
    'token-list<fieldable_panels_pane>:3' => 0,
    'token-list<node>:0' => 0,
    'token-list<node>:1' => 0,
    'token-list<node>:2' => 0,
    'token-list<node>:3' => 0,
    'token-list<file>:0' => 0,
    'token-list<file>:1' => 0,
    'token-list<file>:2' => 0,
    'token-list<file>:3' => 0,
    'token-list<term>:0' => 0,
    'token-list<term>:1' => 0,
    'token-list<term>:2' => 0,
    'token-list<term>:3' => 0,
    'token-list<vocabulary>:0' => 0,
    'token-list<vocabulary>:1' => 0,
    'token-list<vocabulary>:2' => 0,
    'token-list<vocabulary>:3' => 0,
    'token-list<user>:0' => 0,
    'token-list<user>:1' => 0,
    'token-list<user>:2' => 0,
    'token-list<user>:3' => 0,
    'token-list<rules_config>:0' => 0,
    'token-list<rules_config>:1' => 0,
    'token-list<rules_config>:2' => 0,
    'token-list<rules_config>:3' => 0,
    'token-list<date>:0' => 0,
    'token-list<date>:1' => 0,
    'token-list<date>:2' => 0,
    'token-list<date>:3' => 0,
    'entity_form_field-fieldable_panels_pane:field_body' => 0,
    'entity_form_field-fieldable_panels_pane:field_link' => 0,
    'entity_form_field-fieldable_panels_pane:field_image' => 0,
    'entity_form_field-fieldable_panels_pane:field_ingress' => 0,
    'entity_form_field-node:body' => 0,
    'entity_form_field-node:field_ingress' => 0,
    'entity_form_field-node:field_header_image' => 0,
    'entity_form_field-node:field_image' => 0,
    'entity_form_field-node:field_contact_reference' => 0,
    'entity_form_field-node:field_date_with_end' => 0,
    'entity_form_field-node:field_email' => 0,
    'entity_form_field-node:field_icos_component' => 0,
    'entity_form_field-node:field_organisation' => 0,
    'entity_form_field-node:field_phone' => 0,
    'entity_form_field-node:field_title' => 0,
    'entity_form_field-node:field_country' => 0,
    'entity_form_field-node:field_link' => 0,
    'entity_form_field-file:field_category' => 0,
    'entity_form_field-file:field_image' => 0,
    'entity_form_field-file:field_ingress' => 0,
    'entity_field-node:body' => 'entity_field-node:body',
    'entity_field-node:field_ingress' => 'entity_field-node:field_ingress',
    'entity_field-fieldable_panels_pane:field_body' => 0,
    'entity_field-fieldable_panels_pane:field_link' => 0,
    'entity_field-fieldable_panels_pane:field_image' => 0,
    'entity_field-fieldable_panels_pane:field_ingress' => 0,
    'entity_field-node:field_header_image' => 0,
    'entity_field-node:field_image' => 0,
    'entity_field-node:field_contact_reference' => 0,
    'entity_field-node:field_date_with_end' => 0,
    'entity_field-node:field_email' => 0,
    'entity_field-node:field_icos_component' => 0,
    'entity_field-node:field_organisation' => 0,
    'entity_field-node:field_phone' => 0,
    'entity_field-node:field_title' => 0,
    'entity_field-node:field_country' => 0,
    'entity_field-node:field_link' => 0,
    'entity_field-file:field_category' => 0,
    'entity_field-file:field_image' => 0,
    'entity_field-file:field_ingress' => 0,
    'entity_field_extra-fieldable_panels_pane:title' => 0,
    'entity_field_extra-node:minimal_share' => 0,
    'entity_field_extra-file:file' => 0,
    'entity_field_extra-file:icos_file_name' => 0,
    'entity_field_extra-taxonomy_term:description' => 0,
    'entity_field_extra-user:summary' => 0,
    'custom-custom' => 0,
    'block-blockify-blockify-logo' => 0,
    'block-blockify-blockify-page-title' => 0,
    'block-blockify-blockify-tabs' => 0,
    'block-context_ui-editor' => 0,
    'block-context_ui-devel' => 0,
    'block-diff-inline' => 0,
    'block-menu-devel' => 0,
    'block-menu-features' => 0,
    'block-menu_block-1' => 0,
    'block-menu_block-2' => 0,
    'block-minimal_share-minimal_share' => 0,
    'block-node-syndicate' => 0,
    'block-node-recent' => 0,
    'block-responsive_preview-controls' => 0,
    'block-shortcut-shortcuts' => 0,
    'block-system-powered-by' => 0,
    'block-system-help' => 0,
    'block-system-navigation' => 0,
    'block-system-management' => 0,
    'block-system-user-menu' => 0,
    'block-system-main-menu' => 0,
    'block-user-login' => 0,
    'block-user-new' => 0,
    'block-user-online' => 0,
    'block-devel-execute_php' => 0,
    'block-devel-switch_user' => 0,
    'entity_view-fieldable_panels_pane' => 0,
    'entity_view-node' => 0,
    'entity_view-file' => 0,
    'entity_view-taxonomy_term' => 0,
    'entity_view-user' => 0,
    'entity_view-rules_config' => 0,
    'fieldable_panels_pane-content_block_pane' => 'fieldable_panels_pane-content_block_pane',
    'fieldable_panels_pane-fpid:16' => 'fieldable_panels_pane-fpid:16',
    'fieldable_panels_pane-fpid:17' => 'fieldable_panels_pane-fpid:17',
    'fieldable_panels_pane-fpid:18' => 'fieldable_panels_pane-fpid:18',
    'fieldable_panels_pane-fpid:20' => 'fieldable_panels_pane-fpid:20',
    'fieldable_panels_pane-fpid:21' => 'fieldable_panels_pane-fpid:21',
    'fieldable_panels_pane-fpid:22' => 'fieldable_panels_pane-fpid:22',
    'fieldable_panels_pane-fpid:32' => 'fieldable_panels_pane-fpid:32',
    'fieldable_panels_pane-fpid:36' => 'fieldable_panels_pane-fpid:36',
    'fieldable_panels_pane-fpid:44' => 'fieldable_panels_pane-fpid:44',
    'fieldable_panels_pane-fpid:48' => 'fieldable_panels_pane-fpid:48',
    'fieldable_panels_pane-fpid:49' => 'fieldable_panels_pane-fpid:49',
    'fieldable_panels_pane-fpid:54' => 'fieldable_panels_pane-fpid:54',
    'fieldable_panels_pane-fieldable_panels_pane' => 0,
    'menu_tree-_active' => 0,
    'menu_tree-devel' => 0,
    'menu_tree-features' => 0,
    'menu_tree-main-menu' => 0,
    'menu_tree-management' => 0,
    'menu_tree-navigation' => 0,
    'menu_tree-user-menu' => 0,
    'views-icos_reusable_lists' => 0,
    'views-fieldable_pane_entities' => 0,
    'views-fieldable_pane_entity_revisions' => 0,
    'views-icos_reusable_file_lists' => 0,
    'views-media_default' => 0,
    'views_panes-icos_reusable_lists-reusable_teaser' => 'views_panes-icos_reusable_lists-reusable_teaser',
    'views_panes-icos_reusable_lists-reusable_contact_person' => 'views_panes-icos_reusable_lists-reusable_contact_person',
    'views_panes-icos_reusable_lists-resusable_contact_person_country' => 'views_panes-icos_reusable_lists-resusable_contact_person_country',
    'views_panes-icos_reusable_lists-reusable_contact_person_org' => 'views_panes-icos_reusable_lists-reusable_contact_person_org',
    'views_panes-icos_reusable_lists-reusable_carousel' => 'views_panes-icos_reusable_lists-reusable_carousel',
    'views_panes-icos_reusable_lists-reusable_event' => 'views_panes-icos_reusable_lists-reusable_event',
    'views_panes-icos_reusable_lists-reusable_date_link' => 'views_panes-icos_reusable_lists-reusable_date_link',
    'views_panes-icos_reusable_lists-reusable_acc_date_link' => 'views_panes-icos_reusable_lists-reusable_acc_date_link',
    'views_panes-icos_reusable_lists-reusable_contact_country' => 'views_panes-icos_reusable_lists-reusable_contact_country',
    'views_panes-icos_reusable_file_lists-reusable_documents' => 'views_panes-icos_reusable_file_lists-reusable_documents',
  );
  $export['panelizer_node:panelized_compilation_page_allowed_types'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'panelizer_node:panelized_compilation_page_allowed_types_default';
  $strongarm->value = 0;
  $export['panelizer_node:panelized_compilation_page_allowed_types_default'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'panelizer_node:panelized_compilation_page_default';
  $strongarm->value = array(
    'fieldable_panels_pane' => 'fieldable_panels_pane',
    'token' => 0,
    'entity_form_field' => 0,
    'entity_field' => 0,
    'entity_field_extra' => 0,
    'custom' => 0,
    'block' => 0,
    'entity_view' => 0,
    'menu_tree' => 0,
    'views' => 0,
    'views_panes' => 0,
    'other' => 0,
  );
  $export['panelizer_node:panelized_compilation_page_default'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'pathauto_node_panelized_compilation_page_pattern';
  $strongarm->value = '';
  $export['pathauto_node_panelized_compilation_page_pattern'] = $strongarm;

  return $export;
}
