<?php
/**
 * @file
 * Template for a small on top layout.
 *
 * This template provides a panel display layout with three column row
 * on the top and a two column row below it, with additional areas
 * for the top and the bottom.
 *
 * Variables:
 * - $css_id: An optional CSS id to use for the layout.
 * - $content: An array of content, each item in the array is keyed to one
 *   panel of the layout.
 */
?>
<div class="display small-on-top  clearfix" <?php if (!empty($css_id)) { print "id=\"$css_id\""; } ?>>
  <?php
    foreach ($content as $id => $region) {
      // Containers for regions, always print these
      if (
        $id == 'title' ||
        $id == 'top_2_1_1' ||
        $id == 'full_top' ||
        $id == 'col_3_1' ||
        $id == 'col_2_1' ||
        $id == 'bottom_2_1_1' ||
        $id == 'full_bottom'
      ) {
        print "<div class='grid-wrapper " . $id . "'><div class='grid-container " . $id . "'>";
      }

      // Don't print empty regions
      if (!empty($region)) {
        $attributes['class'] = array(
          'region',
          $id
        );
        print "<div" . drupal_attributes($attributes) . "><div class='region-inner'>$region</div></div>\n";
      }

      // Containers for regions, always print these
      if (
        $id == 'title' ||
        $id == 'top_2_1_2' ||
        $id == 'full_top' ||
        $id == 'col_3_3' ||
        $id == 'col_2_2' ||
        $id == 'bottom_2_1_2' ||
        $id == 'full_bottom'
      ) {
        print "</div></div>";
      }
    }
  ?>
</div>
