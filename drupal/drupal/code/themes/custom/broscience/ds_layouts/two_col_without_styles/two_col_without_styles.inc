<?php

/**
 * @file
 * Display Suite Page configuration.
 */

function ds_two_col_without_styles() {
  return array(
    'label' => t('Two column without styles'),
    'regions' => array(
      'left' => t('Left'),
      'right' => t('Right'),
    )
  );
}
