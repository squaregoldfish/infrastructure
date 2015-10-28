(function ($) {
    Drupal.behaviors.broscience_style = {
        attach: function (context, settings) {

            style_bs_submenu(settings.broscience_style.elementColor);
            place_bs_submenu();
            set_bs_active(settings.broscience_style.elementColor);

            $(window).resize(function() {
                style_bs_submenu(settings.broscience_style.elementColor);
                place_bs_submenu();
                set_bs_active(settings.broscience_style.elementColor);
            });
        }
    };
}(jQuery));


var min = 800;


function place_bs_submenu() {
    if (jQuery(window).width() > min) {
        var top_position = jQuery('#header').height() * 2;

        if (jQuery('#tabs').height() > 0) {
            top_position += 120;
        }

        jQuery('#block-menu-block-1').css({'position': 'absolute', 'top': top_position})
    }
}


function style_bs_submenu(elementColor) {
    if (jQuery(window).width() > min) {
        jQuery('#block-menu-block-1 .content ul li a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content ul li.leaf a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content ul.menu li a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content ul.menu li.leaf a').css({'padding': '0'});
        jQuery('#block-menu-block-1 .content .menu-block-wrapper').css({'padding': '0'});

        jQuery('#block-menu-block-1').css({'min-width': '12rem', 'padding': '0.2rem', 'background-color': elementColor});
        jQuery('#block-menu-block-1 li').css({'display': 'block', 'text-align': 'left'});
        jQuery('#block-menu-block-1 a').css({'padding': '0.4rem', 'color': '#ffffff'});

        jQuery('#block-menu-block-1 li.active-trail ul.menu').css({'margin-left': '0.8rem'});
        jQuery('#block-menu-block-1 li.active ul.menu').css({'margin-left': '0.8rem'});

        jQuery('#block-menu-block-1 li.expanded a.active-trail').css({'color': '#414042'});
        jQuery('#block-menu-block-1 a.active').css({'color': '#414042'});

        jQuery('#block-menu-block-1 a').mouseover(function() {
            jQuery(this).css('background-color', 'rgba(0, 0, 0, 0.1)');
        });
        jQuery('#block-menu-block-1 a').mouseout(function() {
            jQuery(this).css('background-color', elementColor);
        });
    }
}


function set_bs_active(elementColor) {
    var w = jQuery('#block-menu-block-1').outerWidth() - 1;
    jQuery('#block-menu-block-1 a.active').append('<span style="position: absolute; left: ' + w + 'px; width: 0; height: 0; border-top: 10px solid transparent; border-bottom: 10px solid transparent; border-left: 20px solid ' + elementColor + ';">&nbsp;&nbsp;&nbsp;&nbsp;</span>');
}