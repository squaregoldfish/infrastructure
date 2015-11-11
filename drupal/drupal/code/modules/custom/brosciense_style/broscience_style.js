(function ($) {
    Drupal.behaviors.broscience_style = {
        attach: function (context, settings) {

            var titleColor = settings.broscience_style.titleColor;
            var elementColor = settings.broscience_style.elementColor;
            var modulePath = settings.broscience_style.modulePath;

            if (settings.broscience_style.use_submenu) {
                bs_submenu_style(elementColor);
                bs_submenu_place();
                bs_submenu_active(elementColor);

                $(window).resize(function () {
                    bs_submenu_style(elementColor);
                    bs_submenu_place();
                    bs_submenu_active(elementColor);
                });
            }
        }
    };
}(jQuery));


var bs_submenu_min = 799;

function bs_submenu_style(elementColor) {

    if (jQuery(window).width() > bs_submenu_min) {

        jQuery('#block-menu-block-1 .content ul li a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content ul li.leaf a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content ul.menu li a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content ul.menu li.leaf a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content .menu-block-wrapper').css({'padding': '0'});

        jQuery('#block-menu-block-1').css({'min-width': '12rem', 'padding': '0.2rem', 'background-color': elementColor, 'opacity': '1.0'});
        jQuery('#block-menu-block-1 li').css({'display': 'block', 'text-align': 'left'});
        jQuery('#block-menu-block-1 a').css({'padding': '0.4rem', 'color': '#ffffff'});

        jQuery('#block-menu-block-1 li.active-trail ul.menu').css({'margin-left': '0.8rem'});
        jQuery('#block-menu-block-1 li.active ul.menu').css({'margin-left': '0.8rem'});

        jQuery('#block-menu-block-1 li.expanded a.active-trail').css({'color': '#000000'});
        jQuery('#block-menu-block-1 a.active').css({'color': '#000000'});


        jQuery('#block-menu-block-1 a').mouseover(function() {
            jQuery(this).css('background-color', 'rgba(0, 0, 0, 0.1)');
        });
        jQuery('#block-menu-block-1 a').mouseout(function() {
            jQuery(this).css('background-color', elementColor);
        });

    } else {
        jQuery('#block-menu-block-1').css({'background-color': 'ffffff', 'opacity': '0.0'});
    }

}

function bs_submenu_place() {
    if (jQuery(window).width() > bs_submenu_min) {

        var window_size = jQuery(window).width();
        var container_size = jQuery('.field-title').width();
        var menu_size = jQuery('#block-menu-block-1').width();
        var min_size = (window_size - container_size) / 2;

        var o = jQuery('#main').offset();
        console.log('main pos: ' + o.top);

        jQuery('#block-menu-block-1').css({'position': 'absolute', 'top': o.top});


        if ((menu_size < window_size) && (min_size < menu_size)) {
            jQuery('.grid-wrapper').css({'padding-left': menu_size});

        } else {
            jQuery('.grid-wrapper').css({'padding-left': '0'});
        }
    }
}

function bs_submenu_active(elementColor) {
    var w = jQuery('#block-menu-block-1').outerWidth() - 1;
    jQuery('#block-menu-block-1 a.active').append('<span style="position: absolute; left: ' + w + 'px; width: 0; height: 0; border-top: 10px solid transparent; border-bottom: 10px solid transparent; border-left: 20px solid ' + elementColor + ';">&nbsp;&nbsp;&nbsp;&nbsp;</span>');
}