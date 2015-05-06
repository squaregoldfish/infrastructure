<?php
/**
 * @file
 * icos_media_feature.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function icos_media_feature_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "ds" && $api == "ds") {
    return array("version" => "1");
  }
  if ($module == "field_group" && $api == "field_group") {
    return array("version" => "1");
  }
  if ($module == "file_entity" && $api == "file_default_displays") {
    return array("version" => "1");
  }
  if ($module == "file_entity" && $api == "file_type") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_image_default_styles().
 */
function icos_media_feature_image_default_styles() {
  $styles = array();

  // Exported image style: icos_header.
  $styles['icos_header'] = array(
    'label' => 'ICOS Header',
    'effects' => array(
      3 => array(
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 2240,
          'height' => 560,
        ),
        'weight' => 1,
      ),
    ),
  );

  // Exported image style: icos_header_medium.
  $styles['icos_header_medium'] = array(
    'label' => 'ICOS Header medium',
    'effects' => array(
      5 => array(
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 1120,
          'height' => 280,
        ),
        'weight' => 1,
      ),
    ),
  );

  // Exported image style: icos_header_small.
  $styles['icos_header_small'] = array(
    'label' => 'ICOS Header small',
    'effects' => array(
      4 => array(
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 560,
          'height' => 140,
        ),
        'weight' => 1,
      ),
    ),
  );

  // Exported image style: icos_large.
  $styles['icos_large'] = array(
    'label' => 'ICOS Large',
    'effects' => array(
      2 => array(
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 1120,
          'height' => 560,
        ),
        'weight' => 2,
      ),
    ),
  );

  // Exported image style: icos_medium.
  $styles['icos_medium'] = array(
    'label' => 'ICOS Medium',
    'effects' => array(
      7 => array(
        'name' => 'image_scale',
        'data' => array(
          'width' => 555,
          'height' => '',
          'upscale' => 1,
        ),
        'weight' => 1,
      ),
      8 => array(
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 560,
          'height' => 280,
        ),
        'weight' => 2,
      ),
    ),
  );

  // Exported image style: icos_original.
  $styles['icos_original'] = array(
    'label' => 'ICOS Original',
    'effects' => array(
      9 => array(
        'name' => 'image_scale',
        'data' => array(
          'width' => 1120,
          'height' => '',
          'upscale' => 1,
        ),
        'weight' => 1,
      ),
    ),
  );

  // Exported image style: icos_square.
  $styles['icos_square'] = array(
    'label' => 'ICOS Square',
    'effects' => array(
      6 => array(
        'name' => 'image_scale_and_crop',
        'data' => array(
          'width' => 560,
          'height' => 560,
        ),
        'weight' => 1,
      ),
    ),
  );

  return $styles;
}
