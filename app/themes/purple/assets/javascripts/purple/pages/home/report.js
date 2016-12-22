$(function(){
	$(document).on({
		input: function(){
			var val = $(this).val().strip();
			if (val.length > 0) $('#user_report_confirm').removeClass('disabled');
			else $('#user_report_confirm').addClass('disabled');
			if (val.length > 1000) $(this).val(val.substring(0,1000));
		}
	}, '#user_report_description');
	$(document).on({
		mousedown: function(){
			if ($(this).hasClass('disabled')) return;
			$('#user_report_form').submit();
		},
		click: function(){
			return false;
		}
	}, '#user_report_confirm');
	$(document).on({
		submit: function(){
			if ($(this).hasClass('disabled')) return;
			$.ajax({
				url: $(this).attr('action')+'.json',
				type: 'post',
				data: $(this).serialize(),
				context: this,
				beforeSend: function(){
					$(this).addClass('disabled');
					$('#user_report_confirm').addClass('disabled');
				},
				complete: function(){
					$(this).removeClass('disabled');
					$('#user_report_confirm').removeClass('disabled');
				},
				success: function(data){
					if (data['error']) return;
					$('#user_report_new').hide();
					$('#user_report_success').show();
				}
			});
			return false;
		}
	}, '#user_report_form');
});
