/**
 * @file
 * A JavaScript file for the theme.
 *
 * Do some theming magic like equal height content etc.
 *
 */
(function ($, Drupal, window, document, undefined) {

  Drupal.behaviors.broscience = {
    // Attach the behaviors
    attach: function(context, settings) {
      this.mobileMenuBehavior(context, settings);
      this.carouselBehavior(context, settings);
      this.matchHeightBehavior(context, settings);
    },
    // Equal height content
    matchHeightBehavior: function(context, settings) {

      // 3 col and 2 col region panes in grid
      var colContainers = [
        'top_2_1_1',
        'col_3_1',
        'col_2_1',
        'bottom_2_1_1'
      ];
      var rows = 10; // Predefined max amount of rows to match the height for
      for (i = 0; i < colContainers.length; i++) {
        for (ii = 1; ii <= rows; ii++) {
          // Only do this on Compilation pages
          $('.node-type-panelized-compilation-page .grid-container.' + colContainers[i] + ' .region-inner > div:nth-child(' + ii + ')', context).matchHeight();
        }
      }

      // Vertical tab list and panes
      var checkExist = setInterval(function() {
        // Wait until the tab list is rendered
        if ($('.vertical-tabs-list', context).length) {
          // Make sure the functions are executed only once
          $('.vertical-tabs', context).once('matchHeightBehavior', function() {
            $('.vertical-tabs-list, .vertical-tabs-panes', context).matchHeight();
            // Update the height also when tab is changed
            $('.vertical-tab-button', context).bind('vertical-tab-tab-focus', function() {
              $.fn.matchHeight._update();
            });
          });
          clearInterval(checkExist);
        }
      }, 100); // Check every 100ms

    },
    // Carousel theming
    carouselBehavior: function(context, settings) {

      // Move the Slick carousel dots above the slider
      // and wrap it with a div
      $('.pane-icos-reusable-lists-reusable-carousel .slick', context).each(function() {
        $(this).once('carouselBehavior', function() {
          $('.slick-dots', this).prependTo(this);
        });
      });

    },
    // Mobile menu open and close
    mobileMenuBehavior: function(context, settings) {

      var menuTitle = Drupal.t('Navigation');
      // Create the mobile menu button
      $('#block-menu-block-2').prepend('<div class="broscience_mobile_menu_button"><div class="icon"><span></span><span></span><span></span></div>' + menuTitle + '</div>');
      // Bind the events
      $('.broscience_mobile_menu_button').click(function() {
        $('#block-menu-block-2 .content, #block-menu-block-1 .content').toggleClass('open');
      });

    }

  };


})(jQuery, Drupal, this, this.document);
