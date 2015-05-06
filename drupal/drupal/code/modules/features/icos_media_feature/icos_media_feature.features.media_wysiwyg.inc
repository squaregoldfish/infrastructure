<?php
/**
 * @file
 * icos_media_feature.features.media_wysiwyg.inc
 */

/**
 * Implements hook_media_wysiwyg_defaults().
 */
function icos_media_feature_media_wysiwyg_defaults() {
  $media_wysiwyg = array();

  // WYSIWYG view mode for icos_document files.
  $media_wysiwyg['icos_document_wysiwyg_view_mode'] = 'none';

  // Restricted view modes for icos_document files.
  $media_wysiwyg['icos_document_preview_restrict_wysiwyg'] = TRUE;
  $media_wysiwyg['icos_document_default_restrict_wysiwyg'] = TRUE;

  // WYSIWYG view mode for icos_image files.
  $media_wysiwyg['icos_image_wysiwyg_view_mode'] = 'large';

  // Restricted view modes for icos_image files.
  $media_wysiwyg['icos_image_preview_restrict_wysiwyg'] = TRUE;
  $media_wysiwyg['icos_image_large_restrict_wysiwyg'] = FALSE;
  $media_wysiwyg['icos_image_original_restrict_wysiwyg'] = FALSE;
  $media_wysiwyg['icos_image_square_restrict_wysiwyg'] = TRUE;
  $media_wysiwyg['icos_image_default_restrict_wysiwyg'] = TRUE;

  return $media_wysiwyg;
}
