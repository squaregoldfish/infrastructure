(function ($) {	
	Drupal.behaviors.picture_slider_form = {
		attach: function (context, settings) {	
			
			var list = $('#picture_slider_options div.form-type-checkbox :checkbox');
			
			$('#picture_slider_options').append('<table><tr><th style="width: 60px"></th><th></th></tr></table>');
			
			list.each(function(i, e) { 
				var img = '<img src="http://localhost:8095/'+$(this).val()+'" width="40" heigth="40"/>';
				var name = $(this).parent().find('label').text();
				
				$(this).parent().find('label').remove();
				
				$('#picture_slider_options table').append('<tr><td>' + img + '</td><td>' + $(this).parent().html() + '' + name + '</td></tr>');	
			});

			$('#picture_slider_options div.form-type-checkboxes').remove();
		}	
	};		
}(jQuery));
