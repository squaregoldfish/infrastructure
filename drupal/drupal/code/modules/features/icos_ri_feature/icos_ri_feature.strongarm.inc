<?php
/**
 * @file
 * icos_ri_feature.strongarm.inc
 */

/**
 * Implements hook_strongarm().
 */
function icos_ri_feature_strongarm() {
  $export = array();

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'date_default_timezone';
  $strongarm->value = 'Europe/Helsinki';
  $export['date_default_timezone'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'minimal_share';
  $strongarm->value = array(
    'services' => array(
      'facebook' => array(
        'enabled' => 0,
        'label_type' => 'name',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '0',
      ),
      'twitter' => array(
        'enabled' => 1,
        'label_type' => 'icon',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '1',
      ),
      'gplus' => array(
        'enabled' => 0,
        'label_type' => 'name',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '2',
      ),
      'linkedin' => array(
        'enabled' => 1,
        'label_type' => 'icon',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '3',
      ),
      'pinterest' => array(
        'enabled' => 0,
        'label_type' => 'name',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '4',
      ),
      'tumblr' => array(
        'enabled' => 0,
        'label_type' => 'name',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '5',
      ),
      'email' => array(
        'enabled' => 0,
        'label_type' => 'name',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '6',
      ),
      'print' => array(
        'enabled' => 0,
        'label_type' => 'name',
        'hide_zero' => 1,
        'custom' => '',
        'weight' => '7',
      ),
    ),
    'advanced' => array(
      'cache_lifetime' => '900',
    ),
  );
  $export['minimal_share'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'site_default_country';
  $strongarm->value = 'FI';
  $export['site_default_country'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'site_mail';
  $strongarm->value = 'admin@example.com';
  $export['site_mail'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'site_name';
  $strongarm->value = 'ICOS EU';
  $export['site_name'] = $strongarm;

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'theme_default';
  $strongarm->value = 'broscience';
  $export['theme_default'] = $strongarm;

  return $export;
}
