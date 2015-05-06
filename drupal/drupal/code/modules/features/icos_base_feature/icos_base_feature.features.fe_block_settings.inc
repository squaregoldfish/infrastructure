<?php
/**
 * @file
 * icos_base_feature.features.fe_block_settings.inc
 */

/**
 * Implements hook_default_fe_block_settings().
 */
function icos_base_feature_default_fe_block_settings() {
  $export = array();

  $export['version'] = '2.0';

  $export['menu_block-1'] = array(
    'cache' => -1,
    'custom' => 0,
    'delta' => 1,
    'module' => 'menu_block',
    'node_types' => array(),
    'pages' => '',
    'roles' => array(),
    'themes' => array(
      'aurora' => array(
        'region' => 'header',
        'status' => 1,
        'theme' => 'aurora',
        'weight' => -9,
      ),
      'broscience' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'broscience',
        'weight' => -11,
      ),
      'responsive_bartik' => array(
        'region' => 'featured',
        'status' => 1,
        'theme' => 'responsive_bartik',
        'weight' => -9,
      ),
      'shiny' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'shiny',
        'weight' => 0,
      ),
      'shiny_icos' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'shiny_icos',
        'weight' => 0,
      ),
    ),
    'title' => '<none>',
    'visibility' => 0,
  );

  $export['menu_block-2'] = array(
    'cache' => -1,
    'custom' => 0,
    'delta' => 2,
    'module' => 'menu_block',
    'node_types' => array(),
    'pages' => '',
    'roles' => array(),
    'themes' => array(
      'aurora' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'aurora',
        'weight' => 0,
      ),
      'broscience' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'broscience',
        'weight' => -12,
      ),
      'responsive_bartik' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'responsive_bartik',
        'weight' => 0,
      ),
      'shiny' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'shiny',
        'weight' => 0,
      ),
      'shiny_icos' => array(
        'region' => '',
        'status' => 0,
        'theme' => 'shiny_icos',
        'weight' => 0,
      ),
    ),
    'title' => '<none>',
    'visibility' => 0,
  );

  return $export;
}
