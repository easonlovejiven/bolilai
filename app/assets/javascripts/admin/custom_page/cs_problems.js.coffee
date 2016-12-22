$ ->
	$('.auction_pages .cs_problems dt').each ->
		index = $(this).closest('dl').index()
		configuration = {
			name: '问题（' + (index + 1) + '）'
			fields: [
				{
					name: '名称'
					route: ['problems', index, 'name']
				}
				{
					name: '提问'
					route: ['problems', index, 'question']
					update: {
						type: 'text'
						selector: '.auction_pages .cs_problems dl:eq(' + index + ') dt .question'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.auction_pages .cs_problems dd').each ->
		index = $(this).closest('dl').index()
		configuration = {
			name: '回答（' + (index + 1) + '）',
			fields: [
				{
					name: '回答'
					route: ['problems', index, 'answer']
					input: 'textarea'
					update: {
						type: 'text'
						selector: '.auction_pages .cs_problems dl:eq(' + index + ') dd'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
