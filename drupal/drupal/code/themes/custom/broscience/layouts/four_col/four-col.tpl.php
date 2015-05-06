<?php
/**
 * @file
 * Template for a four column layout.
 *
 * This template provides a panel display layout with one four column row.
 *
 * Variables:
 * - $css_id: An optional CSS id to use for the layout.
 * - $content: An array of content, each item in the array is keyed to one
 *   panel of the layout.
 */
?>
<div class="display four-col  clearfix" <?php if (!empty($css_id)) { print "id=\"$css_id\""; } ?>>
  <?php
    foreach ($content as $id => $region) {
      // Don't print empty regions
      if (!empty($region)) {
        $attributes['class'] = array(
          'region',
          $id
        );
        print "<div" . drupal_attributes($attributes) . "><div class='region-inner'>$region</div></div>\n";
      }
    }
  ?>
</div>
