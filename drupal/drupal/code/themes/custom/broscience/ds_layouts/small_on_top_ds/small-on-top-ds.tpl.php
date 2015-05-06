<?php
/**
 * @file
 * Template for a small on top layout.
 *
 * This template provides a Display Suite display layout with three column row
 * on the top and a two column row below it, with additional areas
 * for the top and the bottom.
 *
 * Variables:
 * - $css_id: An optional CSS id to use for the layout.
 * - $content: An array of content, each item in the array is keyed to one
 *   panel of the layout.
 */
?>

<<?php print $layout_wrapper; print $layout_attributes; ?> class="<?php print $classes;?> display small-on-top clearfix">

<?php if (isset($title_suffix['contextual_links'])): ?>
  <?php print render($title_suffix['contextual_links']); ?>
<?php endif; ?>

<?php
  $small_on_top_regions = array(
    'title',
    'top_2_1_1',
    'top_2_1_2',
    'full_top',
    'col_3_1',
    'col_3_2',
    'col_3_3',
    'col_2_1',
    'col_2_2',
    'bottom_2_1_1',
    'bottom_2_1_2',
    'full_bottom',
  );
  foreach ($small_on_top_regions as $small_on_top_region) {
    $small_on_top_attributes['class'] = array(
      'region',
      $small_on_top_region
    );
    $small_on_top_region_classes = explode(" ", $variables[$small_on_top_region . "_classes"]);
    foreach ($small_on_top_region_classes as $key => $small_on_top_region_class) {
      if (empty($small_on_top_region_class)) {
        unset($small_on_top_region_classes[$key]);
      }
    }
    $small_on_top_attributes['class'] = array_merge($small_on_top_attributes['class'], $small_on_top_region_classes);

    // Containers for regions, always print these
    if (
      $small_on_top_region == 'title' ||
      $small_on_top_region == 'top_2_1_1' ||
      $small_on_top_region == 'full_top' ||
      $small_on_top_region == 'col_3_1' ||
      $small_on_top_region == 'col_2_1' ||
      $small_on_top_region == 'bottom_2_1_1' ||
      $small_on_top_region == 'full_bottom'
    ) {
      print "<div class='grid-wrapper " . $small_on_top_region . "'><div class='grid-container " . $small_on_top_region . "'>";
    }

    // Don't print empty regions
    if (!empty($variables[$small_on_top_region])) {
      print "<" . $variables[$small_on_top_region . "_wrapper"] . drupal_attributes($small_on_top_attributes) . "><div class='region-inner'>$variables[$small_on_top_region]</div></" . $variables[$small_on_top_region . "_wrapper"] . ">\n";
    }

    // Containers for regions, always print these
    if (
      $small_on_top_region == 'title' ||
      $small_on_top_region == 'top_2_1_2' ||
      $small_on_top_region == 'full_top' ||
      $small_on_top_region == 'col_3_3' ||
      $small_on_top_region == 'col_2_2' ||
      $small_on_top_region == 'bottom_2_1_2' ||
      $small_on_top_region == 'full_bottom'
    ) {
      print "</div></div>";
    }
  }
?>

</<?php print $layout_wrapper ?>>

<?php if (!empty($drupal_render_children)): ?>
  <?php print $drupal_render_children ?>
<?php endif; ?>
