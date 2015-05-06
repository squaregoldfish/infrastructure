<?php
/**
 * @file
 * icos_panelized_compilation_page_feature.panelizer.inc
 */

/**
 * Implements hook_panelizer_defaults().
 */
function icos_panelized_compilation_page_feature_panelizer_defaults() {
  $export = array();

  $panelizer = new stdClass();
  $panelizer->disabled = FALSE; /* Edit this to true to make a default panelizer disabled initially */
  $panelizer->api_version = 1;
  $panelizer->name = 'node:panelized_compilation_page:default';
  $panelizer->title = 'Default';
  $panelizer->panelizer_type = 'node';
  $panelizer->panelizer_key = 'panelized_compilation_page';
  $panelizer->no_blocks = FALSE;
  $panelizer->css_id = '';
  $panelizer->css = '';
  $panelizer->pipeline = 'ipe';
  $panelizer->contexts = array();
  $panelizer->relationships = array();
  $panelizer->access = array();
  $panelizer->view_mode = 'page_manager';
  $panelizer->css_class = '';
  $panelizer->title_element = 'H2';
  $panelizer->link_to_entity = TRUE;
  $panelizer->extra = array();
  $display = new panels_display();
  $display->layout = 'small_on_top';
  $display->layout_settings = array();
  $display->panel_settings = array(
    'style_settings' => array(
      'default' => NULL,
      'center' => NULL,
      'top' => NULL,
      'left' => NULL,
      'middle' => NULL,
      'right' => NULL,
      'bottom' => NULL,
      'title' => NULL,
      '2-1-top-1' => NULL,
      '2-1-top-2' => NULL,
      'full-top' => NULL,
      '3-col-1' => NULL,
      '3-col-2' => NULL,
      '3-col-3' => NULL,
      '2-col-1' => NULL,
      '2-col-2' => NULL,
      '2-1-bottom-1' => NULL,
      '2-1-bottom-2' => NULL,
      'full-bottom' => NULL,
      '2_1_top_1' => NULL,
      '2_1_top_2' => NULL,
      'full_top' => NULL,
      '3_col_1' => NULL,
      '3_col_2' => NULL,
      '3_col_3' => NULL,
      '2_col_1' => NULL,
      '2_col_2' => NULL,
      '2_1_bottom_1' => NULL,
      '2_1_bottom_2' => NULL,
      'full_bottom' => NULL,
      'top_2_1_1' => NULL,
      'top_2_1_2' => NULL,
      'col_3_1' => NULL,
      'col_3_2' => NULL,
      'col_3_3' => NULL,
      'col_2_1' => NULL,
      'col_2_2' => NULL,
      'bottom_2_1_1' => NULL,
      'bottom_2_1_2' => NULL,
    ),
  );
  $display->cache = array();
  $display->title = '%node:title';
  $display->uuid = 'e9eedfd5-82f6-42ed-ba79-d70bec4b3dcd';
  $display->content = array();
  $display->panels = array();
    $pane = new stdClass();
    $pane->pid = 'new-b28bfc60-3bf5-4600-bd71-5387712082b9';
    $pane->panel = 'title';
    $pane->type = 'page_title';
    $pane->subtype = 'page_title';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'markup' => 'h1',
      'class' => '',
      'id' => '',
      'override_title' => 0,
      'override_title_text' => '',
      'override_title_heading' => 'h2',
    );
    $pane->cache = array();
    $pane->style = array(
      'style' => 'default',
      'settings' => NULL,
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 0;
    $pane->locks = array();
    $pane->uuid = 'b28bfc60-3bf5-4600-bd71-5387712082b9';
    $display->content['new-b28bfc60-3bf5-4600-bd71-5387712082b9'] = $pane;
    $display->panels['title'][0] = 'new-b28bfc60-3bf5-4600-bd71-5387712082b9';
    $pane = new stdClass();
    $pane->pid = 'new-3b743e1b-6f20-4f80-9016-9c14d5d4de45';
    $pane->panel = 'title';
    $pane->type = 'entity_field';
    $pane->subtype = 'node:field_ingress';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'label' => 'hidden',
      'formatter' => 'text_default',
      'delta_limit' => 0,
      'delta_offset' => '0',
      'delta_reversed' => FALSE,
      'formatter_settings' => array(),
      'context' => 'panelizer',
      'override_title' => 0,
      'override_title_text' => '',
      'override_title_heading' => 'h2',
    );
    $pane->cache = array();
    $pane->style = array(
      'settings' => array(
        'title' => array(
          'element' => 'no_wrapper',
          'attributes' => array(
            'id' => '',
            'class' => '',
          ),
        ),
        'content' => array(
          'element' => 'summary',
          'attributes' => array(
            'id' => '',
            'class' => '',
          ),
        ),
        'theme' => 0,
      ),
      'style' => 'wrapper_element',
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 1;
    $pane->locks = array();
    $pane->uuid = '3b743e1b-6f20-4f80-9016-9c14d5d4de45';
    $display->content['new-3b743e1b-6f20-4f80-9016-9c14d5d4de45'] = $pane;
    $display->panels['title'][1] = 'new-3b743e1b-6f20-4f80-9016-9c14d5d4de45';
    $pane = new stdClass();
    $pane->pid = 'new-ed641ddb-f927-41d9-9dce-c60ddacf3d3a';
    $pane->panel = 'top_2_1_1';
    $pane->type = 'entity_field';
    $pane->subtype = 'node:body';
    $pane->shown = TRUE;
    $pane->access = array();
    $pane->configuration = array(
      'label' => 'hidden',
      'formatter' => 'text_default',
      'delta_limit' => 0,
      'delta_offset' => '0',
      'delta_reversed' => FALSE,
      'formatter_settings' => array(),
      'context' => 'panelizer',
      'override_title' => 0,
      'override_title_text' => '',
      'override_title_heading' => 'h2',
    );
    $pane->cache = array();
    $pane->style = array(
      'settings' => NULL,
    );
    $pane->css = array();
    $pane->extras = array();
    $pane->position = 0;
    $pane->locks = array();
    $pane->uuid = 'ed641ddb-f927-41d9-9dce-c60ddacf3d3a';
    $display->content['new-ed641ddb-f927-41d9-9dce-c60ddacf3d3a'] = $pane;
    $display->panels['top_2_1_1'][0] = 'new-ed641ddb-f927-41d9-9dce-c60ddacf3d3a';
  $display->hide_title = PANELS_TITLE_FIXED;
  $display->title_pane = '0';
  $panelizer->display = $display;
  $export['node:panelized_compilation_page:default'] = $panelizer;

  return $export;
}
