<?php
/**
 * @file
 * Minimal template for a two column layout.
 *
 * This template provides a Display Suite display layout with two columns.
 *
 * Variables:
 * - $css_id: An optional CSS id to use for the layout.
 * - $content: An array of content, each item in the array is keyed to one
 *   panel of the layout.
 */
?>

<<?php print $layout_wrapper; print $layout_attributes; ?> class="<?php print $classes;?> display two-col-without-styles clearfix">

<?php if (isset($title_suffix['contextual_links'])): ?>
  <?php print render($title_suffix['contextual_links']); ?>
<?php endif; ?>

<?php
  $display_layout_regions = array(
    'left',
    'right',
  );
  foreach ($display_layout_regions as $display_layout_region) {
    // Don't print empty regions
    if (empty($variables[$display_layout_region])) {
      continue;
    }
    $display_layout_attributes['class'] = array(
      'block-region',
      $display_layout_region
    );
    $display_layout_region_classes = explode(" ", $variables[$display_layout_region . "_classes"]);
    foreach ($display_layout_region_classes as $key => $display_layout_region_class) {
      if (empty($display_layout_region_class)) {
        unset($display_layout_region_classes[$key]);
      }
    }
    $display_layout_attributes['class'] = array_merge($display_layout_attributes['class'], $display_layout_region_classes);

    print "<" . $variables[$display_layout_region . "_wrapper"] . drupal_attributes($display_layout_attributes) . "><div class='region-inner'>$variables[$display_layout_region]</div></" . $variables[$display_layout_region . "_wrapper"] . ">\n";

  }
?>

</<?php print $layout_wrapper ?>>

<?php if (!empty($drupal_render_children)): ?>
  <?php print $drupal_render_children ?>
<?php endif; ?>
