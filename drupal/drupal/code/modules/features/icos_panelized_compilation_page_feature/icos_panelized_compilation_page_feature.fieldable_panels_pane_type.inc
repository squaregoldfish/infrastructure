<?php
/**
 * @file
 * icos_panelized_compilation_page_feature.fieldable_panels_pane_type.inc
 */

/**
 * Implements hook_default_fieldable_panels_pane_type().
 */
function icos_panelized_compilation_page_feature_default_fieldable_panels_pane_type() {
  $export = array();

  $fieldable_panels_pane_type = new stdClass();
  $fieldable_panels_pane_type->disabled = FALSE; /* Edit this to true to make a default fieldable_panels_pane_type disabled initially */
  $fieldable_panels_pane_type->api_version = 1;
  $fieldable_panels_pane_type->name = 'content_block_pane';
  $fieldable_panels_pane_type->title = 'Content block';
  $fieldable_panels_pane_type->description = 'Content blocks are the main building blocks of compilation pages.';
  $export['content_block_pane'] = $fieldable_panels_pane_type;

  return $export;
}
