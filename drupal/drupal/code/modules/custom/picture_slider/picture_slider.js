(function ($) {	
	Drupal.behaviors.picture_slider = {
		attach: function (context, settings) {	
			if (settings.picture_slider.color) {   
		        $('.block_titel').css({'color': settings.picture_slider.color});
		        $('.glyphicon-chevron-up').css('color', settings.picture_slider.color);
		        $('.glyphicon-chevron-down').css('color', settings.picture_slider.color);	             	   
  			}	    
		}	
	};		
}(jQuery));
