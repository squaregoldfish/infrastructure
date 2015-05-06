<?php
/**
 * @file
 * icos_media_feature.file_type.inc
 */

/**
 * Implements hook_file_default_types().
 */
function icos_media_feature_file_default_types() {
  $export = array();

  $file_type = new stdClass();
  $file_type->disabled = FALSE; /* Edit this to true to make a default file_type disabled initially */
  $file_type->api_version = 1;
  $file_type->type = 'icos_document';
  $file_type->label = 'Document';
  $file_type->description = 'A <em>Document</em> file is written information.';
  $file_type->mimetypes = array(
    0 => 'text/plain',
    1 => 'application/msword',
    2 => 'application/vnd.ms-excel',
    3 => 'application/pdf',
    4 => 'application/vnd.ms-powerpoint',
    5 => 'application/vnd.oasis.opendocument.text',
    6 => 'application/vnd.oasis.opendocument.spreadsheet',
    7 => 'application/vnd.oasis.opendocument.presentation',
    8 => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    9 => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    10 => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  );
  $export['icos_document'] = $file_type;

  $file_type = new stdClass();
  $file_type->disabled = FALSE; /* Edit this to true to make a default file_type disabled initially */
  $file_type->api_version = 1;
  $file_type->type = 'icos_image';
  $file_type->label = 'Image';
  $file_type->description = 'An <em>Image</em> file is a still visual.';
  $file_type->mimetypes = array(
    0 => 'image/*',
  );
  $export['icos_image'] = $file_type;

  return $export;
}
