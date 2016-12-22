$(function(){
	$('#search_confirm').live({
		mousedown: function(){
			$('#search_form').submit();
		}
	});
	$('#search_form').live({
		submit: function(){
			keyword = $.trim($('#search_input').val());
			if (keyword == $('#search_input').attr('placeholder')) keyword == '';
			window.go({ pushState: true, callback: function(){ $(document).trigger('autoload'); } }, '', $(this).attr('action')+'?'+$(this).serialize());
			return false;
		}
	});
	$('#search_input').live({
		focus: function(){
			$(this).addClass('focus');
			$('#filter_conditions').show(200);
			if($(this).val() == $(this).attr('placeholder')) $(this).val('');
			if ($(this).data('synonyms_reader') || $('body').data('synonyms')) return;
			$(this).data('synonyms_reader', $.ajax({
				url: '/auction/synonyms.json',
				data: { 'order[id]': 'asc', per_page: 9999 },
				context: this,
				success: function(data){
					$('body').data('synonyms', data['synonyms']);
				}
			}));
		},
		blur: function(){
			$(this).removeClass('focus');
			$('#filter_conditions').hide(200, function(){ $(this).remove(); });
			if($(this).val() == '') $(this).val($(this).attr('placeholder'));
			$('#nav_search_suggest').hide();
		},
		suggest: function(){
			$('#nav_search_suggest').data('keyword', $(this).val().replace(/^\s+|\s+$/g,''));
			synonyms = $(this).data('current_synonyms');
			if (!synonyms.length) { $('#nav_search_suggest').hide(); return; }
			$('#nav_search_suggest').html($.map(synonyms, function(a){ return '<li><a href="/auction/products?'+$.map(['brand_id','category1_id','category2_id','target','color'], function(f){ return a[f] ? '&where['+f+']='+encodeURIComponent(a[f]) : '' }).join('')+'">'+a['name']+'</a></li>'; }).join('')).show().find('a:first').addClass('current');
			$('#nav_search_suggest').show();
		},
		input: function(){
			keyword = $(this).val().replace(/^\s+|\s+$/g,'');
			if (keyword == $('#nav_search_suggest').data('keyword')) return;
			if ((suggester = $(this).data('suggester')) && suggester.readyState > 0 && suggester.readyState < 4) suggester.abort();
			if (keyword == '') { $('#nav_search_suggest').data('keyword', '').hide(); return; }
			if ($('body').data('synonyms')) {
				$(this).data('current_synonyms', $.grep($.grep($('body').data('synonyms'), $.proxy(function(a){ return (new RegExp($(this).val().replace(/^\s+|\s+$/g,'').toLowerCase())).test(a['name'].toLowerCase()); }, this)), function(a, i){ return i < 10; })).trigger('suggest');
				
			} else {
				$(this).data('suggester', $.ajax({
					url: '/auction/synonyms.json',
					data: { 'where[name][like]': '%'+keyword+'%', 'order[id]': 'asc', per_page: 10 },
					context: this,
					success: function(data){
						$(this).data('current_synonyms', data['synonyms']).trigger('suggest');
					},
					error: function(){
						$('#nav_search_suggest').hide();
					}
				}));
			}
		}
	});
	$('#nav_search_suggest a').live({
		mouseover: function(){
			if ($(this).hasClass('current')) return;
			$('#nav_search_suggest a.current').removeClass('current');
			$(this).addClass('current');
		}
	});
})
