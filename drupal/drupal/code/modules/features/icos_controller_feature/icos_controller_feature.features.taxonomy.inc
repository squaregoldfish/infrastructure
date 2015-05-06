<?php
/**
 * @file
 * icos_controller_feature.features.taxonomy.inc
 */

/**
 * Implements hook_taxonomy_default_vocabularies().
 */
function icos_controller_feature_taxonomy_default_vocabularies() {
  return array(
    'category' => array(
      'name' => 'Material category',
      'machine_name' => 'category',
      'description' => 'Category of the material/documents.',
      'hierarchy' => 0,
      'module' => 'taxonomy',
      'weight' => 0,
    ),
    'country' => array(
      'name' => 'Country',
      'machine_name' => 'country',
      'description' => 'Country of the contact person.',
      'hierarchy' => 0,
      'module' => 'taxonomy',
      'weight' => 0,
    ),
    'icos_component' => array(
      'name' => 'ICOS component',
      'machine_name' => 'icos_component',
      'description' => 'ICOS component of a contact person.',
      'hierarchy' => 0,
      'module' => 'taxonomy',
      'weight' => 0,
    ),
    'organisation' => array(
      'name' => 'Organisation',
      'machine_name' => 'organisation',
      'description' => 'Organisation of a contact person.',
      'hierarchy' => 0,
      'module' => 'taxonomy',
      'weight' => 0,
    ),
  );
}
