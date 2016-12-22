$ ->
	if $.browser.msie && $.browser.version <= 8
		$(document).on 'keyup propertychange', 'input, textarea', ->
			$(this).trigger('input')
	
	if $.fn.jqTransform
		$(document).bind 'reload', ->
			$('form.weimall_form').jqTransform({})
			$('.jqTransformInputWrapper, .jqTransformCheckboxWrapper').trigger('disabledchange')
		$(document).on 'disabledchange', '.jqTransformInputWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqTransformInputWrapper_disabled')
			else
				$(this).removeClass('jqTransformInputWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqTransformRadioWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqTransformRadioWrapper_disabled')
			else
				$(this).removeClass('jqTransformRadioWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqTransformCheckboxWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqTransformCheckboxWrapper_disabled')
			else
				$(this).removeClass('jqTransformCheckboxWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqTransformSelectWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqTransformSelectWrapper_disabled')
			else
				$(this).removeClass('jqTransformSelectWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqTransformTextarea', ->
			if $(this).find('textarea').prop('disabled')
				$(this).addClass('jqTransformTextarea_disabled')
			else
				$(this).removeClass('jqTransformTextarea_disabled')
			false

	if $.fn.jqeraform
		$(document).bind 'reload', ->
			$('form.jqeraform').jqeraform({})
			$('.jqeraformInputWrapper, .jqeraformCheckboxWrapper, .jqeraformRadioWrapper').trigger('disabledchange')
		$(document).on 'disabledchange', '.jqeraformInputWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqeraformInputWrapper_disabled')
			else
				$(this).removeClass('jqeraformInputWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqeraformRadioWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqeraformRadioWrapper_disabled')
			else
				$(this).removeClass('jqeraformRadioWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqeraformCheckboxWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqeraformCheckboxWrapper_disabled')
			else
				$(this).removeClass('jqeraformCheckboxWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqeraformSelectWrapper', ->
			if $(this).find('input').prop('disabled')
				$(this).addClass('jqeraformSelectWrapper_disabled')
			else
				$(this).removeClass('jqeraformSelectWrapper_disabled')
			false
		$(document).on 'disabledchange', '.jqeraformTextarea', ->
			if $(this).find('textarea').prop('disabled')
				$(this).addClass('jqeraformTextarea_disabled')
			else
				$(this).removeClass('jqeraformTextarea_disabled')
			false

