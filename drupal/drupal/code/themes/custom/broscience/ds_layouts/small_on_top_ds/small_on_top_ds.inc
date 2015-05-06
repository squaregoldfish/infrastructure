<?php

/**
 * @file
 * Display Suite Page configuration.
 */

function ds_small_on_top_ds() {
  return array(
    'label' => t('Small on top'),
    'regions' => array(
      'title' => t('Title'),
      'top_2_1_1' => t('2/1 top first'),
      'top_2_1_2' => t('2/1 top second'),
      'full_top' => t('Full width top'),
      'col_3_1' => t('3 columns first'),
      'col_3_2' => t('3 columns second'),
      'col_3_3' => t('3 columns third'),
      'col_2_1' => t('2 columns first'),
      'col_2_2' => t('2 columns second'),
      'bottom_2_1_1' => t('2/1 bottom first'),
      'bottom_2_1_2' => t('2/1 bottom second'),
      'full_bottom' => t('Full width bottom'),
    )
  );
}
