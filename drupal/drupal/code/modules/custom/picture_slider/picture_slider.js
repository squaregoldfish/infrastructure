(function ($) {	
	Drupal.behaviors.picture_slider = {
		attach: function (context, settings) {	
			if (settings.picture_slider.color) {   
		        $('.block_titel').css({'color': settings.picture_slider.color});
		        $('.glyphicon-chevron-left').css('color', settings.picture_slider.color);
		        $('.glyphicon-chevron-right').css('color', settings.picture_slider.color);
  			}	    
		}	
	};		
}(jQuery));
