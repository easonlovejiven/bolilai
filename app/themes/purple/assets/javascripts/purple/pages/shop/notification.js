$(function(){
	$(document).on({
		keyup: function(event){
			if (event.keyCode == 13) $('#notification_email').focus().select()
		}
	}, '#notification_measure')
	$(document).on({
		input: function(){
			var val = $(this).val().replace(/\s+/g, '')
			if (val != $(this).val()) $(this).val(val)
			$(this).data('checking', false).closest('form').submit()
		},
		blur: function(){
			$(this).data('checking', true).closest('form').submit()
		},
		keyup: function(event){
			if (event.keyCode == 13) $('#notification_mobile').focus().select()
		}
	}, '#notification_email');
	$(document).on({
		input: function(){
			var val = $(this).val().replace(/[^\d]+/g, '').substring(0, 11)
			if (val != $(this).val()) $(this).val(val)
			$(this).data('checking', false).closest('form').submit()
		},
		blur: function(){
			$(this).data('checking', true).closest('form').submit()
		},
		keyup: function(event){
			if (event.keyCode == 13) $('#notification_comment').focus().select()
		}
	}, '#notification_mobile');
	$(document).on({
		input: function(){
			var val = $(this).val().substring(0, 200)
			if (val != $(this).val()) $(this).val(val)
			$(this).data('checking', false).closest('form').submit()
		},
		blur: function(){
			$(this).data('checking', true).closest('form').submit()
		}
	}, '#notification_comment');
	$(document).on({
		mousedown: function(){
			$(this).closest('form').data('submitting', true).submit();
		}
	}, '#notification_confirm');
	$(document).on({
		submit: function(event){
			event.preventDefault();
			if ($(this).hasClass('disabled')) return;
			
			var email = $('#notification_email').val();
			var email_valid = email == '' || email.match(/^[a-z0-9\.\_]+@([a-z0-9]+\.)+[a-z]+$/i);
			if (email_valid) $('#notification_email_error').hide();
			if (!email_valid && $('#notification_email').data('checking')) $('#notification_email_error').show();
			
			var phone = $('#notification_mobile').val();
			var phone_valid = phone == '' || phone.match(/^1\d{10}$/);
			if (phone_valid) $('#notification_mobile_error').hide();
			if (!phone_valid && $('#notification_mobile').data('checking')) $('#notification_mobile_error').show();
			
			var email_or_phone_valid = $('#notification_email').val() != '' || $('#notification_mobile').val() != '';
			
			if (email_valid && phone_valid && email_or_phone_valid) $('#notification_confirm').removeClass('disabled');
			else $('#notification_confirm').addClass('disabled');
			
			if (!$(this).data('submitting') || $(this).hasClass('disabled') || $('#notification_confirm').hasClass('disabled')) { $(this).data('submitting', false); return; }
			$(this).data('submitting', false);
			
			$.ajax({
				url: $(this).attr('action')+'.json',
				type: 'post',
				data: $(this).serialize(),
				context: this,
				beforeSend: function(){
					$(this).addClass('disabled');
					$('#notification_confirm').addClass('disabled');
				},
				complete: function(){
					$(this).removeClass('disabled');
					$('#notification_confirm').removeClass('disabled');
				},
				success: function(data){
					if (data['error']) return;
					$('#notification_new').hide();
					$('#notification_success').show();
				}
			});
			return false;
		}
	}, '#notification_form');
});
