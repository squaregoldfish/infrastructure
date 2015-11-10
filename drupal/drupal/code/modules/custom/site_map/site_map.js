(function ($) {
    Drupal.behaviors.document_presenter = {
        attach: function (context, settings) {
            cp_site_map_build();
            cp_site_map_style(settings.site_map.title_color, settings.site_map.element_color);
        }
    };
}(jQuery));

function cp_site_map_build() {

    var cp_elements = [];
    jQuery('.cp_site_map_element').each(function() {
        cp_elements.push(jQuery(this));
        jQuery(this).detach();
    });


    while (cp_elements.length > 0) {
        jQuery(cp_elements).each(function () {

            var done = 1;
            var li_element_1 = '<li><a href="' + jQuery(this).attr('cp_link_path') + '">' + jQuery(this).attr('cp_title') + '</a>';
            var li_element_2 = '</li>';

            if (jQuery(this).attr('cp_parent_node') === '0') {
                jQuery('#cp_site_map').append('<ul>' + li_element_1 + '<ul id="'+ jQuery(this).attr('cp_node') + '" class="cp_nodes"></ul>' + li_element_2 + '</ul>');
                done = 1;

            } else if (jQuery(this).attr('cp_has_children') === '1') {
                jQuery('#cp_site_map #' + this.attr('cp_parent_node')).append(li_element_1 + '<ul id="' + jQuery(this).attr('cp_node') + '"></ul>' + li_element_2);
                done = 1;

            } else if (jQuery('#' + this.attr('cp_parent_node')).length > 0) {
                jQuery('#' + this.attr('cp_parent_node')).append(li_element_1 + li_element_2);
                done = 1;

            }

            if (done === 1) {
                var index = cp_elements.indexOf(jQuery(this));
                cp_elements.splice(index, 1);
            }

        });
    }

}

function cp_site_map_style(title_color, element_color) {
    jQuery('#cp_site_map').css({'': ''});
    jQuery('#cp_site_map ul li').css({'margin-left': '2rem'});
    jQuery('#cp_site_map a').css({'padding': '0.1rem', 'color': element_color});
    jQuery('#cp_site_map ul.cp_nodes').css({'padding-bottom': '1rem'});
    jQuery('#cp_site_map ul.cp_nodes ul').css({'margin-bottom': '0.5rem', 'margin-left': '1rem'});

}
