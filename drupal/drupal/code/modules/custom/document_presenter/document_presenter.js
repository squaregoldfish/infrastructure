(function ($) {
    Drupal.behaviors.document_presenter = {
        attach: function (context, settings) {

            size_up();


            $( window ).resize(function() {
                size_up();
            });

        }
    };
}(jQuery));

function size_up() {
    var width = $('#document_presenter_accordion_1').width();
    var a1_width = $('#document_presenter_accordion_1 h3 a').width();
    $('#document_presenter_accordion_1 h3 a').css({'position' : 'relative', 'left' : width - a1_width - 90});
    var a1_width = $('#document_presenter_accordion_2 h3 a').width();
    $('#document_presenter_accordion_2 h3 a').css({'position' : 'relative', 'left' : width - a1_width - 90});
    var a1_width = $('#document_presenter_accordion_3 h3 a').width();
    $('#document_presenter_accordion_3 h3 a').css({'position' : 'relative', 'left' : width - a1_width - 90});
    var a1_width = $('#document_presenter_accordion_4 h3 a').width();
    $('#document_presenter_accordion_4 h3 a').css({'position' : 'relative', 'left' : width - a1_width - 90});
    var a1_width = $('#document_presenter_accordion_5 h3 a').width();
    $('#document_presenter_accordion_5 h3 a').css({'position' : 'relative', 'left' : width - a1_width - 90});
}