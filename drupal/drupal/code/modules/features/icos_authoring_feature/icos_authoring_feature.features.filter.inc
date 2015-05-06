<?php
/**
 * @file
 * icos_authoring_feature.features.filter.inc
 */

/**
 * Implements hook_filter_default_formats().
 */
function icos_authoring_feature_filter_default_formats() {
  $formats = array();

  // Exported format: WYSIWYG.
  $formats['wysiwyg'] = array(
    'format' => 'wysiwyg',
    'name' => 'WYSIWYG',
    'cache' => 1,
    'status' => 1,
    'weight' => 0,
    'filters' => array(
      'ckeditor_link_filter' => array(
        'weight' => -46,
        'status' => 1,
        'settings' => array(),
      ),
      'media_filter' => array(
        'weight' => -43,
        'status' => 1,
        'settings' => array(),
      ),
      'responsive_frames' => array(
        'weight' => -42,
        'status' => 1,
        'settings' => array(
          'frames' => 'iframe',
          'include_css' => 1,
          'ratio' => '16:9',
        ),
      ),
    ),
  );

  return $formats;
}
