(function ($) {	
	Drupal.behaviors.picture_slider_form = {
		attach: function (context, settings) {	
			var list = $('#picture_slider_options div.form-type-checkbox :checkbox');
			$('#picture_slider_options div.form-type-checkboxes').remove();
			
			list.each(function(i, e) { 
				var img = '<img src="/'+$(this).val()+'" width="40" height="auto"/>';
				
				var name = $(this).parent().find('label').text();				
				$(this).parent().find('label').remove();
				
				$('#picture_slider_options').append('<table class="content"><tr><td>' + img + '</td><td>' + $(this).parent().html() +  name + '</td></tr></table>');		
			});

			$('#picture_slider_options table.content').css({'display': 'inline', 'padding': '0px 80px 0px 0px', 'border': 'none'});
		}	
	};		
}(jQuery));
